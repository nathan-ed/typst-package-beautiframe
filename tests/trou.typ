// Renders every style's trou in both builds. Compile with
//   typst compile tests/trou.typ --root . --input mode=student
//   typst compile tests/trou.typ --root . --input mode=instructor
#import "/src/lib.typ": *

#let instructor = sys.inputs.at("mode", default: "student") == "instructor"

#set page(width: 16cm, height: auto, margin: 1.6cm)
#set text(size: 10pt, lang: "fr")

#let demo(sty, variant) = {
  beautiframe-setup(style: sty, default-variant: variant, instructor-mode: instructor)
  heading(level: 2, sty)
  definition(title: "Continuité")[
    $f$ est continue en $a$ si $lim_(x -> a) f(x) = f(a)$.
    #trou(hint: [contre-exemple])[La fonction de Dirichlet n'est continue nulle part.]
  ]
  trou(hint: [esquisse], fill: "lines", height: 2.5cm)[Le graphe de $|x|$.]
  trou(fill: "grid", height: 2cm, frame: false)[Repère millimétré.]
  [Une fonction #trou-inline[continue] sur $[a; b]$ atteint ses bornes.]
}

#for (sty, variant) in (
  ("boxed", "centered"), ("bw", "boxed"), ("cours", "standard"),
  ("classic", "standard"), ("modern", "standard"), ("elegant", "standard"),
  ("colorful", "standard"), ("minimal", "standard"), ("academic", "standard"),
) { demo(sty, variant) }
