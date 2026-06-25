# Read log from the file
CMAKE_LOG="$(<$GITHUB_WORKSPACE/CMakeOutput.log)"

if [[ "$DILIGENT_TARGET_PLATFORM" == "" ]]; then
    echo "DILIGENT_TARGET_PLATFORM is not set. It should be set by setup-build-env."
    exit 1
fi


RES="OK"

# Verify generator
if [[ "$DILIGENT_TARGET_PLATFORM" == "Web" && "$INPUT_GENERATOR" == "" ]]; then
    # Emscripten always uses Ninja
    INPUT_GENERATOR="Ninja"
fi

GENERATOR_STR="CMake generator: $INPUT_GENERATOR"
# Regular expressions only work inside [[ ]]
if [[ "$CMAKE_LOG" == *"$GENERATOR_STR"* ]]; then
    echo "Verifying '$GENERATOR_STR': OK"
else
    echo "Verifying '$GENERATOR_STR': FAIL"
    RES="FAIL"
fi


# Verify platform name
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

PLATFORM_STR="Target platform: $PLATFORM_NAME"
# Regular expressions only work inside [[ ]]
if [[ "$CMAKE_LOG" == *"$PLATFORM_STR"* ]]; then
    echo "Verifying '$PLATFORM_STR': OK"
else
    echo "Verifying '$PLATFORM_STR': FAIL"
    RES="FAIL"
fi


ASAN_STR="DILIGENT_ENABLE_ASAN is ON"
if [[ "$INPUT_ENABLE_ASAN" == "true" ]]; then
    if [[ "$CMAKE_LOG" == *"$ASAN_STR"* ]]; then
        echo "Verifying '$ASAN_STR': OK"
    else
        echo "Verifying '$ASAN_STR': FAIL"
        RES="FAIL"
    fi
else
    if [[ "$CMAKE_LOG" == *"$ASAN_STR"* ]]; then
        echo "AddressSanitizer was not requested, but CMake reported '$ASAN_STR'"
        RES="FAIL"
    fi
fi


if [[ "$RES" != "OK" ]]; then
    echo "Captured CMake log:"
    echo "$CMAKE_LOG"
    exit 1
fi
