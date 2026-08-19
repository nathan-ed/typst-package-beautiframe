// env-colors, label-color and perceptual tints across styles and colour modes.
#import "/src/lib.typ": *

#set page(width: 17cm, height: auto, margin: 1.3cm)
#set text(size: 10pt, lang: "fr")

#let corpus = {
  theorem(title: "Pythagore")[$a^2 + b^2 = c^2$.]
  definition(title: "Suite convergente")[Elle admet une limite finie.]
  example(title: "Application")[$3, 4, 5$.]
  remark(title: "Attention")[La réciproque est fausse.]
}

#let bloc(titre, ..opts) = {
  preset-french()
  beautiframe-setup(..opts)
  beautiframe-reset()
  heading(level: 3, titre)
  corpus
}

// Every boxed-only variant must honour the per-environment colours
#for variant in ("titled", "centered", "corner", "corner2", "prominent", "standard", "accent") {
  heading(level: 2, "boxed / " + variant)
  bloc("env-colors: false", style: "boxed", default-variant: variant,
       env-colors: false, label-color: auto)
  bloc("env-colors: true", style: "boxed", default-variant: variant,
       env-colors: true, label-color: auto)
  bloc("+ label-color base", style: "boxed", default-variant: variant,
       env-colors: true, label-color: "base")
  pagebreak(weak: true)
}

// Every style honours env-colors and label-color
#for sty in ("classic","modern","elegant","colorful","minimal","academic","bw","cours") {
  heading(level: 2, sty)
  bloc("défaut", style: sty, default-variant: "standard", env-colors: false, label-color: auto)
  bloc("env-colors + label-color", style: sty, default-variant: "standard",
       env-colors: true, label-color: "base")
  pagebreak(weak: true)
}

// Tints under each colour mode
#for mode in ("color", "grayscale", "bw") {
  heading(level: 2, "tints / color-mode " + mode)
  bloc("auto", style: "boxed", default-variant: "accent", color-mode: mode, background-tint: auto)
  bloc("fixe 92%", style: "boxed", default-variant: "accent", color-mode: mode, background-tint: 92%)
  bloc("lightness 0.85", style: "boxed", default-variant: "accent", color-mode: mode,
       background-tint: auto, background-lightness: 0.85)
}
