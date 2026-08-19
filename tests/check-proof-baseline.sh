#!/usr/bin/env bash
# Renders a proof in every style. Where the style gives the label its own
# column, the label and the body must share a baseline: the QED symbol is set
# at 1.4em, and left to dictate the height of the line it dropped the body
# below the label (regression fixed in 0.4.5).
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
import glob, re, sys
from PIL import Image

styles = ["classic", "modern", "elegant", "colorful", "boxed",
          "minimal", "academic", "bw", "cours"]
files = sorted(glob.glob(sys.argv[1] + "/p-*.png"),
               key=lambda f: int(re.search(r"p-(\d+)", f).group(1)))
if len(files) != len(styles):
    print("FAIL  %d pages rendues pour %d styles" % (len(files), len(styles)))
    raise SystemExit(1)

status = 0
for style, f in zip(styles, files):
    im = Image.open(f).convert("L")
    w, h = im.size
    px = im.load()
    inked = [x for x in range(w) if any(px[x, y] < 128 for y in range(h))]
    if not inked:
        print("FAIL  %-9s page vide" % style)
        status = 1
        continue
    # colonnes d'encre séparées par un blanc d'au moins 25 px
    runs, start, prev = [], inked[0], inked[0]
    for x in inked[1:]:
        if x - prev > 25:
            runs.append((start, prev))
            start = x
        prev = x
    runs.append((start, prev))
    # un filet ou un cadre couvre la largeur : ce n'est pas une colonne de texte
    runs = [r for r in runs if r[1] - r[0] < 0.6 * w]
    # le symbole QED est poussé par h(1fr) contre la marge droite : ce n'est
    # pas le corps du texte, il ne doit pas servir de point de comparaison
    runs = [r for r in runs if r[0] < 0.6 * w]
    if len(runs) < 2:
        print("ok    %-9s label en ligne, rien à comparer (preuve rendue)" % style)
        continue
    def lowest(run):
        a, b = run
        return max(y for y in range(h) if any(px[x, y] < 128 for x in range(a, b + 1)))
    delta = lowest(runs[1]) - lowest(runs[0])
    if abs(delta) <= 2:
        print("ok    %-9s label et corps sur la même ligne de base (%+d px)" % (style, delta))
    else:
        print("FAIL  %-9s label et corps décalés de %+d px" % (style, delta))
        status = 1
raise SystemExit(status)
PY
