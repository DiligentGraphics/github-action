#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="${INPUT_SOURCE_DIR:-.}"
BUILD_DIR="${INPUT_BUILD_DIR:-${DILIGENT_BUILD_DIR:?Set build-dir or DILIGENT_BUILD_DIR}}"
BROWSER_ARGS=()
if [[ -n "${INPUT_BROWSER:-}" ]]; then
    BROWSER_ARGS+=(--browser "$INPUT_BROWSER")
fi

# CPU tests use the same module-owned browser harness as the GPU tests, without
# creating a graphics device or requiring a software rendering backend.
python3 "$SOURCE_DIR/Tests/DiligentCoreTest/browser/run_tests.py" \
    --module "$BUILD_DIR/Tests/DiligentCoreTest/DiligentCoreTest.js" \
    "${BROWSER_ARGS[@]}" \
    --filter="${INPUT_FILTER:-*}" \
    --output "${INPUT_OUTPUT_DIR:-CoreCPUBrowserTestResults}"
