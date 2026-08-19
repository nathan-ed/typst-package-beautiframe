#!/usr/bin/env bash
# Compiles tests/trou.typ in both builds; fails on any Typst error or warning.
set -euo pipefail
cd "$(dirname "$0")/.."
status=0
for mode in student instructor; do
  out=$(typst compile tests/trou.typ "/tmp/beautiframe-trou-$mode.pdf" \
        --root . --input "mode=$mode" 2>&1) || status=1
  if [[ -n "$out" ]]; then
    echo "FAIL  $mode"
    echo "$out"
    status=1
  else
    echo "ok    $mode"
  fi
done
exit $status
