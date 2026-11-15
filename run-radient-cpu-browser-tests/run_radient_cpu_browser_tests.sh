#!/usr/bin/env bash
set -euo pipefail

ACTION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${INPUT_SOURCE_DIR:-DiligentFX}"
BUILD_DIR="${INPUT_BUILD_DIR:-${DILIGENT_BUILD_DIR:?Set build-dir or DILIGENT_BUILD_DIR}/DiligentFX}"

bash "$ACTION_DIR/../common/run_browser_tests.sh" cpu \
    "$SOURCE_DIR/Tests/RadientTest/browser/run_tests.py" \
    "$BUILD_DIR/Tests/RadientTest/RadientTest.js" \
    "${INPUT_OUTPUT_DIR:-RadientCPUBrowserTestResults}"
