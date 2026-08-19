#!/usr/bin/env bash
# The proof label sits in its own column; the QED symbol, set larger than the
# text, must not grow the line box and push the body line off the label's
# baseline (regression fixed in 0.4.5).
#
# Both words in the fixture are free of descenders, so the lowest inked row of
# a column IS its baseline. The label column is the first horizontal run of ink
# on the page, the body the next one after a gap.
set -euo pipefail
cd "$(dirname "$0")/.."

if ! python3 -c "import PIL" 2>/dev/null; then
  echo "skip  proof-baseline (python3 Pillow absent)"
  exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
typst compile tests/proof-baseline.typ "$tmp/p-{p}.png" --root . --ppi 200

python3 - "$tmp" <<'PY'
import glob, sys
from PIL import Image

status = 0
for f in sorted(glob.glob(sys.argv[1] + "/p-*.png")):
    im = Image.open(f).convert("L")
    w, h = im.size
    px = im.load()
    inked = [x for x in range(w) if any(px[x, y] < 128 for y in range(h))]
    if not inked:
        print("FAIL  %s : page vide" % f)
        status = 1
        continue
    # découper les colonnes d'encre séparées par un blanc d'au moins 25 px
    runs, start, prev = [], inked[0], inked[0]
    for x in inked[1:]:
        if x - prev > 25:
            runs.append((start, prev))
            start = x
        prev = x
    runs.append((start, prev))
    if len(runs) < 2:
        print("FAIL  %s : une seule colonne d'encre" % f)
        status = 1
        continue
    def lowest(run):
        a, b = run
        return max(y for y in range(h) if any(px[x, y] < 128 for x in range(a, b + 1)))
    delta = lowest(runs[1]) - lowest(runs[0])
    name = f.split("/")[-1]
    if abs(delta) <= 2:
        print("ok    baseline %s (écart %+d px)" % (name, delta))
    else:
        print("FAIL  baseline %s : label et corps décalés de %+d px" % (name, delta))
        status = 1
raise SystemExit(status)
PY
