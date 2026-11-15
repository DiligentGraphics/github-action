#!/usr/bin/env bash
set -euo pipefail

ACTION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BROWSER_WRAPPER="$ACTION_DIR/../common/chrome_swiftshader.sh"
chmod +x "$BROWSER_WRAPPER"
"$BROWSER_WRAPPER" --version

SOURCE_DIR="${INPUT_SOURCE_DIR:-DiligentTools}"
BUILD_DIR="${INPUT_BUILD_DIR:-${DILIGENT_BUILD_DIR:?Set build-dir or DILIGENT_BUILD_DIR}/DiligentTools}"

# The source checkout supplies the test page, exclusions, and timeout defaults.
python3 -B "$SOURCE_DIR/Tests/DiligentToolsGPUTest/browser/run_tests.py" \
    --module "$BUILD_DIR/Tests/DiligentToolsGPUTest/DiligentToolsGPUTest.js" \
    --browser "$BROWSER_WRAPPER" \
    --filter="${INPUT_FILTER:-*}" \
    --output "${INPUT_OUTPUT_DIR:-ToolsGPUBrowserTestResults}"
