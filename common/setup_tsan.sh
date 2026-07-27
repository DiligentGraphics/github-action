if [[ "$DILIGENT_TARGET_PLATFORM" != "Linux" || "$DILIGENT_SANITIZER" != "thread" || "${TSAN_OPTIONS:-}" == *"suppressions="* ]]; then
    return 0
fi

TSAN_SUPP="$1"
if [[ ! -f "$TSAN_SUPP" ]]; then
    echo "::error:: TSAN suppression file was not found: $TSAN_SUPP"
    return 1
fi

export TSAN_OPTIONS="${TSAN_OPTIONS:+$TSAN_OPTIONS:}suppressions=$TSAN_SUPP"
echo "TSAN: using suppression file '$TSAN_SUPP'"
