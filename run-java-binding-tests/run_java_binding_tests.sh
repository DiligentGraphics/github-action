#!/usr/bin/env bash
set -euo pipefail

case "${1:?Select generic or radient}" in
    generic)
        TEST_DIR="${INPUT_BUILD_DIR:-${DILIGENT_JAVA_TEST_BUILD_DIR:?Run setup-java-binding-tests or set build-dir}}"
        ;;
    radient)
        BUILD_DIR="${INPUT_RADIENT_BUILD_DIR:-${DILIGENT_BUILD_DIR:?Set radient-build-dir or DILIGENT_BUILD_DIR}/DiligentFX}"
        TEST_DIR="$BUILD_DIR/Radient/bindings/java/tests"
        ;;
    *)
        echo "::error::Expected generic or radient Java tests."
        exit 1
        ;;
esac

CONFIGURATION="${INPUT_CONFIGURATION:-${DILIGENT_BUILD_TYPE:-}}"
TEST_ARGS=(--test-dir "$TEST_DIR" --verbose --output-on-failure --no-tests=error)
if [[ -n "$CONFIGURATION" ]]; then
    TEST_ARGS+=(-C "$CONFIGURATION")
fi
# Test selection, fixtures, JNI validation, and timeouts remain owned by FX.
ctest "${TEST_ARGS[@]}"
