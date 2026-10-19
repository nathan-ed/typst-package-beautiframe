#!/usr/bin/env bash
# Runs the counter-mode test suite, then checks that a malformed counter-mode
# is rejected at setup with a readable message.
set -euo pipefail
cd "$(dirname "$0")/.."
root=$(pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
status=0

if out=$(typst compile tests/counter-mode.typ "$tmp/out.pdf" --root . 2>&1) && [[ -z "$out" ]]; then
  echo "ok    counter-mode"
else
  echo "FAIL  counter-mode"; echo "$out"; status=1
fi

expect_error() {
  local setup=$1 expected=$2
  printf '#import "%s/src/lib.typ": *\n#beautiframe-setup(%s)\n#theorem[]\n' "$root" "$setup" > "$tmp/bad.typ"
  if typst compile "$tmp/bad.typ" "$tmp/bad.pdf" --root / 2>"$tmp/err"; then
    echo "FAIL  accepted: $setup"; status=1
  elif grep -qF "$expected" "$tmp/err"; then
    echo "ok    rejected: $setup"
  else
    echo "FAIL  wrong error for: $setup"; cat "$tmp/err"; status=1
  fi
}

expect_error 'counter-mode: "unified"' 'counter-mode is "independent", "shared"'
expect_error 'counter-mode: 3' 'counter-mode is "independent", "shared"'
expect_error 'counter-mode: (lemma: 1)' 'got (lemma: 1)'
expect_error 'counter-shared: "yes"' 'counter-shared is true or false'
expect_error 'counter-mode: x => 1' 'a counter target is'

exit $status
