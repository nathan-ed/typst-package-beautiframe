#import "@preview/beautiframe:0.4.0": *

#set document(title: "Beautiframe Manual", author: "Nathan Scheinmann")
#set page(
  margin: (x: 2.5cm, y: 2cm),
  header: context {
    if counter(page).get().first() > 1 [
      #text(size: 9pt, fill: gray)[Beautiframe Manual #h(1fr) #counter(page).display()]
    ]
  }
)
#set text(font: "New Computer Modern", size: 11pt)
#set heading(numbering: "1.1")
#set par(justify: true)

// Title page
#align(center)[
  #v(3cm)
  #text(size: 32pt, weight: "bold")[Beautiframe]
  #v(0.5em)
  #text(size: 16pt, fill: gray)[Beautiful Theorem-Like Environments for Typst]
  #v(1em)
  #text(size: 12pt)[Version 0.4.0]
  #v(2cm)
  #text(size: 11pt)[Nathan Scheinmann]
  #v(4cm)
]

#pagebreak()

#outline(indent: auto, depth: 3)

#pagebreak()

= Introduction

*Beautiframe* is a Typst package for creating beautiful theorem-like environments (theorems, definitions, lemmas, proofs, etc.) with multiple visual styles.

== Features

- *9 distinct styles*: classic, modern, elegant, colorful, boxed, minimal, academic, *bw*, *cours*
- *6 variants per style*: prominent, standard, subtle, accent, minimal, inline
- *Flexible mapping*: Assign any variant to any environment type
- *Independent counters*: Each environment type has its own counter
- *Customizable labels*: Change "Theorem" to "Théorème", "Satz", etc.
- *QED symbol presets*: □, ■, ∎, CQFD, //, Q.E.D.
- *Color themes*: Pre-built themes (ocean, forest, sunset, lavender)
- *Language presets*: French, German, Spanish
- *French Math Preset*: one-call setup for French secondary math courses
- *QR sidebar*: attach a QR code column to any environment
- *Environment references*: label theorem-like blocks and link back to their page
- *Student fill space*: blank, ruled lines, or dot grid appended inside any environment
- *Print-friendly modes*: color, grayscale, black & white

== Quick Start

```typst
#import "@preview/beautiframe:0.4.0": *

#theorem(name: "Pythagorean")[
  In a right triangle: $a^2 + b^2 = c^2$
]

#definition[
  A *limit* is the value that a function approaches.
]

#proof[
  The proof is left as an exercise.
]
```

=== French Math Quick Start

```typst
#import "@preview/beautiframe:0.4.0": *

#preset-french-math()   // or #preset-french-math-bw()

#theoreme(name: "Pythagore")[Dans un triangle rectangle: $a^2 + b^2 = c^2$]
#definitionfr[Une fonction continue préserve les limites.]
#pratique(space: "lines", space-height: 3cm)[Calculer la dérivée de $f(x) = x^3$.]
```

#pagebreak()

= Environments

== Available Environments

Beautiframe provides 8 environment types:

#table(
  columns: (auto, auto, auto, auto),
  align: (left, left, center, left),
  [*Environment*], [*Default Variant*], [*Counter*], [*Usage*],
  [`theorem`], [prominent], [Optional], [Main results],
  [`definition`], [standard], [Optional], [Foundational concepts],
  [`lemma`], [standard], [Optional], [Supporting results],
  [`proposition`], [standard], [Optional], [Secondary results],
  [`corollary`], [standard], [Optional], [Consequences],
  [`remark`], [subtle], [Optional], [Commentary],
  [`example`], [accent], [Optional], [Illustrations],
  [`proof`], [(special)], [No], [Demonstrations],
)

== Basic Usage

Each environment function accepts:
- `name`: Optional name (e.g., `"Pythagorean"` or `[Pythagorean]`)
- `title`: Synonym for `name` — both are accepted, `name` takes priority
- `number`: `auto` (default), `none`, or custom value
- `label`: Typst label for `env-ref`, for example `<thm-pythagore>`
- `qr`: URL string to attach a QR code sidebar (requires `qr-renderer` configured)
- `space`: `"empty"`, `"lines"`, or `"grid"` — adds fill space for student work
- `space-height`: Height of the fill area (default `3cm`)
- `body`: The content

```typst
#theorem(name: "Fermat's Last")[
  There are no positive integers $a$, $b$, $c$ such that
  $a^n + b^n = c^n$ for $n > 2$.
]

// title: is accepted as a synonym for name:
#theorem(title: "Fermat's Last")[
  There are no positive integers $a$, $b$, $c$ such that
  $a^n + b^n = c^n$ for $n > 2$.
]
```

*Important:* When the name contains math, use content syntax `[...]` instead of string `"..."`, because strings do not process math markup:

```typst
// Wrong — $f$ appears as literal text
#theorem(name: "Continuity of $f$")[...]

// Correct
#theorem(name: [$f$ is continuous])[...]
```

#beautiframe-setup(style: "classic")
#beautiframe-reset()

#theorem(name: "Fermat's Last")[
  There are no positive integers $a$, $b$, $c$ such that
  $a^n + b^n = c^n$ for $n > 2$.
]

== Numbering Control

=== Automatic Numbering (default)

```typst
#theorem[First theorem]   // Theorem 1
#theorem[Second theorem]  // Theorem 2
```

=== No Numbering

```typst
#theorem(number: none)[Unnumbered theorem]
#definition(number: none)[Unnumbered definition]
```

#theorem(number: none, name: "Example")[This theorem has no number.]

=== Custom Numbering

```typst
#theorem(number: "A")[Special theorem A]
#theorem(number: "★")[Starred theorem]
```

#theorem(number: "A")[Special theorem A]

=== Numbered Remarks

By default, remarks have no number. To number them:

```typst
#remark(number: auto)[This remark will be numbered.]
```

#remark(number: auto)[This remark is numbered.]
#remark[This remark is not numbered (default).]

=== Section-Linked Numbering (LaTeX `\numberwithin` style)

Off by default. Two independent, opt-in settings control it:

- `link-to-section` — prefixes each environment number with the heading number.
  `false` (default) gives "Theorem 3"; `true` prefixes one heading level
  ("Theorem 2.3"); an integer $N$ prefixes the first $N$ heading levels
  ("Theorem 2.1.3" for `link-to-section: 2`).
