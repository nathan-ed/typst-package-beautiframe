// One page per style. Where a style puts the proof label in its own column,
// the label and the first line of the body must share a baseline: the QED
// glyph is set larger than the text and used to push the body line down
// (fixed in 0.4.5). Styles that set the label inline are on the page too, so
// the fixture also proves every style renders a proof at all.
//
// The words are free of descenders, so the lowest inked row of a column IS
// its baseline.
#import "/src/lib.typ": *

#set page(width: 14cm, height: 3.4cm, margin: 1cm)
#set text(font: "New Computer Modern", size: 10.5pt)

#for s in ("classic", "modern", "elegant", "colorful", "boxed",
           "minimal", "academic", "bw", "cours") {
  beautiframe-reset-config()
  beautiframe-setup(style: s)
  proof[Immediate.]
  pagebreak(weak: true)
}
