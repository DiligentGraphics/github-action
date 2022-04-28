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
    # Disable tests that are not relevant for DXC to save time
    BIN_PATH="$BIN_PATH --shader_compiler=dxc --gtest_filter=-TextureCreation*"
fi

if [[ "$INPUT_ARGS" != "" ]]; then
    BIN_PATH="$BIN_PATH $INPUT_ARGS"
fi

echo "$BIN_PATH"

# Can't just use "$BIN_PATH" as it will split the string at spaces ignoring quotes
# https://unix.stackexchange.com/questions/444946/how-can-we-run-a-command-stored-in-a-variable
# tee overwrites output file by default
bash -c "$BIN_PATH" 2>&1 | tee "$GITHUB_WORKSPACE/TestOutput.log"
