#!/usr/bin/env bash

if [[ "$DILIGENT_SANITIZER" == "address" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/../common/setup_asan.sh" "$INPUT_MODE" || exit 1
fi

if [[ "$DILIGENT_SANITIZER" == "thread" ]]; then
    source "$(dirname "${BASH_SOURCE[0]}")/../common/setup_tsan.sh" "$PWD/DiligentCore/BuildTools/Sanitizers/tsan.supp" || exit 1
fi

BIN_PATH="$DILIGENT_BUILD_DIR/DiligentFX/Tests/RadientRenderTest"

if [[ -d "$BIN_PATH/$DILIGENT_BUILD_TYPE" ]]; then
    # Multiple-configuration build such as Visual Studio.
    BIN_PATH="$BIN_PATH/$DILIGENT_BUILD_TYPE"
fi

BIN_PATH="$BIN_PATH/RadientRenderTest"

if [[ "$INPUT_RUNNER_OS" == "Windows" ]]; then
    BIN_PATH="$BIN_PATH.exe"
fi

TEST_ARGS=(
    "--mode=$INPUT_MODE"
    "--models=$INPUT_MODELS_PATH"
    "--assets=$INPUT_ASSETS_PATH"
    "--max_channel_error=$INPUT_MAX_CHANNEL_ERROR"
    "--max_bad_pixel_ratio=$INPUT_MAX_BAD_PIXEL_RATIO"
)

if [[ "$INPUT_UPDATE_GOLDEN_IMAGES" == "true" ]]; then
    TEST_ARGS+=("--update_golden_images")
fi

if [[ -n "$INPUT_ARGS" ]]; then
    # Extra arguments are expected to be whitespace-separated command-line options.
    read -r -a EXTRA_ARGS <<< "$INPUT_ARGS"
    TEST_ARGS+=("${EXTRA_ARGS[@]}")
fi

printf 'Running:'
printf ' %q' "$BIN_PATH" "${TEST_ARGS[@]}"
printf '\n'

# Preserve the test exit status while capturing its output.
set -o pipefail
"$BIN_PATH" "${TEST_ARGS[@]}" 2>&1 | tee "$GITHUB_WORKSPACE/RadientRenderTest-$INPUT_MODE.log"
