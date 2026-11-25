#!/usr/bin/env bash
set -euo pipefail

ACTION_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$(cd "${INPUT_SOURCE_DIR:-DiligentFX}" && pwd)"
BUILD_DIR="${INPUT_BUILD_DIR:-${DILIGENT_BUILD_DIR:?Set build-dir or DILIGENT_BUILD_DIR}}"
OUTPUT_DIR="${INPUT_OUTPUT_DIR:-RadientNpmPackage}"
mkdir "$OUTPUT_DIR"
OUTPUT_DIR="$(cd "$OUTPUT_DIR" && pwd)"
SCRIPTS="$SOURCE_DIR/Radient/bindings/javascript/package"
export BINDINGS_TEST_BROWSER_EXECUTABLE="$ACTION_DIR/../common/chrome_swiftshader.sh"
chmod +x "$BINDINGS_TEST_BROWSER_EXECUTABLE"
"$BINDINGS_TEST_BROWSER_EXECUTABLE" --version

python3 -B "$SCRIPTS/tests/test_assembly.py" -v 2>&1 | tee "$OUTPUT_DIR/assembly-tests.log"

ARGS=(--build-dir "$BUILD_DIR" --output "$OUTPUT_DIR/package")
if [[ -n "${INPUT_VERSION:-}" ]]; then ARGS+=(--version "$INPUT_VERSION"); fi
python3 -B "$SCRIPTS/assemble.py" "${ARGS[@]}" 2>&1 | tee "$OUTPUT_DIR/assembly.log"
npm pack "$OUTPUT_DIR/package" --pack-destination "$OUTPUT_DIR" --json > "$OUTPUT_DIR/pack.log"
TARBALL="$OUTPUT_DIR/$(node -p 'JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"))[0].filename' "$OUTPUT_DIR/pack.log")"
python3 -B "$SCRIPTS/tests/run_tests.py" --tarball "$TARBALL" \
    --work-dir "$OUTPUT_DIR/consumer" 2>&1 | tee "$OUTPUT_DIR/tests.log"
# Publish this exact tested tarball later; never reassemble it in a release job.
(cd "$OUTPUT_DIR" && sha256sum "$(basename "$TARBALL")" > package.sha256)
echo "tarball=$TARBALL" >> "$GITHUB_OUTPUT"
