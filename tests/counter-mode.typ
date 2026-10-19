// counter-mode: shared, external and grouped counters. Compiling this file is
// the test: every check is an assert on the number an environment shows,
// read back through the env-ref machinery.
#import "../src/lib.typ": *

#let num(lbl) = _env-ref-entry(lbl).number
#let check(lbl, expected) = context {
  let got = num(lbl)
  assert(got == expected, message: repr(lbl) + ": expected " + repr(expected) + ", got " + repr(got))
}
#let fresh() = { beautiframe-reset-config(); beautiframe-reset() }

// 1. Default: one counter per type.
#fresh()
#theorem(label: <ind-thm1>)[]
#definition(label: <ind-def1>)[]
#lemma(label: <ind-lem1>)[]
#theorem(label: <ind-thm2>)[]
#check(<ind-thm1>, "1")
#check(<ind-def1>, "1")
#check(<ind-lem1>, "1")
#check(<ind-thm2>, "2")

// 2. "shared": a single counter for every numbered type. A proof has no
// counter of its own and stays unnumbered: it must not consume a number.
#fresh()
#beautiframe-setup(counter-mode: "shared")
#theorem(label: <sh-thm1>)[]
#proof[]
#definition(label: <sh-def1>)[]
#lemma(label: <sh-lem1>)[]
#theorem(label: <sh-thm2>)[]
#check(<sh-thm1>, "1")
#check(<sh-def1>, "2")
#check(<sh-lem1>, "3")
#check(<sh-thm2>, "4")

// 3. counter-shared: true / false and counter-mode: true are shorthands.
#fresh()
#beautiframe-setup(counter-shared: true)
#theorem(label: <cs-thm1>)[]
#definition(label: <cs-def1>)[]
#check(<cs-thm1>, "1")
#check(<cs-def1>, "2")
#beautiframe-setup(counter-shared: false)
#definition(label: <cs-def2>)[]
#check(<cs-def2>, "1")
#fresh()
#beautiframe-setup(counter-mode: true)
#theorem[]
#lemma(label: <cm-lem>)[]
#check(<cm-lem>, "2")

// 4. An external counter numbers every type, and is left at the count.
#fresh()
#let ext-single = counter("test-ext-single")
#beautiframe-setup(counter-mode: ext-single)
#theorem(label: <ext-thm1>)[]
#lemma(label: <ext-lem1>)[]
#definition(label: <ext-def1>)[]
#check(<ext-thm1>, "1")
#check(<ext-lem1>, "2")
#check(<ext-def1>, "3")
#context assert.eq(ext-single.get().first(), 3)

// 5. Dictionary: lemma, proposition and corollary count with theorem;
// definition keeps its own counter.
#fresh()
#beautiframe-setup(counter-mode: (lemma: "theorem", proposition: "theorem", corollary: "theorem"))
#theorem(label: <d-thm1>)[]
#lemma(label: <d-lem1>)[]
#definition(label: <d-def1>)[]
#proposition(label: <d-prop1>)[]
#corollary(label: <d-cor1>)[]
#theorem(label: <d-thm2>)[]
#definition(label: <d-def2>)[]
#check(<d-thm1>, "1")
#check(<d-lem1>, "2")
#check(<d-def1>, "1")
#check(<d-prop1>, "3")
#check(<d-cor1>, "4")
#check(<d-thm2>, "5")
#check(<d-def2>, "2")

// 6. Dictionary with external counters and group names, plus `default`.
#fresh()
#let ext-results = counter("test-results")
#beautiframe-setup(counter-mode: (
  theorem: ext-results, lemma: ext-results,
  definition: "defs", example: "defs",
  default: "shared",
))
#theorem(label: <g-thm1>)[]
#lemma(label: <g-lem1>)[]
#definition(label: <g-def1>)[]
#example(label: <g-ex1>)[]
#proposition(label: <g-prop1>)[]
#corollary(label: <g-cor1>)[]
#theorem(label: <g-thm2>)[]
#check(<g-thm1>, "1")
#check(<g-lem1>, "2")
#check(<g-def1>, "1")
#check(<g-ex1>, "2")
#check(<g-prop1>, "1")
#check(<g-cor1>, "2")
#check(<g-thm2>, "3")

// 7. Function: receives the environment name, returns a target.
#fresh()
#beautiframe-setup(counter-mode: name => if name in ("definition", "example") { "independent" } else { "shared" })
#theorem(label: <f-thm1>)[]
#definition(label: <f-def1>)[]
#lemma(label: <f-lem1>)[]
#example(label: <f-ex1>)[]
#check(<f-thm1>, "1")
#check(<f-def1>, "1")
#check(<f-lem1>, "2")
#check(<f-ex1>, "1")

