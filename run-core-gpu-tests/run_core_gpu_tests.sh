if [[ "$INPUT_IS_SUBMODULE" == "true" ]]; then
    cd DiligentCore
fi
cd Tests/DiligentCoreAPITest/assets

BIN_PATH="$DILIGENT_BUILD_DIR"
if [[ "$INPUT_IS_SUBMODULE" == "true" ]]; then
    BIN_PATH="$BIN_PATH/DiligentCore"
fi
BIN_PATH="$BIN_PATH/Tests/DiligentCoreAPITest"

if [ -d "$BIN_PATH/$DILIGENT_BUILD_TYPE" ]; then
    # Multiple-configuration build such as Visual Studio
    BIN_PATH="$BIN_PATH/$DILIGENT_BUILD_TYPE"
fi

BIN_PATH="$BIN_PATH/DiligentCoreAPITest"

if [[ "$INPUT_RUNNER_OS" == "Windows" ]]; then
    BIN_PATH="$BIN_PATH.exe"
fi

BIN_PATH="$BIN_PATH --mode=$INPUT_MODE"
if [[ "$INPUT_USE_DXC" == "true" ]]; then
    BIN_PATH="$BIN_PATH --shader_compiler=dxc"
fi

if [[ "$INPUT_NON_SEP_PROGS" == "true" ]]; then
    BIN_PATH="$BIN_PATH --non_separable_progs"
fi

if [[ "$INPUT_ARGS" != "" ]]; then
    BIN_PATH="$BIN_PATH $INPUT_ARGS"
fi

echo "$BIN_PATH"

# Make the pipe return the error code of the last command to exit with a non-zero status
# (note that passing '-o pipefail' to bash does not work)
set -o pipefail

# Can't just use "$BIN_PATH" as it will split the string at spaces ignoring quotes
# https://unix.stackexchange.com/questions/444946/how-can-we-run-a-command-stored-in-a-variable
# tee overwrites output file by default
bash -c "$BIN_PATH" 2>&1 | tee "$GITHUB_WORKSPACE/TestOutput.log"
