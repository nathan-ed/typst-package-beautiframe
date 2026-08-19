#!/usr/bin/env bash
# Compiles tests/colors.typ; fails on any Typst error or warning.
set -euo pipefail
cd "$(dirname "$0")/.."
out=$(typst compile tests/colors.typ /tmp/beautiframe-colors.pdf --root . 2>&1) || { echo "$out"; exit 1; }
if [[ -n "$out" ]]; then echo "FAIL"; echo "$out"; exit 1; fi
echo "ok    colors"
