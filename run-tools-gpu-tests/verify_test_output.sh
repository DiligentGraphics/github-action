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
fi
MODE_STR="Running tests in $MODE_STR mode"

# Regular expressions only work inside [[ ]]
if [[ "$TEST_LOG" == *"$MODE_STR"* ]]; then
    echo "Verifying '$MODE_STR': OK"
else
    echo "Verifying '$MODE_STR': FAIL"
    RES="FAIL"
fi


if [[ "$RES" != "OK" ]]; then
    # echo "Captured Test log:"
    # echo "$TEST_LOG"
    exit 1
fi
