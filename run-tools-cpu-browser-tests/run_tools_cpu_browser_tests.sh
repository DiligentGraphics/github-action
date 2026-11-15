#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${INPUT_SOURCE_DIR:-DiligentTools}"
BUILD_DIR="${INPUT_BUILD_DIR:-${DILIGENT_BUILD_DIR:?Set build-dir or DILIGENT_BUILD_DIR}/DiligentTools}"
BROWSER_ARGS=()
if [[ -n "${INPUT_BROWSER:-}" ]]; then
    BROWSER_ARGS+=(--browser "$INPUT_BROWSER")
fi

# CPU tests use the same module-owned browser harness as the GPU tests, without
# creating a graphics device or requiring a software rendering backend.
python3 -B "$SOURCE_DIR/Tests/DiligentToolsTest/browser/run_tests.py" \
    --module "$BUILD_DIR/Tests/DiligentToolsTest/DiligentToolsTest.js" \
    "${BROWSER_ARGS[@]}" \
    --filter="${INPUT_FILTER:-*}" \
    --output "${INPUT_OUTPUT_DIR:-ToolsCPUBrowserTestResults}"
