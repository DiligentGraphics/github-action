#!/usr/bin/env bash
set -euo pipefail

ACTION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export BINDINGS_TEST_BROWSER_EXECUTABLE="$ACTION_DIR/../common/chrome_swiftshader.sh"
chmod +x "$BINDINGS_TEST_BROWSER_EXECUTABLE"
"$BINDINGS_TEST_BROWSER_EXECUTABLE" --version

BUILD_DIR="${INPUT_BUILD_DIR:-${DILIGENT_BUILD_DIR:?Set build-dir or DILIGENT_BUILD_DIR}/DiligentFX}"
CONFIGURATION="${INPUT_CONFIGURATION:-${DILIGENT_BUILD_TYPE:-}}"
OUTPUT_DIR="${INPUT_OUTPUT_DIR:-BrowserRenderResults}"
mkdir -p "$OUTPUT_DIR"

# CTest changes the working directory for individual tests. Resolve paths here
# so relative action inputs still refer to the workflow's workspace.
RADIENT_BROWSER_TEST_MODELS="$(cd "${INPUT_MODELS_PATH:?Set models-path}" && pwd)"
RADIENT_BROWSER_TEST_ASSETS="$(cd "${INPUT_ASSETS_PATH:?Set assets-path}" && pwd)"
RADIENT_BROWSER_TEST_OUTPUT="$(cd "$OUTPUT_DIR" && pwd)"

export RADIENT_BROWSER_TEST_MODELS RADIENT_BROWSER_TEST_ASSETS RADIENT_BROWSER_TEST_OUTPUT

# CTest registrations and the render manifest remain owned by DiligentFX.
TEST_ARGS=(--test-dir "$BUILD_DIR/Radient/bindings" -L Browser
    --verbose --output-on-failure --no-tests=error
    --output-log "$RADIENT_BROWSER_TEST_OUTPUT/tests.log"
    --output-junit "$RADIENT_BROWSER_TEST_OUTPUT/results.xml")
if [[ -n "$CONFIGURATION" ]]; then
    TEST_ARGS+=(-C "$CONFIGURATION")
fi
if [[ -n "${INPUT_FILTER:-}" ]]; then
    TEST_ARGS+=(-R "$INPUT_FILTER")
fi
ctest "${TEST_ARGS[@]}"
