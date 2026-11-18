#!/usr/bin/env bash
set -euo pipefail

# This action uses the LLVM 22, Python, Ninja, and JDK installed on Linux runners.
if [[ "${RUNNER_OS:-Linux}" != "Linux" ]]; then
    echo "::error::Java binding test setup currently supports Linux runners."
    exit 1
fi

SOURCE_DIR="$(cd "${INPUT_SOURCE_DIR:-DiligentFX}" && pwd)"
BUILD_DIR="$(realpath -m "${INPUT_BUILD_DIR:-${RUNNER_TEMP:?}/binding-java}")"
CONFIGURATION="${INPUT_CONFIGURATION:-Debug}"
LIBCLANG="${INPUT_LIBCLANG:-/usr/lib/llvm-22/lib/libclang-22.so.1}"
VENV_DIR="${RUNNER_TEMP:?}/bindings-venv"
export JAVA_HOME="${INPUT_JAVA_HOME:-${JAVA_HOME_21_X64:-${JAVA_HOME:-}}}"
if [[ ! -x "$JAVA_HOME/bin/javac" ]]; then
    echo "::error::Set java-home or JAVA_HOME to an installed JDK."
    exit 1
fi

python3 -m venv "$VENV_DIR"
"$VENV_DIR/bin/python" -m pip install -r "$SOURCE_DIR/BuildTools/Bindings/requirements.txt"

cmake -S "$SOURCE_DIR/BuildTools/Bindings/java" -B "$BUILD_DIR" -G Ninja \
    "-DCMAKE_BUILD_TYPE=$CONFIGURATION" \
    "-DBINDINGS_PYTHON_EXECUTABLE=$VENV_DIR/bin/python" \
    "-DBINDINGS_LIBCLANG=$LIBCLANG"
cmake --build "$BUILD_DIR" --config "$CONFIGURATION" --parallel "$(nproc)"

# Enable production JNI bindings in the caller's main build. Radient and its
# dependencies are built there once; this action builds only the small fixtures.
# configure-cmake interprets cmake-args through Bash, so preserve paths with spaces.
printf -v RADIENT_CMAKE_ARGS '%q ' \
    -DRADIENT_BUILD_JAVA_BINDINGS=ON \
    "-DRADIENT_BINDINGS_PYTHON_EXECUTABLE=$VENV_DIR/bin/python" \
    "-DRADIENT_BINDINGS_LIBCLANG=$LIBCLANG"
{
    echo "JAVA_HOME=$JAVA_HOME"
    echo "RADIENT_JAVA_CMAKE_ARGS=$RADIENT_CMAKE_ARGS"
    echo "DILIGENT_JAVA_TEST_BUILD_DIR=$BUILD_DIR"
} >> "${GITHUB_ENV:?}"
