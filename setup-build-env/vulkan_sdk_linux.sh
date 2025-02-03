#!/bin/bash

set -e  # Exit if any command fails

# Check if Vulkan SDK version is provided
if [ -z "$1" ]; then
    echo "Error: No Vulkan SDK version provided."
    echo "Usage: $0 <VULKAN_SDK_VERSION>"
    exit 1
fi

VULKAN_SDK_VER=$1
ARCH="$(uname -m)"
VK_SDK_TAR="vulkan-sdk-linux-$ARCH-$VULKAN_SDK_VER.tar.gz"

VK_SDK_PATH=~/VulkanSDK
mkdir -p "$VK_SDK_PATH"

# Download Vulkan SDK
echo "Downloading Vulkan SDK $VULKAN_SDK_VER for $ARCH..."
export SRC_URL="https://sdk.lunarg.com/sdk/download/$VULKAN_SDK_VER/linux/$VK_SDK_TAR"
if ! wget -O "$VK_SDK_TAR" "$SRC_URL"; then
    echo "Error: Failed to download Vulkan SDK from $SRC_URL. Check if the link is correct."
    exit 1
fi

# Extract Vulkan SDK
echo "Extracting Vulkan SDK..."
if ! tar -xf "$VK_SDK_TAR" -C "$VK_SDK_PATH"; then
    echo "Error: Failed to extract Vulkan SDK."
    exit 1
fi

# Clean up downloaded tarball
rm "$VK_SDK_TAR"

# Define full Vulkan SDK path
VK_SDK_PATH="$VK_SDK_PATH/$VULKAN_SDK_VER/$ARCH"
VK_LAYER_PATH="$VK_SDK_PATH/share/vulkan/explicit_layer.d"

# Verify if the Vulkan SDK is installed correctly
if [ ! -d "$VK_SDK_PATH/bin" ]; then
    echo "Error: Vulkan SDK installation seems incorrect. Folder $VK_SDK_PATH/bin not found."
    exit 1
fi

if [ ! -d "$VK_LAYER_PATH" ]; then
    echo "Error: Unable to find Vulkan layers in the SDK. Folder $VK_LAYER_PATH not found."
    exit 1
fi

# Set environment variables in GitHub Actions
echo "$VK_SDK_PATH/bin" >> "$GITHUB_PATH"
echo "VULKAN_SDK=$VK_SDK_PATH" >> "$GITHUB_ENV"
echo "LD_LIBRARY_PATH=$VK_SDK_PATH/lib" >> "$GITHUB_ENV"
echo "VK_LAYER_PATH=$VK_LAYER_PATH" >> "$GITHUB_ENV"
echo "VK_ADD_LAYER_PATH=$VK_LAYER_PATH" >> "$GITHUB_ENV"

echo "Vulkan SDK $VULKAN_SDK_VER installed successfully!"
