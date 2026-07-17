if [[ "$DILIGENT_TARGET_PLATFORM" != "Linux" || "$DILIGENT_SANITIZER" != "address" || "$1" != "vk_sw" ]]; then
    return 0
fi

# Mesa #12805 leaks CPU topology state when Lavapipe is unloaded. Keep the ICD
# loaded until process exit so LeakSanitizer does not report the upstream leak:
# https://gitlab.freedesktop.org/mesa/mesa/-/issues/12805
LVP_LIB=$(ldconfig -p | awk '$1 == "libvulkan_lvp.so" {print $NF; exit}')
if [[ -z "$LVP_LIB" ]]; then
    echo "::warning::ASAN Lavapipe workaround was not applied because libvulkan_lvp.so was not found"
    return 0
fi

if [[ ":${LD_PRELOAD:-}:" != *":$LVP_LIB:"* ]]; then
    export LD_PRELOAD="${LD_PRELOAD:+$LD_PRELOAD:}$LVP_LIB"
fi

echo "Using ASAN Lavapipe workaround: LD_PRELOAD=$LD_PRELOAD"
