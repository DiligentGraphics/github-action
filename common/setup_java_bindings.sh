#!/usr/bin/env bash
set -euo pipefail

# Toolchain selection belongs to the calling action; this script consumes it.
if [[ "${RUNNER_OS:-Linux}" != "Linux" ]]; then
    echo "::error::Java binding test setup currently supports Linux runners."
    exit 1
fi

SOURCE_DIR="$(cd "${INPUT_SOURCE_DIR:?Set source-dir to the DiligentFX source directory}" && pwd)"
LIBCLANG="${INPUT_LIBCLANG:?Set libclang to the parser shared library}"
VENV_DIR="${RUNNER_TEMP:?}/bindings-venv"
export JAVA_HOME="${INPUT_JAVA_HOME:?Set java-home to an installed JDK}"
if [[ ! -x "$JAVA_HOME/bin/javac" ]]; then
    echo "::error::java-home must point to an installed JDK: $JAVA_HOME"
    exit 1
fi

python3 -m venv "$VENV_DIR"
"$VENV_DIR/bin/python" -m pip install -r "$SOURCE_DIR/BuildTools/Bindings/requirements.txt"

# Enable production JNI bindings in the caller's native or Android build.
# configure-cmake interprets cmake-args through Bash, so preserve paths with spaces.
printf -v RADIENT_CMAKE_ARGS '%q ' \
    -DRADIENT_BUILD_JAVA_BINDINGS=ON \
    "-DRADIENT_BINDINGS_PYTHON_EXECUTABLE=$VENV_DIR/bin/python" \
    "-DRADIENT_BINDINGS_LIBCLANG=$LIBCLANG"
{
    echo "JAVA_HOME=$JAVA_HOME"
    echo "RADIENT_JAVA_CMAKE_ARGS=$RADIENT_CMAKE_ARGS"
    echo "RADIENT_BINDINGS_PYTHON_EXECUTABLE=$VENV_DIR/bin/python"
    echo "RADIENT_BINDINGS_LIBCLANG=$LIBCLANG"
} >> "${GITHUB_ENV:?}"
echo "$JAVA_HOME/bin" >> "${GITHUB_PATH:?}"