- `counter-reset: "section"` — restarts every environment counter after each
  heading up to the `link-to-section` depth (level 1 when `link-to-section`
  is off). The default `"manual"` keeps counting across the whole document
  (reset by hand with `beautiframe-reset()`).

Combine both for the classic LaTeX behaviour:

```typst
#set heading(numbering: "1.1.")
#beautiframe-setup(link-to-section: true, counter-reset: "section")

= First section
#theorem[...]   // Theorem 1.1
#theorem[...]   // Theorem 1.2
= Second section
#theorem[...]   // Theorem 2.1

#beautiframe-setup(link-to-section: 2)
== A subsection
#theorem[...]   // Theorem 2.1.1
```

Both settings also apply to custom environments created with `new-env`
(and hence to `formule`, `methode`, `pratique`, ...): with the settings above,
`#formule[...]` renders as "Formule 1.1". References made with `env-ref` /
`env-refs` display the same section-linked number as the environment itself.

== References

Add a Typst label to any environment, then reference it with `#env-ref(<label>)`.
The reference text includes the environment label, number, and target page, and the whole text links to the labelled block.

```typst
#theorem(label: <thm-pythagore>, title: "Pythagore")[
  Dans un triangle rectangle: $a^2 + b^2 = c^2$.
]

Voir #env-ref(<thm-pythagore>).
// -> Théorème 1 (p. 3)

#remark(label: <rem-unites>)[Attention aux unités.]
Voir #env-ref(<rem-unites>).
// -> Remark (p. 3)
```

Use `page: false` to hide the page number:

```typst
#env-ref(<thm-pythagore>, page: false)
```

Use `page-style: "comma"` when the reference already sits inside parentheses:

```typst
(voir #env-ref(<thm-pythagore>, page-style: "comma"))
```

Use `env-refs` for several environments. Consecutive references with the same label are compacted:

```typst
#pratique(label: <prac-3>)[...]
#pratique(label: <prac-4>)[...]
#pratique(label: <prac-5>)[...]
#pratique(label: <prac-6>)[...]

Voir #env-refs(<prac-3>, <prac-4>, <prac-5>, <prac-6>, page: false).
// -> En pratique 3-6

Voir #env-refs(<prac-3>, <prac-4>, <prac-5>, <prac-6>, page-style: "comma").
// -> En pratique 3-6, pp. 4-5

#definition(label: <def-limite>)[...]
#proposition(label: <prop-limite>)[...]

Voir #env-refs(<def-limite>, <prop-limite>, page: false).
// -> Définition 1 et Proposition 2
```

=== Counter Reset

Reset all counters manually:

```typst
#beautiframe-reset()
```

#pagebreak()

= Styles

Beautiframe includes 9 visual styles. Each style provides 6 variants.

== Classic Style

Traditional textbook layout with badge on the left and content with left border. Based on the exercise-bank pattern.

```typst
#beautiframe-setup(style: "classic")
#theorem(name: "Classic")[In a right triangle: $a^2 + b^2 = c^2$]
#definition[A continuous function preserves limits.]
#remark[This is the default style.]
```

#beautiframe-setup(style: "classic")
#beautiframe-reset()

#theorem(name: "Classic")[In a right triangle: $a^2 + b^2 = c^2$]
#definition[A continuous function preserves limits.]
#remark[This is the default style.]

== Modern Style

Contemporary design with thick accent bars and rule separators.

```typst
#beautiframe-setup(style: "modern")
#theorem(name: "Modern")[In a right triangle: $a^2 + b^2 = c^2$]
#definition[A continuous function preserves limits.]
```

#beautiframe-setup(style: "modern")
#beautiframe-reset()

#theorem(name: "Modern")[In a right triangle: $a^2 + b^2 = c^2$]
#definition[A continuous function preserves limits.]

== Elegant Style

Sophisticated styling with centered headers and decorative ornaments.

```typst
#beautiframe-setup(style: "elegant")
#theorem(name: "Elegant")[In a right triangle: $a^2 + b^2 = c^2$]
#definition[A continuous function preserves limits.]
```

#beautiframe-setup(style: "elegant")
#beautiframe-reset()

#theorem(name: "Elegant")[In a right triangle: $a^2 + b^2 = c^2$]
#definition[A continuous function preserves limits.]

== Colorful Style

Each environment type has a distinct color for visual differentiation.

```typst
#beautiframe-setup(style: "colorful")
#theorem[Red for theorems.]
#definition[Blue for definitions.]
#example[Green for examples.]
```

#beautiframe-setup(style: "colorful")
#beautiframe-reset()

#theorem[Red for theorems.]
#definition[Blue for definitions.]
#example[Green for examples.]

== Boxed Style

Full framed boxes with optional backgrounds and header bars.

```typst
#beautiframe-setup(style: "boxed", border-radius: 3pt)
#theorem(name: "Boxed")[In a right triangle: $a^2 + b^2 = c^2$]
#definition[A continuous function preserves limits.]
```

#beautiframe-setup(style: "boxed", border-radius: 3pt)
#beautiframe-reset()

#theorem(name: "Boxed")[In a right triangle: $a^2 + b^2 = c^2$]
#definition[A continuous function preserves limits.]

== Minimal Style

Ultra-clean, print-friendly. Minimal ink usage.

```typst
#beautiframe-setup(style: "minimal")
#theorem(name: "Minimal")[In a right triangle: $a^2 + b^2 = c^2$]
#definition[A continuous function preserves limits.]
```

#beautiframe-setup(style: "minimal")
#beautiframe-reset()

#theorem(name: "Minimal")[In a right triangle: $a^2 + b^2 = c^2$]
#definition[A continuous function preserves limits.]

== Academic Style

Formal research paper style matching AMS/journal conventions.

```typst
#beautiframe-setup(style: "academic")
#theorem(name: "Academic")[In a right triangle: $a^2 + b^2 = c^2$]
#definition[A continuous function preserves limits.]
```

#beautiframe-setup(style: "academic")
#beautiframe-reset()

#theorem(name: "Academic")[In a right triangle: $a^2 + b^2 = c^2$]
#definition[A continuous function preserves limits.]

== BW Style

Black-and-white two-column layout for printed French math courses (Gymnomath / coursCollège). A 3.35 cm right-aligned label column is separated from the content column by a horizontal rule (standard variant) or a box border (boxed/prominent variants).