// 8. new-env: follows "shared", is found in a dictionary by key or label
// (case-insensitively), and `counter:` overrides counter-mode.
#fresh()
#beautiframe-setup(counter-mode: "shared")
#let conjecture = new-env("Conjecture", base: "theorem")
#theorem(label: <c-thm1>)[]
#conjecture(label: <c-conj1>)[]
#definition(label: <c-def1>)[]
#check(<c-thm1>, "1")
#check(<c-conj1>, "2")
#check(<c-def1>, "3")

#fresh()
#let axiom = new-env("Axiom", base: "theorem", counter: "independent")
#let prop = new-env("Prop", base: "theorem", counter: "theorem")
#beautiframe-setup(counter-mode: "shared")
#theorem(label: <o-thm1>)[]
#axiom(label: <o-ax1>)[]
#prop(label: <o-prop1>)[]
#lemma(label: <o-lem1>)[]
#axiom(label: <o-ax2>)[]
#check(<o-thm1>, "1")
#check(<o-ax1>, "1")
// "theorem" is theorem's own counter, which "shared" no longer advances.
#check(<o-prop1>, "1")
#check(<o-lem1>, "2")
#check(<o-ax2>, "2")

#fresh()
#let hypothesis = new-env("Hypothèse", base: "lemma", key: "hypothese")
#beautiframe-setup(counter-mode: (hypothese: "theorem", conjecture: "theorem"))
#theorem(label: <k-thm1>)[]
#hypothesis(label: <k-hyp1>)[]
#conjecture(label: <k-conj1>)[]
#check(<k-thm1>, "1")
#check(<k-hyp1>, "2")
#check(<k-conj1>, "3")

// 9. counter-key numbers on its own counter, whatever counter-mode says
// (regression: `counter` used to be shadowed by a parameter).
#fresh()
#env(type: "theorem", counter-key: "my-counter", label: <ck-1>)[Hello]
#beautiframe-setup(counter-mode: "shared")
#theorem(label: <ck-thm>)[]
#env(type: "theorem", counter-key: "my-counter", label: <ck-2>)[Hello]
#check(<ck-1>, "1")
#check(<ck-thm>, "1")
#check(<ck-2>, "2")

// 10. reset-env restarts the counter the environment actually uses.
#fresh()
#let note = new-env("Note", base: "remark")
#note(label: <r-note1>)[]
#reset-env("Note")
#note(label: <r-note2>)[]
#check(<r-note1>, "1")
#check(<r-note2>, "1")

#fresh()
#beautiframe-setup(counter-mode: (Note: "results", theorem: "results"))
#theorem(label: <rs-thm1>)[]
#note(label: <rs-note1>)[]
#reset-env("Note")
#theorem(label: <rs-thm2>)[]
#check(<rs-thm1>, "1")
#check(<rs-note1>, "2")
#check(<rs-thm2>, "1")

#fresh()
#reset-env("Prop", counter: "theorem")
#theorem[]
#prop(label: <ro-prop>)[]
#reset-env("Prop", counter: "theorem")
#theorem(label: <ro-thm>)[]
#check(<ro-prop>, "2")
#check(<ro-thm>, "1")

// 11. beautiframe-reset: built-in, shared, the counters counter-mode names,
// and extra counters or group names.
#fresh()
#let ext-a = counter("test-reset-a")
#let ext-b = counter("test-reset-b")
#beautiframe-setup(counter-mode: (theorem: ext-a, lemma: "lemmas", definition: "shared"))
#theorem[]
#lemma[]
#definition[]
#ext-b.step()
#counter("beautiframe-group-extra").step()
#beautiframe-reset(ext-b, "extra")
#theorem(label: <z-thm>)[]
#lemma(label: <z-lem>)[]
#definition(label: <z-def>)[]
#check(<z-thm>, "1")
#check(<z-lem>, "1")
#check(<z-def>, "1")
#context assert.eq(ext-b.get().first(), 0)
#context assert.eq(counter("beautiframe-group-extra").get().first(), 0)

// 12. Cross-references show the shared numbers.
#fresh()
#beautiframe-setup(counter-mode: "shared")
#theorem(label: <ref-thm1>)[]
#definition(label: <ref-def1>)[]
#context {
  let e = _env-ref-entry(<ref-def1>)
  assert.eq((e.label, e.number), ("Definition", "2"))
  assert(env-ref(<ref-def1>, page: false) != none)
  assert(env-refs(<ref-thm1>, <ref-def1>, page: false) != none)
}

// 13. Section-linked numbering and section reset on a shared counter.
#fresh()
#set heading(numbering: "1.1.")
#beautiframe-setup(counter-mode: "shared", link-to-section: true, counter-reset: "section")

= First section
#theorem(label: <s-thm1>)[]
#definition(label: <s-def1>)[]

= Second section
#lemma(label: <s-lem1>)[]
#conjecture(label: <s-conj1>)[]
#check(<s-thm1>, "1.1")
#check(<s-def1>, "1.2")
#check(<s-lem1>, "2.1")
#check(<s-conj1>, "2.2")
