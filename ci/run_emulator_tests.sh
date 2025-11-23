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

# ENHANCED: Robust wait for emulator boot
echo "Waiting for Android emulator to boot..."
adb wait-for-device
echo "Device detected by adb"

# Wait for Android to report boot completed
echo "Waiting for sys.boot_completed..."
adb shell 'until [[ "$(getprop sys.boot_completed)" == "1" ]]; do sleep 1; done'
echo "sys.boot_completed=1"

# Extra buffer time to ensure services (including VM Service / port forwarding) are ready
echo "Adding extra buffer time for services..."
sleep 10

# Unlock and settle
adb -s "$EMULATOR_SERIAL" shell input keyevent 82 || true
sleep 5

# Change to flutter app folder and ensure dependencies
cd vochm/vochm_flutter
flutter pub get

# ENHANCED: Per-test diagnostics capture with wrapper script
TEST_DIR=integration_test
ARTIFACT_DIR="$GITHUB_WORKSPACE/test-artifacts"
mkdir -p "$ARTIFACT_DIR"
FAILED=0

for f in "$TEST_DIR"/*.dart; do
  base=$(basename "$f" .dart)
  echo "Running test file: $f"
  # ensure the app is stopped and previous forwardings removed
  adb -s "$EMULATOR_SERIAL" shell am force-stop com.example.vochm_flutter || true
  adb forward --remove-all || true

  # Run the flutter test and capture output
  rc=0
  flutter test "$f" --verbose > "$ARTIFACT_DIR/${base}.test.log" 2>&1 || rc=$?; true
  if [ "$rc" -ne 0 ]; then
    FAILED=1
  fi

  # Collect diagnostics regardless of pass/fail
  adb forward --list > "$ARTIFACT_DIR/${base}.adb-forward-list.txt" 2>&1 || true
  adb -s "$EMULATOR_SERIAL" logcat -d > "$ARTIFACT_DIR/${base}.logcat.txt" 2>&1 || true
  adb -s "$EMULATOR_SERIAL" shell dumpsys activity > "$ARTIFACT_DIR/${base}.dumpsys-activity.txt" 2>&1 || true
  adb -s "$EMULATOR_SERIAL" shell ps -A > "$ARTIFACT_DIR/${base}.ps.txt" 2>&1 || true
done

# Always list the artifact directory contents for debugging
ls -R "$ARTIFACT_DIR" || true

if [ "$FAILED" -ne 0 ]; then
  echo "One or more integration tests failed"
  exit 1
fi

echo "All integration test files passed"
exit 0
