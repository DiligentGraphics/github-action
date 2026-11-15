#!/usr/bin/env bash
set -euo pipefail

ACTION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${INPUT_SOURCE_DIR:-DiligentTools}"
BUILD_DIR="${INPUT_BUILD_DIR:-${DILIGENT_BUILD_DIR:?Set build-dir or DILIGENT_BUILD_DIR}/DiligentTools}"

bash "$ACTION_DIR/../common/run_browser_tests.sh" cpu \
    "$SOURCE_DIR/Tests/DiligentToolsTest/browser/run_tests.py" \
    "$BUILD_DIR/Tests/DiligentToolsTest/DiligentToolsTest.js" \
    "${INPUT_OUTPUT_DIR:-ToolsCPUBrowserTestResults}"
