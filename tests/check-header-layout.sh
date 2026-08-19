#!/usr/bin/env bash
# Compiles tests/header-layout.typ; fails on any Typst error or warning.
set -euo pipefail
cd "$(dirname "$0")/.."
out=$(typst compile tests/header-layout.typ /tmp/beautiframe-header-layout.pdf --root . 2>&1) || { echo "$out"; exit 1; }
if [[ -n "$out" ]]; then echo "FAIL"; echo "$out"; exit 1; fi
echo "ok    header-layout"
