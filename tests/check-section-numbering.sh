#!/usr/bin/env bash
# Runs the section numbering test suite.
set -euo pipefail
cd "$(dirname "$0")/.."
out=$(typst compile tests/section-numbering.typ "/tmp/beautiframe-section-numbering.pdf" --root . 2>&1)
if [[ -n "$out" ]]; then
  echo "FAIL  section-numbering"
  echo "$out"
  exit 1
else
  echo "ok    section-numbering"
fi
