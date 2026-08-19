// Renders the three header layouts across every style.
#import "/src/lib.typ": *

#set page(width: 17cm, height: auto, margin: 1.4cm)
#set text(size: 10pt, lang: "fr")

#let corpus = {
  remark(title: "Qu'est-ce que l'analyse ?")[Étude des passages à la limite.]
  theorem(title: "Valeurs intermédiaires")[Si $f$ est continue sur $[a; b]$…]
  definition[Une suite convergente admet une limite finie.]
  proof[Immédiat.]
}

#let bloc(sty, variant, layout, abbrev) = {
  beautiframe-setup(style: sty, default-variant: variant)
  preset-french()
  beautiframe-setup(header-layout: layout, label-abbrev: abbrev)
  beautiframe-reset()
  heading(level: 3, layout + if abbrev { " + abbrev" } else { "" })
  corpus
}

#for (sty, variant) in (
  ("boxed", "centered"), ("bw", "boxed"), ("cours", "standard"),
  ("classic", "standard"), ("modern", "standard"), ("elegant", "standard"),
  ("colorful", "standard"), ("minimal", "standard"), ("academic", "standard"),
) {
  heading(level: 2, sty)
  bloc(sty, variant, "label-first", false)
  bloc(sty, variant, "title-first", false)
  bloc(sty, variant, "title-first", true)
  bloc(sty, variant, "prefix", true)
  pagebreak(weak: true)
}
