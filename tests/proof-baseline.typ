// One page per style whose proof puts the label in its own column. The label
// and the first line of the body must share a baseline: the QED glyph is set
// larger than the text and used to push the body line down (fixed in 0.4.5).
// Both words are chosen without descenders, so the lowest inked row of each
// column IS its baseline.
#import "/src/lib.typ": *

#set page(width: 14cm, height: 3cm, margin: 1cm)
#set text(font: "New Computer Modern", size: 10.5pt)

#for s in ("classic", "cours") {
  beautiframe-reset-config()
  beautiframe-setup(style: s)
  proof[Immediate.]
  pagebreak(weak: true)
}
