
if [[ "$DILIGENT_TARGET_PLATFORM" == "" ]]; then
   echo "DILIGENT_TARGET_PLATFORM is empty. It should be set by setup-build-env."
   exit 1
fi

echo "DILIGENT_BUILD_TYPE=$INPUT_BUILD_TYPE" >> $GITHUB_ENV

# Fix back slashes
BUILD_DIRECTORY=$(tr '\\' '/' <<<"$BUILD_DIRECTORY")
echo "DILIGENT_BUILD_DIR=$BUILD_DIRECTORY" >> $GITHUB_ENV

# Start building the CMake command line
CMAKE_CMD="cmake -S . -B \"$BUILD_DIRECTORY\""

# Add CMake generator
if [[ "$CMAKE_GENERATOR" != "" ]]; then
    CMAKE_CMD="$CMAKE_CMD -G \"$CMAKE_GENERATOR\""
    if [[ "$CMAKE_GENERATOR" == "Visual Studio"* ]]; then
        # For Visual Studio generators, add architecture (-A Win32 or -A x64)
        if [[ "$INPUT_VS_ARCH" == "" ]]; then
            echo "INPUT_VS_ARCH must not be empty"
            exit 1
        fi
        CMAKE_CMD="$CMAKE_CMD -A $INPUT_VS_ARCH"
    fi
elif [[ "$DILIGENT_TARGET_PLATFORM" == "Emscripten" ]]; then
    # Emscripten always uses Ninja
    CMAKE_CMD="$CMAKE_CMD -G Ninja"
fi

# Disable format validation as it is performed by a standalone action
CMAKE_CMD="$CMAKE_CMD -DCMAKE_BUILD_TYPE=$INPUT_BUILD_TYPE -DDILIGENT_NO_FORMAT_VALIDATION=ON"

# Add path to Vulkan SDK, if defined
if [[ "$VULKAN_SDK" != "" ]]; then
    CMAKE_CMD="$CMAKE_CMD -DVULKAN_SDK=\"$VULKAN_SDK\""
fi

# Add iOS and tvOS - specific options
if [[ "$DILIGENT_TARGET_PLATFORM" == "iOS" || "$DILIGENT_TARGET_PLATFORM" == "tvOS" ]]; then
    if [[ "$INPUT_OSX_DEPLOYMENT_TARGET" == "" ]]; then
        echo "INPUT_OSX_DEPLOYMENT_TARGET must not be empty"
        exit 1
    fi
    if [[ "$INPUT_OSX_ARCHITECTURES" == "" ]]; then
        echo "INPUT_OSX_ARCHITECTURES must not be empty"
        exit 1
    fi
    CMAKE_CMD="$CMAKE_CMD -DCMAKE_SYSTEM_NAME=$DILIGENT_TARGET_PLATFORM -DCMAKE_OSX_DEPLOYMENT_TARGET=$INPUT_OSX_DEPLOYMENT_TARGET -DCMAKE_OSX_ARCHITECTURES=$INPUT_OSX_ARCHITECTURES"
fi

if [[ "$DILIGENT_TARGET_PLATFORM" == "Emscripten" ]]; then
    CMAKE_CMD="emcmake $CMAKE_CMD"
fi

# Add extra arguments
if [[ "$INPUT_CMAKE_ARGS" != "" ]]; then
    CMAKE_CMD="$CMAKE_CMD $INPUT_CMAKE_ARGS"
fi

# Add install prefix - use full path to the build folder, otherwise
# it will be created in the current directory (which is the source folder)
CMAKE_CMD="$CMAKE_CMD -DCMAKE_INSTALL_PREFIX=\"$BUILD_DIRECTORY/install\""

echo "DILIGENT_INSTALL_DIR=$BUILD_DIRECTORY/install" >> $GITHUB_ENV

echo "$CMAKE_CMD"

# Can't just use "$CMAKE_CMD" as it will split the string at spaces ignoring quotes
# https://unix.stackexchange.com/questions/444946/how-can-we-run-a-command-stored-in-a-variable
# Capture CMake output to verify it later.
# NOTE: CMake directs all user messages to stderr, so redirect it to stdout
# -o pipefail makes the pipe return the error code of the last command to exit with a non-zero status
bash -c -o pipefail "$CMAKE_CMD" 2>&1 | tee "$GITHUB_WORKSPACE/CMakeOutput.log"
