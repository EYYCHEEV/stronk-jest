#!/bin/sh

set -e

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

cd "$ROOT_DIR"

echo "Building upstream Wally package outputs (build/wally) ..."
if command -v foreman >/dev/null 2>&1; then
  foreman run sh "$ROOT_DIR/scripts/build-wally-package.sh"
else
  sh "$ROOT_DIR/scripts/build-wally-package.sh"
fi

OUT_DIR="$ROOT_DIR/build/stronk-wally"
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

copy_pkg() {
  module_name=$1
  source_meta_dir=$2
  out_name=$3

  in_dir="$ROOT_DIR/build/wally/$module_name"
  out_dir="$OUT_DIR/$out_name"

  if [ ! -d "$in_dir" ]; then
    echo "error: expected '$in_dir' to exist (did build-wally-package.sh succeed?)" 1>&2
    exit 1
  fi

  rm -rf "$out_dir"
  cp -R "$in_dir" "$out_dir"

  if [ -f "$source_meta_dir/wally.toml" ]; then
    cp "$source_meta_dir/wally.toml" "$out_dir/wally.toml"
  else
    echo "error: missing '$source_meta_dir/wally.toml' (Stronk publish metadata)" 1>&2
    exit 1
  fi

  if [ -f "$source_meta_dir/default.project.json" ]; then
    cp "$source_meta_dir/default.project.json" "$out_dir/default.project.json"
  else
    echo "error: missing '$source_meta_dir/default.project.json' (Wally/Rojo entrypoint name)" 1>&2
    exit 1
  fi
}

copy_pkg jest-runtime "$ROOT_DIR/src/jest-runtime" jest-runtime
copy_pkg jest-circus "$ROOT_DIR/src/jest-circus" jest-circus
copy_pkg jest-runner "$ROOT_DIR/src/jest-runner" jest-runner
copy_pkg jest-core "$ROOT_DIR/src/jest-core" jest-core
copy_pkg jest "$ROOT_DIR/src/jest" stronk-jest

rm -rf "$OUT_DIR/stronk-jest-globals"
cp -R "$ROOT_DIR/wally-packages/jest-globals" "$OUT_DIR/stronk-jest-globals"

echo ""
echo "Stronk publish outputs are ready:"
echo "  $OUT_DIR"
echo ""
echo "Publish order:"
echo "  1) jest-runtime"
echo "  2) jest-circus"
echo "  3) jest-runner"
echo "  4) jest-core"
echo "  5) stronk-jest"
echo "  6) stronk-jest-globals"