Variants: `standard` (side-block with rule), `boxed` (light rect), `prominent` (thicker rect, for théorèmes), `accent` (env-color stroke and label), `minimal` (inline label), `inline`, `proof` (with QED).

```typst
#preset-french-math-bw()
#theoreme(name: "Pythagore")[Dans un triangle rectangle: $a^2 + b^2 = c^2$]
#definitionfr[Une fonction continue préserve les limites.]
#remarque[La réciproque est généralement fausse.]
#preuve[Par application directe de la définition.]
```

#preset-french-math-bw()
#beautiframe-reset-french-math()

#theoreme(name: "Pythagore")[Dans un triangle rectangle: $a^2 + b^2 = c^2$]
#definitionfr[Une fonction continue préserve les limites.]
#remarque[La réciproque est généralement fausse.]
#preuve[Par application directe de la définition.]

== Cours Style

French course style with a 2 cm label column that overhangs 1 cm into the left margin, and content framed with a thin left border. Optimised for A4 course sheets with 2.2 cm margins. Blue accent color by default.

Variants: `standard` (accent-colored border and label), `accent` (per-env color), `subtle` (muted), `minimal` (inline, for remarques), `inline`, `proof` (with QED).

```typst
#preset-french-math()
#theoreme(name: "Valeurs intermédiaires")[
  Si $f$ est continue sur $[a ; b]$, pour tout $y$ entre $f(a)$ et $f(b)$ il existe $c$ tel que $f(c) = y$.
]
#definitionfr[Une suite converge si elle admet une limite finie.]
#remarque[La réciproque est fausse en général.]
```

#preset-french-math()
#beautiframe-reset-french-math()

#theoreme(name: "Valeurs intermédiaires")[
  Si $f$ est continue sur $[a ; b]$, pour tout $y$ entre $f(a)$ et $f(b)$ il existe $c$ tel que $f(c) = y$.
]
#definitionfr[Une suite converge si elle admet une limite finie.]
#remarque[La réciproque est fausse en général.]

#pagebreak()

= Variants

Each style provides variants that can be assigned to any environment type. The 6 core variants are available in all styles:

#table(
  columns: (auto, 1fr, auto),
  [*Variant*], [*Description*], [*Default for*],
  [`prominent`], [Strongest visual emphasis, thick borders, bold colors], [theorem],
  [`standard`], [Normal, balanced styling], [definition, lemma, proposition, corollary],
  [`subtle`], [Lighter, less prominent, muted colors], [remark],
  [`accent`], [Uses environment-specific color], [example],
  [`minimal`], [Very light styling, minimal visual elements], [—],
  [`inline`], [No structural elements, flows with text], [—],
)

*Boxed style* has 3 additional variants:

#table(
  columns: (auto, 1fr),
  [*Variant*], [*Description*],
  [`titled`], [Label breaks the top border line (beautitled-style)],
  [`centered`], [Label centered at top, breaking the border],
  [`corner`], [L border (top + left sides)],
  [`corner2`], [Inverted L border (left + bottom sides)],
)

== Assigning Variants

Map any variant to any environment type:

```typst
#beautiframe-setup(
  theorem-variant: "prominent",  // Theorems get maximum emphasis
  lemma-variant: "subtle",       // Lemmas are de-emphasized
  remark-variant: "inline",      // Remarks flow inline
  example-variant: "accent",     // Examples use their color
)
```

== Setting All Variants at Once

The `default-variant` parameter sets *all* 7 environment variants in a single call. Individual overrides are applied after, so they win:

```typst
// Make every environment use the boxed variant
#beautiframe-setup(default-variant: "boxed")

// All boxed, except theorems which get prominent
#beautiframe-setup(default-variant: "boxed", theorem-variant: "prominent")
```

This is useful when switching styles (e.g., `bw` → `cours`) and wanting a uniform appearance, or when preparing a worksheet where all environments should have the same fill-space variant.

#beautiframe-setup(style: "classic")
#beautiframe-reset()

*All `minimal` via `default-variant`:*
#beautiframe-setup(default-variant: "minimal")
#theorem(name: "Sample")[Content.]
#definition[Content.]
#remark[Content.]

*All `standard`, theorem overridden to `prominent`:*
#beautiframe-setup(default-variant: "standard", theorem-variant: "prominent")
#beautiframe-reset()
#theorem(name: "Sample")[Content.]
#definition[Content.]
#remark[Content.]

#beautiframe-setup(style: "classic")
#beautiframe-reset()

== Visual Gallery: All Variants × All Styles

#pagebreak()

=== Classic Style

