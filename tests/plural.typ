// Regression fixture: `plural: true` must be a per-call override.
//
// It used to call beautiframe-setup, which updates the global config state, so
// a single plural environment turned every later environment of the same type
// plural with no way back to the singular label.
//
// Each environment prints singular / plural / singular. The third line is the
// regression: before the fix it read "Definitions 3", "Theorems 3", etc.
//
// Run: bash tests/check-plural.sh

#import "../src/lib.typ": *

#set page(paper: "a4", margin: 2cm)
#set text(size: 9pt)

#beautiframe-setup(style: "minimal")

// One environment per page, so the checker can read each page's label words in
// order without a neighbouring block's label bleeding into the match.
#let trio(f, tag) = {
  f[CHK-#(tag)-before]
  f(plural: true)[CHK-#(tag)-plural]
  f[CHK-#(tag)-after]
  pagebreak(weak: true)
}

#trio(theorem, "thm")
#trio(definition, "def")
#trio(lemma, "lem")
#trio(proposition, "prop")
#trio(corollary, "cor")
#trio(remark, "rem")
#trio(example, "ex")

// Custom environments already used a per-call display-label; kept as a guard.
#let conjecture = new-env("Conjecture", plural: "Conjectures", base: "theorem")
#trio(conjecture, "conj")
