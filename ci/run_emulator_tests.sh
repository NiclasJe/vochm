#!/usr/bin/env bash
set -euo pipefail
set -x

# Set artifacts directory to workspace root (before any cd commands)
ARTIFACTS_DIR="$(pwd)"
echo "Artifacts will be saved to: $ARTIFACTS_DIR"

# reset adb to avoid 'device offline' leftover state
adb kill-server || true
adb start-server || true

# Wait for emulator device to appear
echo "Waiting for emulator device to be listed by adb..."
for i in $(seq 1 150); do
  if adb devices | grep -E '^emulator-[0-9]+' >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

EMULATOR_SERIAL=$(adb devices | awk '/^emulator-/{print $1; exit}')
if [ -z "${EMULATOR_SERIAL:-}" ]; then
  echo "ERROR: No emulator device found"
  adb devices
  exit 1
fi
echo "Emulator serial: $EMULATOR_SERIAL"

# Wait for device to be 'device' and for Android boot to complete
echo "Waiting for emulator to be ONLINE and for sys.boot_completed..."
for i in $(seq 1 900); do    # up to 30 minutes if needed
  STATE=$(adb -s "$EMULATOR_SERIAL" get-state 2>/dev/null || echo "unknown")
  echo "State: $STATE"
  if [ "$STATE" = "device" ]; then
    BOOT_COMPLETED=$(adb -s "$EMULATOR_SERIAL" shell getprop sys.boot_completed 2>/dev/null || echo "")
    if [ "$BOOT_COMPLETED" = "1" ]; then
      echo "sys.boot_completed=1"
      break
    fi
  fi
  sleep 2
done

BOOT_COMPLETED=$(adb -s "$EMULATOR_SERIAL" shell getprop sys.boot_completed || echo "")
if [ "$BOOT_COMPLETED" != "1" ]; then
  echo "ERROR: Emulator did not finish booting. sys.boot_completed='$BOOT_COMPLETED'"
  adb -s "$EMULATOR_SERIAL" shell getprop | sed -n '1,200p' || true
  exit 1
fi

# Unlock and settle
adb -s "$EMULATOR_SERIAL" shell input keyevent 82 || true
sleep 5

# Extra stabilizing sleep to ensure services (including VM Service) are up
echo "Adding extra stabilization time for services to be fully ready..."
sleep 10

# Start logcat capture in background
LOGFILE="${ARTIFACTS_DIR}/ci-emulator-logcat-live.txt"
adb -s "$EMULATOR_SERIAL" logcat -v time > "$LOGFILE" 2>&1 & LOGCAT_PID=$!
echo "Started logcat (pid=$LOGCAT_PID) -> $LOGFILE"

# Change to flutter app folder and ensure dependencies
cd vochm/vochm_flutter
flutter pub get

# Helper: run a single integration test file with diagnostics and retries
run_test_file() {
  local file="$1"
  local tries=2
  local attempt=0

  while [ $attempt -lt $tries ]; do
    attempt=$((attempt+1))
    echo "Running test file: $file (attempt $attempt/$tries)"
    # Clean previous app on device
    adb -s "$EMULATOR_SERIAL" shell am force-stop com.example.vochm_flutter || true
    # Remove any previous forward to avoid collisions
    adb forward --remove-all || true

    # Start test (the flutter tool will build, install and forward ports)
    # Add timeout of 180s to allow slower CI environments to connect to VM Service
    if flutter test "$file" --timeout=180s --verbose; then
      echo "Test $file passed"
      return 0
    fi

    echo "Test $file failed on attempt $attempt — collecting diagnostics"
    # collect adb forward mapping
    adb forward --list > "${ARTIFACTS_DIR}/ci-adb-forward-list.txt" || true
    # collect dumpsys, ps and logcat snapshot
    adb -s "$EMULATOR_SERIAL" shell dumpsys activity > "${ARTIFACTS_DIR}/ci-dumpsys-activity.txt" || true
    adb -s "$EMULATOR_SERIAL" shell ps -A > "${ARTIFACTS_DIR}/ci-ps.txt" || true
    adb -s "$EMULATOR_SERIAL" logcat -d > "${ARTIFACTS_DIR}/ci-emulator-logcat-snapshot.txt" || true
    # wait a bit before retry
    sleep 5
  done

  return 1
}

# Run each integration_test file individually
TEST_DIR="integration_test"
if [ ! -d "$TEST_DIR" ]; then
  echo "No integration_test directory found"
  kill $LOGCAT_PID || true
  exit 1
fi

FAILED=0
for f in $TEST_DIR/*.dart; do
  if ! run_test_file "$f"; then
    echo "File $f failed"
    FAILED=1
    # Continue to collect other failing files
  fi
done

# Stop background logcat
kill $LOGCAT_PID || true

# Collect final diagnostics (always, even on success)
echo "Collecting final diagnostics..."
adb forward --list > "${ARTIFACTS_DIR}/ci-adb-forward-list-final.txt" || true
adb -s "$EMULATOR_SERIAL" shell dumpsys activity > "${ARTIFACTS_DIR}/ci-dumpsys-activity-final.txt" || true
adb -s "$EMULATOR_SERIAL" shell ps -A > "${ARTIFACTS_DIR}/ci-ps-final.txt" || true
adb -s "$EMULATOR_SERIAL" logcat -d > "${ARTIFACTS_DIR}/ci-emulator-logcat-final.txt" || true

if [ $FAILED -ne 0 ]; then
  echo "One or more integration test files failed. See artifacts: ci-emulator-logcat-*.txt, ci-dumpsys-activity*.txt, ci-ps*.txt, ci-adb-forward-list*.txt"
  exit 1
fi

echo "All integration test files passed"
exit 0
