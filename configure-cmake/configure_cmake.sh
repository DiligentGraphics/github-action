CMAKE_CMD="cmake -S . -B \"$BUILD_DIRECTORY\""

if [[ "$CMAKE_GENERATOR" != "" ]]; then
    CMAKE_CMD="$CMAKE_CMD -G \"$CMAKE_GENERATOR\""
    if [[ "$CMAKE_GENERATOR" == "Visual Studio"* ]]; then
        CMAKE_CMD="$CMAKE_CMD -A $INPUT_VS_ARCH"
    fi
elif [[ "$DILIGENT_TARGET_PLATFORM" == "Emscripten" ]]; then
    CMAKE_CMD="$CMAKE_CMD -G Ninja"
fi

CMAKE_CMD="$CMAKE_CMD -DCMAKE_BUILD_TYPE=$INPUT_BUILD_TYPE -DDILIGENT_NO_FORMAT_VALIDATION=ON -DCMAKE_INSTALL_PREFIX=install"

if [[ "$VULKAN_SDK" != "" ]]; then
    CMAKE_CMD="$CMAKE_CMD -DVULKAN_SDK=\"$VULKAN_SDK\""
fi

if [[ "$DILIGENT_TARGET_PLATFORM" == "iOS" || "$DILIGENT_TARGET_PLATFORM" == "tvOS" ]]; then
    CMAKE_CMD="$CMAKE_CMD -DCMAKE_SYSTEM_NAME=$DILIGENT_TARGET_PLATFORM -DCMAKE_OSX_DEPLOYMENT_TARGET=$INPUT_OSX_DEPLOYMENT_TARGET -DCMAKE_OSX_ARCHITECTURES=$INPUT_OSX_ARCHITECTURES"
fi

if [[ "$DILIGENT_TARGET_PLATFORM" == "Emscripten" ]]; then
    CMAKE_CMD="emcmake $CMAKE_CMD"
fi

if [[ "$INPUT_CMAKE_ARGS" != "" ]]; then
    CMAKE_CMD="$CMAKE_CMD $INPUT_CMAKE_ARGS"
fi

echo "$CMAKE_CMD"

# Can't just use "$CMAKE_CMD" as it will split the string at spaces ignoring quotes
# https://unix.stackexchange.com/questions/444946/how-can-we-run-a-command-stored-in-a-variable
bash -c "$CMAKE_CMD"
