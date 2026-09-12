#!/usr/bin/env bash
# Compiles tests/counter-mode.typ; fails on any Typst error or assertion failure.
set -euo pipefail
cd "$(dirname "$0")/.."
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
out=$(typst compile tests/counter-mode.typ "$tmp/out.pdf" --root . 2>&1) || { echo "$out"; exit 1; }
if [[ -n "$out" ]]; then echo "FAIL"; echo "$out"; exit 1; fi
echo "ok    counter-mode"
