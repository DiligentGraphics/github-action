#!/usr/bin/env bash

if [[ "$#" != "2" ]]; then
    echo "Usage: $0 <test-log-path> <mode>"
    exit 1
fi

TEST_LOG_PATH="$1"
MODE="$2"

if [[ ! -f "$TEST_LOG_PATH" ]]; then
    echo "Verifying test mode: FAIL (log '$TEST_LOG_PATH' does not exist)"
    exit 1
fi

case "$MODE" in
    d3d11)
        MODE_NAME="Direct3D11"
        ;;
    d3d12)
        MODE_NAME="Direct3D12"
        ;;
    d3d11_sw)
        MODE_NAME="Direct3D11-SW"
        ;;
    d3d12_sw)
        MODE_NAME="Direct3D12-SW"
        ;;
    gl)
        MODE_NAME="OpenGL"
        ;;
    vk)
        MODE_NAME="Vulkan"
        ;;
    vk_sw)
        MODE_NAME="Vulkan-SW"
        ;;
    wgpu)
        MODE_NAME="WebGPU"
        ;;
    *)
        echo "Verifying test mode: FAIL (unknown mode '$MODE')"
        exit 1
        ;;
esac

MODE_BANNER="Running tests in $MODE_NAME mode"
if grep -Fq -- "$MODE_BANNER" "$TEST_LOG_PATH"; then
    echo "Verifying '$MODE_BANNER': OK"
else
    echo "Verifying '$MODE_BANNER': FAIL"
    exit 1
fi
