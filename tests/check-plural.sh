#!/usr/bin/env bash
# Assert that `plural: true` affects only the call it is passed to.
#
# It used to call beautiframe-setup, whose config update is global and
# permanent, so one plural environment turned every later environment of the
# same type plural. The regression shows up in the third block below: it read
# "Definitions 3" instead of "Definition 3".
#
# The fixture puts one environment per page, each rendering three blocks in
# order: singular, plural, singular. This reads the label words of a page in
# order and compares the sequence.
#
# Run from the package root:  bash tests/check-plural.sh

set -u
cd "$(dirname "$0")/.."
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

if ! typst compile --root . tests/plural.typ "$tmp/plural.pdf" 2>"$tmp/err"; then
  echo "FAIL  tests/plural.typ did not compile:"
  cat "$tmp/err"
  exit 1
fi

fail=0
page=0

# expect <singular> <plural>
expect() {
  local sing=$1 plur=$2 got want
  page=$((page + 1))
  want="$sing $plur $sing"
  got=$(pdftotext -f "$page" -l "$page" "$tmp/plural.pdf" - \
        | grep -oE "\b($sing|$plur)\b" | head -3 | tr '\n' ' ')
  got=${got% }
  if [ "$got" = "$want" ]; then
    printf 'ok    p%-2d %s\n' "$page" "$got"
  else
    printf 'FAIL  p%-2d expected "%s"  got "%s"\n' "$page" "$want" "$got"
    fail=1
  fi
}

expect Theorem     Theorems
expect Definition  Definitions
expect Lemma       Lemmas
expect Proposition Propositions
expect Corollary   Corollaries
expect Remark      Remarks
expect Example     Examples
expect Conjecture  Conjectures

exit $fail
