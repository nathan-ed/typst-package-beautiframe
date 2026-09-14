#!/usr/bin/env bash
# Compiles tests/instructor-envs.typ in both builds. The file asserts on the
# counters and reference markers, so a gating regression fails the compilation.
set -euo pipefail
cd "$(dirname "$0")/.."
status=0
for mode in student instructor; do
  out=$(typst compile tests/instructor-envs.typ "/tmp/beautiframe-instructor-envs-$mode.pdf" \
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
