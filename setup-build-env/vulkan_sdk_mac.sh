set -e

VULKAN_SDK_VER=$1

# https://vulkan.lunarg.com/doc/view/latest/mac/getting_started.html#install-and-uninstall-from-terminal

export VK_SDK_ZIP=vulkansdk-macos-$VULKAN_SDK_VER.zip
wget -O "$VK_SDK_ZIP" https://sdk.lunarg.com/sdk/download/$VULKAN_SDK_VER/mac/$VK_SDK_ZIP?Human=true && unzip -q "$VK_SDK_ZIP"

export VK_SDK_PATH=~/VulkanSDK
sudo ./InstallVulkan-$VULKAN_SDK_VER.app/Contents/MacOS/InstallVulkan-$VULKAN_SDK_VER --root $VK_SDK_PATH --accept-licenses --default-answer --confirm-command install

rm "$VK_SDK_ZIP"
rm -rf "InstallVulkan-$VULKAN_SDK_VER.app"

if [ ! -f "$VK_SDK_PATH/macOS/lib/libvulkan.dylib" ]; then
    echo "Unable to find libvulkan.dylib in the SDK."
    exit 1
fi
if [ ! -d "$VK_SDK_PATH/macOS/lib/MoltenVK.xcframework" ]; then
    echo "Unable to find MoltenVK.xcframework in the SDK."
    exit 1
fi

echo "VULKAN_SDK=$VK_SDK_PATH" >> $GITHUB_ENV

echo "Vulkan SDK $VULKAN_SDK_VER installed successfully!"
