#!/usr/bin/env bash
set -euo pipefail
# Debug/verbosity
set -x

# Wait for adb to see device
echo "Waiting for emulator device to be listed by adb..."
# Wait up to 5 minutes for a device to appear
for i in $(seq 1 150); do
  if adb devices | grep -E '^emulator-[0-9]+' >/dev/null 2>&1; then
    break
  fi
  sleep 2
done

EMULATOR_SERIAL=$(adb devices | awk '/^emulator-/{print $1; exit}')
if [ -z "${EMULATOR_SERIAL:-}" ]; then
  echo "ERROR: No emulator device found in adb devices"
  adb devices
  exit 1
fi
echo "Emulator serial: $EMULATOR_SERIAL"

# Wait for device to be 'device' (not offline) and for Android boot to complete
echo "Waiting for emulator to be ONLINE and for Android boot to complete..."
for i in $(seq 1 600); do
  STATE=$(adb -s "$EMULATOR_SERIAL" get-state 2>/dev/null || echo "unknown")
  if [ "$STATE" = "device" ]; then
    BOOT_COMPLETED=$(adb -s "$EMULATOR_SERIAL" shell getprop sys.boot_completed 2>/dev/null || echo "")
    if [ "$BOOT_COMPLETED" = "1" ]; then
      echo "Emulator boot completed and device is online."
      break
    fi
  else
    echo "Emulator state: $STATE (waiting)..."
  fi
  sleep 2
done

# Final check
BOOT_COMPLETED=$(adb -s "$EMULATOR_SERIAL" shell getprop sys.boot_completed || echo "")
if [ "$BOOT_COMPLETED" != "1" ]; then
  echo "ERROR: Emulator did not finish booting in time. sys.boot_completed='$BOOT_COMPLETED'"
  adb -s "$EMULATOR_SERIAL" shell getprop | sed -n '1,200p' || true
  exit 1
fi

# Ensure device is ready and unlock screen in case lock screen blocks
adb -s "$EMULATOR_SERIAL" wait-for-device
adb -s "$EMULATOR_SERIAL" shell input keyevent 82 || true
sleep 2

# Run tests from the Flutter app folder
echo "Running integration tests..."
cd vochm/vochm_flutter

# Ensure packages are fetched (safety)
flutter pub get

# Run integration tests (keeps current behaviour of existing workflow)
flutter test integration_test --verbose
