if [[ "$INPUT_IS_SUBMODULE" == "true" ]]; then
    cd DiligentCore
fi
cd Tests/DiligentCoreTest/assets

BIN_PATH="$DILIGENT_BUILD_DIR"
if [[ "$INPUT_IS_SUBMODULE" == "true" ]]; then
    BIN_PATH="$BIN_PATH/DiligentCore"
fi
BIN_PATH="$BIN_PATH/Tests/DiligentCoreTest"

if [ -d "$BIN_PATH/$DILIGENT_BUILD_TYPE" ]; then
    # Multiple-configuration build such as Visual Studio
    BIN_PATH="$BIN_PATH/$DILIGENT_BUILD_TYPE"
fi

echo "$BIN_PATH contents:"
ls $BIN_PATH
echo "END"

echo "/c/ProgramData/chocolatey/bin:"
ls /c/ProgramData/chocolatey/bin

echo "PATH: $PATH"
PATH="/c/ProgramData/chocolatey/bin:$PATH"
echo "Updated PATH: $PATH"

echo "where.exe libstdc++-6.dll:"
where.exe libstdc++-6.dll

BIN_PATH="$BIN_PATH/DiligentCoreTest"

if [[ "$INPUT_RUNNER_OS" == "Windows" ]]; then
    BIN_PATH="$BIN_PATH.exe"
fi

if [[ "$INPUT_ARGS" != "" ]]; then
    BIN_PATH="$BIN_PATH $INPUT_ARGS"
fi

echo "$BIN_PATH"

ldd $BIN_PATH
chmod +x "$BIN_PATH"

# Can't just use "$BIN_PATH" as it will split the string at spaces ignoring quotes
# https://unix.stackexchange.com/questions/444946/how-can-we-run-a-command-stored-in-a-variable
bash -c "$BIN_PATH"
