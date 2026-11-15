#!/usr/bin/env bash
set -euo pipefail

ACTION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${INPUT_SOURCE_DIR:-.}"
BUILD_DIR="${INPUT_BUILD_DIR:-${DILIGENT_BUILD_DIR:?Set build-dir or DILIGENT_BUILD_DIR}}"

bash "$ACTION_DIR/../common/run_browser_tests.sh" wgpu \
    "$SOURCE_DIR/Tests/DiligentCoreAPITest/browser/run_tests.py" \
    "$BUILD_DIR/Tests/DiligentCoreAPITest/DiligentCoreAPITest.js" \
    "${INPUT_OUTPUT_DIR:-BrowserTestResults}"
