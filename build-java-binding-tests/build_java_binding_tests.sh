#!/usr/bin/env bash
set -euo pipefail

SOURCE_DIR="$(cd "${INPUT_SOURCE_DIR:?Set source-dir to the DiligentFX source directory}" && pwd)"
BUILD_DIR="$(realpath -m "${INPUT_BUILD_DIR:?Set build-dir for the generic Java tests}")"
CONFIGURATION="${INPUT_CONFIGURATION:?Set configuration for the generic Java tests}"
PYTHON="${RADIENT_BINDINGS_PYTHON_EXECUTABLE:?Run setup-java-bindings first}"
LIBCLANG="${RADIENT_BINDINGS_LIBCLANG:?Run setup-java-bindings first}"

# Setup owns the host toolchain. This build contains only the generic fixtures;
# production Radient/JNI libraries are built by the main CMake configuration.
cmake -S "$SOURCE_DIR/BuildTools/Bindings/java" -B "$BUILD_DIR" -G Ninja \
    "-DCMAKE_BUILD_TYPE=$CONFIGURATION" \
    "-DBINDINGS_PYTHON_EXECUTABLE=$PYTHON" \
    "-DBINDINGS_LIBCLANG=$LIBCLANG"
cmake --build "$BUILD_DIR" --config "$CONFIGURATION" --parallel "$(nproc)"

echo "DILIGENT_JAVA_TEST_BUILD_DIR=$BUILD_DIR" >> "${GITHUB_ENV:?}"
