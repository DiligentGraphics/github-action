#!/usr/bin/env bash
set -euo pipefail

ACTION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BROWSER_WRAPPER="$ACTION_DIR/../common/chrome_swiftshader.sh"
chmod +x "$BROWSER_WRAPPER"
"$BROWSER_WRAPPER" --version

SOURCE_DIR="${INPUT_SOURCE_DIR:-DiligentSamples}"
BUILD_DIR="${INPUT_BUILD_DIR:-${DILIGENT_BUILD_DIR:?Set build-dir or DILIGENT_BUILD_DIR}/DiligentSamples}"

# Sample selection, exclusions, and image tolerance remain in DiligentSamples.
python3 -B "$SOURCE_DIR/Tests/browser/run_tests.py" \
    --build-dir "$BUILD_DIR" \
    --reference-directory "${INPUT_REFERENCE_DIRECTORY:-DiligentTestData/GoldenImages/Chrome}" \
    --browser "$BROWSER_WRAPPER" \
    --mode "${INPUT_MODE:-wgpu}" \
    --filter "${INPUT_FILTER:-*}" \
    --output "${INPUT_OUTPUT_DIR:-SamplesBrowserResults}"
