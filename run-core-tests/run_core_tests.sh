if [[ "$IS_SUBMODULE" == "true" ]]; then
    cd DiligentCore
fi
cd Tests/DiligentCoreTest/assets

BIN_PATH="$DILIGENT_BUILD_DIR"
if [[ "$IS_SUBMODULE" == "true" ]]; then
    BIN_PATH="$BIN_PATH/DiligentCore"
fi
BIN_PATH="$BIN_PATH/Tests/DiligentCoreTest"

if [ -d "./$DILIGENT_BUILD_TYPE" ]; then
    # Multiple-configuration build such as Visual Studio
    BIN_PATH="$BIN_PATH/$DILIGENT_BUILD_TYPE"
fi

BIN_PATH="$BIN_PATH/DiligentCoreTest"

if [[ "$RUNNER_OS" == "Windows" ]]; then
    BIN_PATH="$BIN_PATH.exe"
fi

if [[ "$ARGS" != "" ]]; then
    BIN_PATH="$BIN_PATH $ARGS"
fi

echo "$BIN_PATH"

# Can't just use "$BIN_PATH" as it will split the string at spaces ignoring quotes
# https://unix.stackexchange.com/questions/444946/how-can-we-run-a-command-stored-in-a-variable
bash -c "$BIN_PATH"
