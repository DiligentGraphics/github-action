#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${INPUT_SOURCE_DIR:-DiligentFX}"
BUILD_DIR="${INPUT_BUILD_DIR:-${DILIGENT_BUILD_DIR:?Set build-dir or DILIGENT_BUILD_DIR}}"
OUTPUT_DIR="${INPUT_OUTPUT_DIR:-RadientAndroidTestResults}"
SDK="${ANDROID_HOME:?Set ANDROID_HOME to the Android SDK}"
# The emulator action uses port 5554; select it explicitly if adb sees other devices.
SERIAL="emulator-5554"
mkdir -p "$OUTPUT_DIR"

collect_logcat() {
    "$SDK/platform-tools/adb" -s "$SERIAL" logcat -d > "$OUTPUT_DIR/logcat.log" 2>&1 || true
}
trap collect_logcat EXIT

# Keep test selection and deployment in FX. pipefail preserves failures through tee.
python3 -u "$SOURCE_DIR/Tests/RadientTest/android/run_tests.py" \
    --sdk "$SDK" --build "$BUILD_DIR" --serial "$SERIAL" \
    --compile-sdk "${INPUT_COMPILE_SDK:-35}" --build-tools-version "${INPUT_BUILD_TOOLS_VERSION:-35.0.0}" \
    --filter "${INPUT_FILTER:-*}" --timeout "${INPUT_TIMEOUT:-600}" \
    --results "$OUTPUT_DIR" 2>&1 | tee "$OUTPUT_DIR/tests.log"
