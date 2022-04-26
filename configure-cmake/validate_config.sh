# Read log from the file
CMAKE_LOG="$(<$GITHUB_WORKSPACE/CMakeOutput.log)"

if [[ "$DILIGENT_TARGET_PLATFORM" == "" ]]; then
    echo "DILIGENT_TARGET_PLATFORM is not set. It should be set by setup-build-env."
    exit 1
fi

PLATFORM_NAME="$DILIGENT_TARGET_PLATFORM"
if [[ "$DILIGENT_TARGET_PLATFORM" == "UWP" ]]; then
    PLATFORM_NAME="Universal Windows"
fi

if [[ "$DILIGENT_TARGET_PLATFORM" == "Win32" || "$DILIGENT_TARGET_PLATFORM" == "UWP" ]]; then
    if [[ "$INPUT_VS_ARCH" == "Win32" ]]; then
        PLATFORM_NAME="$PLATFORM_NAME 32"
    else
        PLATFORM_NAME="$PLATFORM_NAME 64"
    fi
fi

RES="OK"

PALTFORM_STR="Target platform: $PLATFORM_NAME"
# Regular expressions only works inside [[ ]]
if [[ "$CMAKE_LOG" == *"$PALTFORM_STR"* ]]; then
    echo "Verifying '$PALTFORM_STR': OK"
else
    echo "Verifying '$PALTFORM_STR': FAIL"
    RES="FAIL"
fi

if [[ "$DILIGENT_TARGET_PLATFORM" == "Emscripten" && "$INPUT_GENERATOR" == "" ]]; then
    INPUT_GENERATOR="Ninja"
fi

GENERATOR_STR="CMake generator: $INPUT_GENERATOR"
if [[ "$CMAKE_LOG" == *"$GENERATOR_STR"* ]]; then
    echo "Verifying '$GENERATOR_STR': OK"
else
    echo "Verifying '$GENERATOR_STR': FAIL"
    RET_CODE=1
    RES="FAIL"
fi

if [[ "$RES" != "OK" ]]; then
    echo "Captured CMake log:"
    echo "$CMAKE_LOG"
    exit 1
fi
