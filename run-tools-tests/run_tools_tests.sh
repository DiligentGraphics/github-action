
cd DiligentTools/Tests/DiligentToolsTest/assets

BIN_PATH="$DILIGENT_BUILD_DIR/DiligentTools/Tests/DiligentToolsTest"

if [ -d "$BIN_PATH/$DILIGENT_BUILD_TYPE" ]; then
    # Multiple-configuration build such as Visual Studio
    BIN_PATH="$BIN_PATH/$DILIGENT_BUILD_TYPE"
fi

BIN_PATH="$BIN_PATH/DiligentToolsTest"

if [[ "$INPUT_RUNNER_OS" == "Windows" ]]; then
    BIN_PATH="$BIN_PATH.exe"
    if [[ "$DILIGENT_MINGW64_BIN_DIR" != "" ]]; then
        # Workaround for https://github.com/actions/runner-images/issues/8399
        # Note that echoing mingw bin path to GITHUB_PATH doesn't work as /mingw64/bin
        # is forced to always be the first entry.
        PATH="$DILIGENT_MINGW64_BIN_DIR:$PATH"
    fi
fi

if [[ "$INPUT_ARGS" != "" ]]; then
    BIN_PATH="$BIN_PATH $INPUT_ARGS"
fi

echo "$BIN_PATH"

# Can't just use "$BIN_PATH" as it will split the string at spaces ignoring quotes
# https://unix.stackexchange.com/questions/444946/how-can-we-run-a-command-stored-in-a-variable
bash -c "$BIN_PATH"
