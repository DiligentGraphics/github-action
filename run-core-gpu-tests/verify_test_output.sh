# Read log from the file
TEST_LOG="$(<$GITHUB_WORKSPACE/TestOutput.log)"

RES="OK"

# Verify mode
if [[ "$INPUT_MODE" == "d3d11" ]]; then
    MODE_STR="Direct3D11"
elif [[ "$INPUT_MODE" == "d3d12" ]]; then
    MODE_STR="Direct3D12"
elif [[ "$INPUT_MODE" == "d3d11_sw" ]]; then
    MODE_STR="Direct3D11-SW"
elif [[ "$INPUT_MODE" == "d3d12_sw" ]]; then
    MODE_STR="Direct3D12-SW"
elif [[ "$INPUT_MODE" == "gl" ]]; then
    MODE_STR="OpenGL"
elif [[ "$INPUT_MODE" == "vk" ]]; then
    MODE_STR="Vulkan"
elif [[ "$INPUT_MODE" == "vk_sw" ]]; then
    MODE_STR="Vulkan-SW"
elif [[ "$INPUT_MODE" == "wgpu" ]]; then
    MODE_STR="WebGPU"
fi
MODE_STR="Running tests in $MODE_STR mode"

# Regular expressions only work inside [[ ]]
if [[ "$TEST_LOG" == *"$MODE_STR"* ]]; then
    echo "Verifying '$MODE_STR': OK"
else
    echo "Verifying '$MODE_STR': FAIL"
    RES="FAIL"
fi


#Verify shader compiler
if [[ "$INPUT_USE_DXC" == "true" ]]; then
    COMPILER_STR="DXC"
else
    COMPILER_STR="Default"
fi
COMPILER_STR="Selected shader compiler: $COMPILER_STR"

# Regular expressions only work inside [[ ]]
if [[ "$TEST_LOG" == *"$COMPILER_STR"* ]]; then
    echo "Verifying '$COMPILER_STR': OK"
else
    echo "Verifying '$COMPILER_STR': FAIL"
    RES="FAIL"
fi


if [[ "$INPUT_USE_DXC" == "true" ]]; then
    if [[ "$TEST_LOG" == *"TextureCreation/TextureCreationTest"* ]]; then
        echo "Texture creation tests are not supposed to run when DXC is used"
        RES="FAIL"
    fi
fi


if [[ "$INPUT_MODE" == "gl" ]]; then
    if [[ "$INPUT_NON_SEP_PROGS" == "true" ]]; then
        SEP_PROGS_STATE_STR='SeparablePrograms: Disabled'
    else
        SEP_PROGS_STATE_STR='SeparablePrograms: Enabled'
	fi

    if [[ "$TEST_LOG" == *"$SEP_PROGS_STATE_STR"* ]]; then
        echo "Verifying '$SEP_PROGS_STATE_STR': OK"
    else
        echo "Verifying '$SEP_PROGS_STATE_STR': FAIL"
        RES="FAIL"
    fi
fi


if [[ "$INPUT_MODE" == "vk_sw" ]]; then
    if [[ "$INPUT_VK_COMPAT" == "true" ]]; then
        DYN_RENDERING_STATE_STR='DynamicRendering: Disabled'
        HOST_IMAGE_COPY_STATE_STR='HostImageCopy: Disabled'
    else
        DYN_RENDERING_STATE_STR='DynamicRendering: Enabled'
        HOST_IMAGE_COPY_STATE_STR='HostImageCopy: Enabled'
    fi

    if [[ "$TEST_LOG" == *"$DYN_RENDERING_STATE_STR"* ]]; then
        echo "Verifying '$DYN_RENDERING_STATE_STR': OK"
    else
        echo "Verifying '$DYN_RENDERING_STATE_STR': FAIL"
        RES="FAIL"
    fi

    if [[ "$TEST_LOG" == *"$HOST_IMAGE_COPY_STATE_STR"* ]]; then
		echo "Verifying '$HOST_IMAGE_COPY_STATE_STR': OK"
	else
		echo "Verifying '$HOST_IMAGE_COPY_STATE_STR': FAIL"
		RES="FAIL"
	fi
fi

if [[ "$RES" != "OK" ]]; then
    # echo "Captured Test log:"
    # echo "$TEST_LOG"
    exit 1
fi
