#!/usr/bin/env bash
set -xeuo pipefail

# Export DB password required by Serverpod (use GH secrets in future)
export DATABASE_PASSWORD=postgres

cd ./vochm/vochm_flutter

# start adb safely
adb kill-server || true
adb start-server || true

# wait until emulator is listed as device
for i in $(seq 1 180); do
  if adb devices | grep -E "^emulator-5554\s+device$" >/dev/null; then
    echo "Emulator connected"
    break
  fi
  echo "Waiting for emulator device (attempt $i)..."
  adb devices
  sleep 2
done

# wait until boot completed, handle 'offline' by restarting adb
for i in $(seq 1 180); do
  state=$(adb -s emulator-5554 get-state 2>/dev/null || true)
  echo "Device state='$state' (attempt $i)"
  if [ "$state" = "device" ]; then
    boot=$(adb -s emulator-5554 shell getprop sys.boot_completed 2>/dev/null | tr -d '\r' || true)
    echo "sys.boot_completed=$boot"
    if [ "$boot" = "1" ]; then
      echo "Emulator boot completed"
      break
    fi
  elif [ "$state" = "offline" ]; then
    echo "Device is offline — restarting adb..."
    adb kill-server || true
    adb start-server || true
  else
    echo "Calling wait-for-device fallback..."
    adb -s emulator-5554 wait-for-device || true
  fi
  sleep 2
done

adb devices

# Run integration tests
# Note: The test result will determine the CI job status
flutter test integration_test --verbose
test_result=$?

# try to kill emulator (ignore errors)
adb -s emulator-5554 emu kill || true

# Exit with the test result to properly reflect pass/fail
exit $test_result