#beautiframe-setup(style: "classic")
#beautiframe-reset()

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 0.8em,
  [*Prominent:* #beautiframe-setup(theorem-variant: "prominent") #theorem(name: "Name")[Sample text.]],
  [*Standard:* #beautiframe-setup(theorem-variant: "standard") #theorem(name: "Name")[Sample text.]],
  [*Subtle:* #beautiframe-setup(theorem-variant: "subtle") #theorem(name: "Name")[Sample text.]],
  [*Accent:* #beautiframe-setup(theorem-variant: "accent") #theorem(name: "Name")[Sample text.]],
  [*Minimal:* #beautiframe-setup(theorem-variant: "minimal") #theorem(name: "Name")[Sample text.]],
  [*Inline:* #beautiframe-setup(theorem-variant: "inline") #theorem(name: "Name")[Sample text.]],
)

#pagebreak()

=== Modern Style

#beautiframe-setup(style: "modern")
#beautiframe-reset()

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 0.8em,
  [*Prominent:* #beautiframe-setup(theorem-variant: "prominent") #theorem(name: "Name")[Sample text.]],
  [*Standard:* #beautiframe-setup(theorem-variant: "standard") #theorem(name: "Name")[Sample text.]],
  [*Subtle:* #beautiframe-setup(theorem-variant: "subtle") #theorem(name: "Name")[Sample text.]],
  [*Accent:* #beautiframe-setup(theorem-variant: "accent") #theorem(name: "Name")[Sample text.]],
  [*Minimal:* #beautiframe-setup(theorem-variant: "minimal") #theorem(name: "Name")[Sample text.]],
  [*Inline:* #beautiframe-setup(theorem-variant: "inline") #theorem(name: "Name")[Sample text.]],
)

#pagebreak()

=== Elegant Style

#beautiframe-setup(style: "elegant")
#beautiframe-reset()

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 0.8em,
  [*Prominent:* #beautiframe-setup(theorem-variant: "prominent") #theorem(name: "Name")[Sample text.]],
  [*Standard:* #beautiframe-setup(theorem-variant: "standard") #theorem(name: "Name")[Sample text.]],
  [*Subtle:* #beautiframe-setup(theorem-variant: "subtle") #theorem(name: "Name")[Sample text.]],
  [*Accent:* #beautiframe-setup(theorem-variant: "accent") #theorem(name: "Name")[Sample text.]],
  [*Minimal:* #beautiframe-setup(theorem-variant: "minimal") #theorem(name: "Name")[Sample text.]],
  [*Inline:* #beautiframe-setup(theorem-variant: "inline") #theorem(name: "Name")[Sample text.]],
)

#pagebreak()

=== Colorful Style

#beautiframe-setup(style: "colorful")
#beautiframe-reset()

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 0.8em,
  [*Prominent:* #beautiframe-setup(theorem-variant: "prominent") #theorem(name: "Name")[Sample text.]],
  [*Standard:* #beautiframe-setup(theorem-variant: "standard") #theorem(name: "Name")[Sample text.]],
  [*Subtle:* #beautiframe-setup(theorem-variant: "subtle") #theorem(name: "Name")[Sample text.]],
  [*Accent:* #beautiframe-setup(theorem-variant: "accent") #theorem(name: "Name")[Sample text.]],
  [*Minimal:* #beautiframe-setup(theorem-variant: "minimal") #theorem(name: "Name")[Sample text.]],
  [*Inline:* #beautiframe-setup(theorem-variant: "inline") #theorem(name: "Name")[Sample text.]],
)

#pagebreak()

=== Boxed Style

#beautiframe-setup(style: "boxed", border-radius: 3pt)
#beautiframe-reset()

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 0.8em,
  [*Prominent:* #beautiframe-setup(theorem-variant: "prominent") #theorem(name: "Name")[Sample text.]],
  [*Standard:* #beautiframe-setup(theorem-variant: "standard") #theorem(name: "Name")[Sample text.]],
  [*Subtle:* #beautiframe-setup(theorem-variant: "subtle") #theorem(name: "Name")[Sample text.]],
  [*Accent:* #beautiframe-setup(theorem-variant: "accent") #theorem(name: "Name")[Sample text.]],
  [*Minimal:* #beautiframe-setup(theorem-variant: "minimal") #theorem(name: "Name")[Sample text.]],
  [*Inline:* #beautiframe-setup(theorem-variant: "inline") #theorem(name: "Name")[Sample text.]],
  [*Titled:* #beautiframe-setup(theorem-variant: "titled") #theorem(name: "Name")[Sample text.]],
  [*Centered:* #beautiframe-setup(theorem-variant: "centered") #theorem(name: "Name")[Sample text.]],
  [*Corner:* #beautiframe-setup(theorem-variant: "corner") #theorem(name: "Name")[Sample text.]],
  [*Corner2:* #beautiframe-setup(theorem-variant: "corner2") #theorem(name: "Name")[Sample text.]],
)

#pagebreak()

=== Minimal Style

#beautiframe-setup(style: "minimal")
#beautiframe-reset()

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 0.8em,
  [*Prominent:* #beautiframe-setup(theorem-variant: "prominent") #theorem(name: "Name")[Sample text.]],
  [*Standard:* #beautiframe-setup(theorem-variant: "standard") #theorem(name: "Name")[Sample text.]],
  [*Subtle:* #beautiframe-setup(theorem-variant: "subtle") #theorem(name: "Name")[Sample text.]],
  [*Accent:* #beautiframe-setup(theorem-variant: "accent") #theorem(name: "Name")[Sample text.]],
  [*Minimal:* #beautiframe-setup(theorem-variant: "minimal") #theorem(name: "Name")[Sample text.]],
  [*Inline:* #beautiframe-setup(theorem-variant: "inline") #theorem(name: "Name")[Sample text.]],
)

#pagebreak()

=== Academic Style

#beautiframe-setup(style: "academic")
#beautiframe-reset()

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 0.8em,
  [*Prominent:* #beautiframe-setup(theorem-variant: "prominent") #theorem(name: "Name")[Sample text.]],
  [*Standard:* #beautiframe-setup(theorem-variant: "standard") #theorem(name: "Name")[Sample text.]],
  [*Subtle:* #beautiframe-setup(theorem-variant: "subtle") #theorem(name: "Name")[Sample text.]],
  [*Accent:* #beautiframe-setup(theorem-variant: "accent") #theorem(name: "Name")[Sample text.]],
  [*Minimal:* #beautiframe-setup(theorem-variant: "minimal") #theorem(name: "Name")[Sample text.]],
  [*Inline:* #beautiframe-setup(theorem-variant: "inline") #theorem(name: "Name")[Sample text.]],
)

#pagebreak()

=== BW Style

#preset-french-math-bw()
#beautiframe-reset-french-math()

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 0.8em,
  [*Prominent:* #beautiframe-setup(theorem-variant: "prominent") #theorem(name: "Name")[Sample text.]],
  [*Standard:* #beautiframe-setup(theorem-variant: "standard") #theorem(name: "Name")[Sample text.]],
  [*Boxed:* #beautiframe-setup(theorem-variant: "boxed") #theorem(name: "Name")[Sample text.]],
  [*Accent:* #beautiframe-setup(theorem-variant: "accent") #theorem(name: "Name")[Sample text.]],
  [*Minimal:* #beautiframe-setup(theorem-variant: "minimal") #theorem(name: "Name")[Sample text.]],
  [*Inline:* #beautiframe-setup(theorem-variant: "inline") #theorem(name: "Name")[Sample text.]],
)

#pagebreak()

=== Cours Style

#preset-french-math()
#beautiframe-reset-french-math()

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 0.8em,
  [*Standard:* #beautiframe-setup(theorem-variant: "standard") #theorem(name: "Name")[Sample text.]],
  [*Accent:* #beautiframe-setup(theorem-variant: "accent") #theorem(name: "Name")[Sample text.]],
  [*Subtle:* #beautiframe-setup(theorem-variant: "subtle") #theorem(name: "Name")[Sample text.]],
  [*Minimal:* #beautiframe-setup(theorem-variant: "minimal") #theorem(name: "Name")[Sample text.]],
  [*Inline:* #beautiframe-setup(theorem-variant: "inline") #theorem(name: "Name")[Sample text.]],
)

#pagebreak()

= Proofs and QED Symbols

== Basic Proof

```typst
#proof[
  By direct calculation, we have $2^2 = 4$.
]
```

#beautiframe-setup(style: "classic", theorem-variant: "standard")

#proof[
  By direct calculation, we have $2^2 = 4$.
]

== QED Symbol Presets

Beautiframe provides several QED symbol presets:

```typst
#qed-square()     // □ (default)
#qed-filled()     // ■
#qed-tombstone()  // ∎
#qed-cqfd()       // CQFD (French)
#qed-slashes()    // //
#qed-text()       // Q.E.D.
#qed-none()       // (no symbol)
```

#grid(
  columns: (1fr, 1fr),
  column-gutter: 1em,
  row-gutter: 0.5em,
  [
    *Default (□):*
    #qed-square()
    #proof[Hollow square.]
  ],
  [
    *Filled (■):*
    #qed-filled()
    #proof[Filled square.]
  ],
  [
    *Tombstone (∎):*
    #qed-tombstone()
    #proof[Tombstone symbol.]
  ],
  [
    *CQFD:*
    #qed-cqfd()
    #proof[French style.]
  ],
  [
    *Slashes:*
    #qed-slashes()
    #proof[Double slash.]
  ],
  [
    *Q.E.D.:*
    #qed-text()
    #proof[Latin abbreviation.]
  ],
)

== Custom QED Symbol

```typst
#beautiframe-setup(qed-symbol: text(fill: green, sym.checkmark))
```

#beautiframe-setup(qed-symbol: text(size: 1.4em, fill: rgb("#27ae60"), sym.checkmark))
#proof[Custom green checkmark.]

#beautiframe-setup(qed-symbol: sym.square.stroked)

#pagebreak()

= Colors and Themes

== Global Colors

```typst
#beautiframe-setup(
  primary-color: rgb("#1a5276"),
  secondary-color: rgb("#7f8c8d"),
  accent-color: rgb("#2980b9"),
)
```

== Per-Environment Colors

Used primarily by the colorful style:

```typst
#beautiframe-setup(
  theorem-color: rgb("#c0392b"),    // Red
  definition-color: rgb("#2980b9"), // Blue
  lemma-color: rgb("#8e44ad"),      // Purple
  example-color: rgb("#27ae60"),    // Green
  remark-color: rgb("#7f8c8d"),     // Gray
)
```

== Color Themes

Pre-built color schemes:

#beautiframe-setup(style: "colorful")

*Ocean Theme:*
#theme-ocean()
#beautiframe-reset()
#theorem(number: none)[Blue tones throughout.]

*Forest Theme:*
#theme-forest()
#beautiframe-reset()
#theorem(number: none)[Green tones throughout.]

*Sunset Theme:*
#theme-sunset()
#beautiframe-reset()
#theorem(number: none)[Warm red and orange tones.]

*Lavender Theme:*
#theme-lavender()
#beautiframe-reset()
#theorem(number: none)[Purple tones throughout.]

== Print-Friendly Modes

For B&W printing:

```typst
#beautiframe-setup(color-mode: "color")      // Full color (default)
#beautiframe-setup(color-mode: "grayscale")  // Grayscale
#beautiframe-setup(color-mode: "bw")         // Pure black and white
```

#beautiframe-setup(style: "boxed", border-radius: 3pt)

*Color mode:*
#beautiframe-setup(color-mode: "color")
#beautiframe-reset()
#theorem(number: none)[Full color styling.]

*Grayscale mode:*
#beautiframe-setup(color-mode: "grayscale")
#beautiframe-reset()
#theorem(number: none)[Grayscale for B&W printers.]

*B&W mode:*
#beautiframe-setup(color-mode: "bw")
#beautiframe-reset()
#theorem(number: none)[Pure black and white.]

#beautiframe-setup(color-mode: "color")

#pagebreak()

= Language Presets

== French

```typst
#preset-french()
```

#beautiframe-setup(style: "classic")
#preset-french()
#beautiframe-reset()

#theorem(name: "Pythagore")[Dans un triangle rectangle: $a^2 + b^2 = c^2$]
#definition[Une fonction continue préserve les limites.]
#proof[Immédiat.]

== German

```typst
#preset-german()
```

#preset-german()
#beautiframe-reset()

#theorem(name: "Pythagoras")[In einem rechtwinkligen Dreieck: $a^2 + b^2 = c^2$]
#definition[Eine stetige Funktion erhält Grenzwerte.]
#proof[Offensichtlich.]

== Spanish

```typst
#preset-spanish()
```

#preset-spanish()
#beautiframe-reset()

#theorem(name: "Pitágoras")[En un triángulo rectángulo: $a^2 + b^2 = c^2$]
#definition[Una función continua preserva límites.]
#proof[Inmediato.]

== Custom Labels

```typst
#beautiframe-setup(
  theorem-label: "Théorème",
  definition-label: "Définition",
  proof-label: "Démonstration",
)
```

#pagebreak()

= Layout Configuration

== Classic Style Layout

The classic style uses a grid layout with configurable dimensions:

```typst
#beautiframe-setup(
  line-position: 2cm,   // Distance from left to vertical line
  label-extra: 1cm,     // Extension into left margin
  border-width: 1.5pt,  // Line thickness
)
```

== Spacing

```typst
#beautiframe-setup(
  theorem-above: 1.2em,   // Space before theorems
  theorem-below: 1em,     // Space after theorems
  header-gap: 0.4em,      // Gap between label and body
)
```

== Typography

Control label appearance:

```typst
#beautiframe-setup(
  label-weight: "bold",   // "bold", "regular", "semibold", etc.
  label-size: 11pt,       // Size of "Theorem", "Definition", etc.
  name-style: "italic",   // Style for theorem names: "italic" or "normal"
)
```

#beautiframe-setup(style: "boxed", border-radius: 3pt)
#beautiframe-reset()

*Bold label (default):*
#beautiframe-setup(label-weight: "bold")
#theorem(name: "Name")[Sample text.]

*Regular label:*
#beautiframe-setup(label-weight: "regular")
#theorem(name: "Name")[Sample text.]

#beautiframe-setup(label-weight: "bold")

== Boxed Style Options

```typst
#beautiframe-setup(
  inset: (x: 1em, y: 0.8em),  // Padding inside boxes
  border-radius: 4pt,         // Rounded corners
  border-width: 1.5pt,        // Border thickness
)
```

= Custom Environments

Create your own environment types with independent counters using `new-env`:

```typst
// Create custom environments
#let conjecture = new-env("Conjecture", base: "theorem")
#let propriete = new-env("Propriété", base: "definition", numbered: false)
#let formule = new-env("Formule", base: "lemma", color: green)
#let axiom = new-env("Axiom", base: "theorem", numbered: true)

// Use them like built-in environments
#conjecture[Every even number greater than 2 is the sum of two primes.]
#conjecture(name: "Goldbach")[Famous unsolved problem.]
#propriete[A property without number.]
#formule[The quadratic formula: $x = (-b plus.minus sqrt(b^2-4a c))/(2a)$]
```

#let conjecture = new-env("Conjecture", base: "theorem")
#let axiom = new-env("Axiom", base: "definition")

#beautiframe-setup(style: "boxed", theorem-variant: "titled", definition-variant: "titled")
#beautiframe-reset()

#conjecture[Every even number greater than 2 is the sum of two primes.]

#conjecture(name: "Goldbach")[Famous unsolved problem in number theory.]

#axiom[Two points determine a unique line.]

== Parameters

```typst
#let my-env = new-env(
  "Label",           // Display label (required)
  base: "theorem",   // Inherit style from: theorem, definition, lemma, etc.
  numbered: true,    // Auto-number by default
  color: none,       // Optional custom color
)
```

== Plural Forms

All environments support a `plural` parameter. Default plurals are provided for English and all language presets:

```typst
#theorem(plural: true)[Multiple theorems grouped together.]
#definition(plural: true)[Several related definitions.]
```

#beautiframe-setup(style: "boxed", theorem-variant: "titled")
#beautiframe-reset()

#theorem[A single theorem.]

#theorem(plural: true)[Multiple theorems can be grouped in one box.]

Language presets automatically set the correct plural forms:

```typst
#preset-french()  // Sets: Théorèmes, Définitions, Lemmes, etc.
#preset-german()  // Sets: Sätze, Definitionen, Lemmata, etc.
#preset-spanish() // Sets: Teoremas, Definiciones, Lemas, etc.
```

Custom environments also support plurals:

```typst
#let conjecture = new-env("Conjecture", plural: "Conjectures", base: "theorem")
#conjecture(plural: true)[Two famous conjectures.]
```

== Resetting Custom Counters

```typst
#reset-env("Conjecture")  // Reset specific custom environment
#beautiframe-reset()      // Reset all built-in counters
```

= French Math Preset

The French math preset configures beautiframe in a single call for French secondary and post-secondary math courses.

== Preset Functions

```typst
// Color version — cours style, blue accent, bold labels, QED square
#preset-french-math()

// Black-and-white version — bw style, 8.4pt labels, luma palette
#preset-french-math-bw()

// Reset all counters including custom French environments
#beautiframe-reset-french-math()
```

== French Environments

All French environments accept `name:` / `title:` (alias), `qr:`, `space:`, `space-height:`.

#table(
  columns: (auto, auto, auto, auto),
  align: (left, left, left, center),
  [*Function*], [*Label*], [*Base*], [*Numbered*],
  [`theoreme`], [Théorème], [theorem], [Yes],
  [`definitionfr`], [Définition], [definition], [Yes],
  [`propositionfr`], [Proposition], [proposition], [Yes],
  [`exemplefr` / `exemple`], [Exemple], [example], [Yes],
  [`remarque`], [Remarque], [remark], [No],
  [`corollaire`], [Corollaire], [corollary], [Yes],
  [`preuve`], [Preuve], [proof], [No],
  [`pratique`], [En pratique], [example], [Yes],
  [`propriete`], [Propriété], [corollary], [No],
  [`formule`], [Formule], [lemma], [Yes],
  [`formules(...)`], [Formules], [lemma], [Yes],
  [`methode`], [Méthode], [proposition], [Yes],
  [`notation(...)`], [Notation], [remark], [No],
  [`discussion(...)`], [Discussion], [remark], [No],
  [`objectifs` / `objectif`], [Objectifs d'apprentissage], [lemma], [No],
  [`concepts`], [Concepts clés], [lemma], [No],
  [`glossaire`], [Glossaire], [lemma], [No],
  [`defi` / `défi`], [🎯 Défi], [remark], [No],
)

== Challenge Callout (`defi`)

`#defi` renders a compact, unnumbered challenge callout using the remark style. The icon and title are optional.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | content or none | `none` | Optional title appended after "Défi :" |
| `icon` | content or none | `[🎯]` | Decorative icon; set `none` to hide |
| `label` | label or none | `none` | Cross-reference label |
| `qr` | string or none | `none` | QR sidebar URL |
| `space` | string or none | `none` | Fill space type |
| `space-height` | length | `3cm` | Height of fill area |
| `body` | content | — | Challenge content |

```typst
#defi[Résoudre $x^2 - 5x + 6 = 0$.]
#defi(title: [Y arrivez-vous ?])[Montrer que $sqrt(2)$ est irrationnel.]
#defi(icon: [🌶])[Justifier chaque étape du raisonnement.]
#defi(icon: none)[Sans icône.]
```

#preset-french-math-bw()
#beautiframe-reset-french-math()

#defi[Résoudre $x^2 - 5x + 6 = 0$.]
#defi(title: [Y arrivez-vous ?])[Montrer que $sqrt(2)$ est irrationnel.]

== Formula Recap (`formule-end` / `formules-recap`)

Collect formulas throughout a chapter and print them all at once in a recap box at the end. Use `#formule-end` to register a formula (nothing is displayed at the call site), then `#formules-recap` to render the collected list.

```typst
// Register formulas anywhere in the chapter (nothing rendered in place)
#formule-end([Discriminant], $Delta = b^2 - 4a c$)
#formule-end([Racines], $x = (-b plus.minus sqrt(Delta)) / (2a)$)

// Render the recap (clears the list by default)
#formules-recap()

// Custom title
#formules-recap(title: [Formules du chapitre])

// Keep the list for a second recap (clear: false)
#formules-recap(clear: false)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `label` | content | — | Formula name displayed in bold |
| `formula` | content | — | The formula content |

| Parameter (`formules-recap`) | Type | Default | Description |
|-----------------------------|------|---------|-------------|
| `title` | content | `[Formules à retenir]` | Box header |
| `clear` | bool | `true` | Clear the collection after printing |

#preset-french-math()
#beautiframe-reset-french-math()

#formule-end([Discriminant], $Delta = b^2 - 4a c$)
#formule-end([Racines], $x_(1,2) = display((-b plus.minus sqrt(Delta)) / (2a))$)
#formules-recap()

== Course Meta-Environments

Three unnumbered environments intended for course structure:

- `#objectifs` / `#objectif` — learning objectives at the start of a chapter
- `#concepts` — key concepts summary
- `#glossaire` — glossary or vocabulary list

```typst
#objectifs[
  - Savoir résoudre une équation du second degré
  - Connaître la formule du discriminant
]

#concepts[Équation, discriminant, racine, trinôme.]

#glossaire[*Racine* : valeur de $x$ pour laquelle $f(x) = 0$.]
```

#preset-french-math()
#beautiframe-reset-french-math()

#objectifs[
  - Savoir résoudre une équation du second degré.
  - Connaître et appliquer la formule du discriminant.
]

#concepts[Équation, discriminant, racine, trinôme du second degré.]

== Example

```typst
#import "@preview/beautiframe:0.4.0": *
#preset-french-math()

#theoreme(name: "Pythagore")[
  Dans tout triangle rectangle d'hypoténuse $c$: $a^2 + b^2 = c^2$.
]

#definitionfr[Une suite converge si elle admet une limite finie.]

#propriete[Toute suite monotone et bornée converge.]

#formule[
  $x = display((-b plus.minus sqrt(b^2 - 4a c)) / (2a))$
]

#pratique(space: "lines", space-height: 3cm)[
  Résoudre $2x^2 - 5x + 3 = 0$.
]

#preuve[Par calcul direct avec le discriminant.]
```

#preset-french-math()
#beautiframe-reset-french-math()

#theoreme(name: "Pythagore")[
  Dans tout triangle rectangle d'hypoténuse $c$: $a^2 + b^2 = c^2$.
]

#definitionfr[Une suite converge si elle admet une limite finie.]

#propriete[Toute suite monotone et bornée converge.]

#formule[
  $x = display((-b plus.minus sqrt(b^2 - 4 a c)) / (2a))$
]

#notation[On note $f'$ la dérivée de $f$, et $f^((n))$ la dérivée $n$-ième.]

#discussion[La condition $a > 0$ est nécessaire mais pas suffisante.]

#pratique(space: "lines", space-height: 2.5cm)[
  Résoudre $2x^2 - 5x + 3 = 0$.
]

#preuve[Par calcul direct avec le discriminant.]

#pagebreak()

= Instructor Mode

A single `instructor-mode` switch turns one source file into two documents:
the student handout (default) and the instructor version with corrections.

== Worked Exercises

`worked-exercise` renders an exercise statement; its `correction:` block is
shown only when `instructor-mode: true`:

```typst
#worked-exercise(
  title: "Dérivée d'un produit",
  correction: [On applique $(u v)' = u'v + u v'$ ...],
)[
  Dériver $f(x) = x^2 sin(x)$.
]

// In the instructor build:
#beautiframe-setup(instructor-mode: true)
```

Options:

- `correction-title:` overrides the heading of the correction block
  (default: the `correction-label` config, "Correction").
- `correction-renderer:` config — a `(title, body) => content` function
  replacing the default framed block.
- `discussion` accepts the same `correction:` / `correction-title:` options.

== Instructor-Only Environments

Every environment (built-ins and `new-env` customs) accepts `instructor: true`
to hide the *entire block* from the student version:

```typst
#remark(instructor: true)[
  Insister sur le cas $Delta = 0$ — erreur fréquente au test.
]
```

#pagebreak()

= QR Sidebar

Any environment can display a rendered QR code (or any content) in a right sidebar column.

== Configuration

```typst
// Configure once in your preamble
#beautiframe-setup(
  qr-renderer: url => image.decode(
    tiaoma.qrcode(url, options: (border: 0)),
    format: "svg", width: 1.85cm
  ),
  qr-width: 1.85cm,
)
```

The `qr-renderer` key accepts a function `url => content`. When set to `none` (default), no sidebar is shown even if `qr:` is passed.

== Usage

```typst
#theorem(qr: "https://example.com/proof")[
  In a right triangle: $a^2 + b^2 = c^2$.
]

#definitionfr(qr: "https://wiki.example.com/continuity")[
  Une fonction continue préserve les limites.
]
```

The QR sidebar works with all environments including custom ones created with `new-env`.

#pagebreak()

= Student Fill Space

Append a blank fill area inside any environment for students to write their answers.

== Parameters

- `space:` — `"empty"` (blank block), `"lines"` (8 mm ruled lines), `"grid"` (5 mm dot grid)
- `space-height:` — height of the fill area (default: `3cm`)

== Examples

```typst
// Blank area
#pratique(space: "empty", space-height: 2cm)[Define continuity.]

// Ruled lines
#pratique(space: "lines", space-height: 4cm)[Solve $2x - 5 = 7$.]

// Dot grid
#exemple(space: "grid", space-height: 5cm)[Sketch $f(x) = x^2$.]
```

#preset-french-math-bw()
#beautiframe-reset-french-math()

*Ruled lines (`space: "lines"`, height 3 cm):*
#pratique(space: "lines", space-height: 3cm)[Calculer la dérivée de $f(x) = 3x^2 - 2x + 1$.]

*Dot grid (`space: "grid"`, height 3.5 cm):*
#exemple(space: "grid", space-height: 3.5cm)[Représenter $f(x) = -x^2 + 4$ sur $[-3 ; 3]$.]

#pagebreak()

= API Reference

== Environment Functions

```typst
// Built-in environments (all accept name:/title:, number:, qr:, space:, space-height:)
#theorem(name: none, title: none, number: auto, qr: none, space: none, space-height: 3cm)[body]
#definition(name: none, title: none, number: auto, qr: none, space: none, space-height: 3cm)[body]
#lemma(name: none, title: none, number: auto, qr: none, space: none, space-height: 3cm)[body]
#proposition(name: none, title: none, number: auto, qr: none, space: none, space-height: 3cm)[body]
#corollary(name: none, title: none, number: auto, qr: none, space: none, space-height: 3cm)[body]
#remark(name: none, title: none, number: none, qr: none, space: none, space-height: 3cm)[body]
#example(name: none, title: none, number: auto, qr: none, space: none, space-height: 3cm)[body]
#proof[body]

// French aliases
#theoreme      = theorem
#definitionfr  = definition
#propositionfr = proposition
#exemplefr     = exemple = example
#remarque      = remark
#corollaire    = corollary
#preuve(body)  = proof

// French custom environments
#pratique(name: none, title: none, qr: none, space: none, space-height: 3cm)[body]
#propriete(name: none, title: none, qr: none, space: none, space-height: 3cm)[body]
#formule(name: none, title: none, qr: none, space: none, space-height: 3cm)[body]
#formules(name: none, title: none, qr: none, space: none, space-height: 3cm)[body]
#methode(name: none, title: none, qr: none, space: none, space-height: 3cm)[body]
#notation(name: none, title: none, qr: none, space: none, space-height: 3cm)[body]
#discussion(name: none, title: none, qr: none, space: none, space-height: 3cm)[body]
```

== Setup Function

#text(size: 9pt)[
```typst
#beautiframe-setup(
  style: "classic",              // classic, modern, elegant, colorful, boxed,
                                 // minimal, academic, bw, cours

  // ── Variant mapping ──────────────────────────────────────────────────────
  // default-variant sets all 7 at once; individual params override it
  default-variant: none,         // e.g. "standard" — applies to all 7 types
  theorem-variant: "prominent",
  definition-variant: "standard",
  lemma-variant: "standard",
  proposition-variant: "standard",
  corollary-variant: "standard",
  remark-variant: "subtle",
  example-variant: "accent",

  // ── Colors ───────────────────────────────────────────────────────────────
  primary-color: rgb("#2c3e50"),
  secondary-color: rgb("#7f8c8d"),
  accent-color: rgb("#2980b9"),
  background-color: white,
  // Per-environment colors (used by colorful style and accent variants)
  theorem-color: rgb("#c0392b"),
  definition-color: rgb("#2980b9"),
  lemma-color: rgb("#8e44ad"),
  proposition-color: rgb("#8e44ad"),
  corollary-color: rgb("#d35400"),
  remark-color: rgb("#7f8c8d"),
  example-color: rgb("#27ae60"),

  // ── Typography ───────────────────────────────────────────────────────────
  label-size: 1em,               // 1em = body font size (recommended default)
  label-weight: "bold",          // "bold", "regular", "semibold", etc.
  name-style: "italic",          // subtitle style: "italic" or "normal"
  body-size: none,               // inherited from document when none

  // ── Vertical spacing ─────────────────────────────────────────────────────
  theorem-above: 1em,
  theorem-below: 0.8em,
  definition-above: 1em,
  definition-below: 0.8em,
  lemma-above: 0.8em,
  lemma-below: 0.6em,
  proposition-above: 0.8em,
  proposition-below: 0.6em,
  corollary-above: 0.8em,
  corollary-below: 0.6em,
  remark-above: 0.6em,
  remark-below: 0.6em,
  example-above: 0.8em,
  example-below: 0.8em,
  proof-above: 0.5em,
  proof-below: 0.8em,
  header-gap: 0.3em,             // gap between label and body

  // ── Layout ───────────────────────────────────────────────────────────────
  inset: (x: 0.8em, y: 0.6em),  // padding inside boxes
  border-width: 1pt,             // stroke thickness
  border-radius: 0pt,            // rounded corners (boxed style)
  line-position: 2cm,            // vertical line distance from left (classic)
  label-extra: 1cm,              // label overhang into left margin (classic/cours)

  // ── Numbering ────────────────────────────────────────────────────────────
  numbering-format: "1",         // "1" or "1.1" (section.number)
  link-to-section: false,        // false, true (1 level) or int N: prefix with
                                 // the first N heading levels ("Theorem 2.1.3")
  counter-reset: "manual",       // "manual" or "section" (restart at each
                                 // heading up to the link-to-section depth)

  // ── Labels (singular) ────────────────────────────────────────────────────
  theorem-label: "Theorem",
  definition-label: "Definition",
  lemma-label: "Lemma",
  proposition-label: "Proposition",
  corollary-label: "Corollary",
  remark-label: "Remark",
  example-label: "Example",
  proof-label: "Proof",

  // ── Labels (plural, used when plural: true) ───────────────────────────────
  theorem-plural: "Theorems",
  definition-plural: "Definitions",
  lemma-plural: "Lemmas",
  proposition-plural: "Propositions",
  corollary-plural: "Corollaries",
  remark-plural: "Remarks",
  example-plural: "Examples",

  // ── QED ──────────────────────────────────────────────────────────────────
  qed-symbol: sym.square.stroked,

  // ── Advanced ─────────────────────────────────────────────────────────────
  breakable: true,               // allow page breaks within environments
  color-mode: "color",           // "color", "grayscale", "bw"

  // ── QR sidebar ───────────────────────────────────────────────────────────
  qr-renderer: none,             // url => content function, or none to disable
  qr-width: 1.85cm,              // width of the QR sidebar column
)
```
]

== Utility Functions

```typst
#beautiframe-reset()                // Reset all built-in counters
#beautiframe-reset-french-math()    // Reset built-in + French env counters
#reset-env("Label")                 // Reset a specific custom env counter

// French math presets
#preset-french-math()               // cours style, color, blue accent
#preset-french-math-bw()            // bw style, black-and-white

// Language presets
#preset-french()
#preset-german()
#preset-spanish()

// Color themes
#theme-ocean()
#theme-forest()
#theme-sunset()
#theme-lavender()

// QED presets
#qed-square()      // □
#qed-filled()      // ■
#qed-tombstone()   // ∎
#qed-cqfd()        // CQFD
#qed-slashes()     // //
#qed-text()        // Q.E.D.
#qed-none()        // (none)
```
