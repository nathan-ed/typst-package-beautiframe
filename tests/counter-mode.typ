#import "../src/lib.typ": *

// ============================================================================
// 1. Default independent counters
// ============================================================================
#beautiframe-reset-config()
#beautiframe-reset()

#theorem(label: <ind-thm1>)[T1]
#definition(label: <ind-def1>)[D1]
#lemma(label: <ind-lem1>)[L1]
#theorem(label: <ind-thm2>)[T2]

#context {
  let e1 = _env-ref-entry(<ind-thm1>)
  let e2 = _env-ref-entry(<ind-def1>)
  let e3 = _env-ref-entry(<ind-lem1>)
  let e4 = _env-ref-entry(<ind-thm2>)
  assert(e1.number == "1", message: "ind thm1")
  assert(e2.number == "1", message: "ind def1")
  assert(e3.number == "1", message: "ind lem1")
  assert(e4.number == "2", message: "ind thm2")
}

// ============================================================================
// 2. Shared counter via counter-mode: "shared"
// ============================================================================
#beautiframe-reset-config()
#beautiframe-reset()
#beautiframe-setup(counter-mode: "shared")

#theorem(label: <sh-thm1>)[T1]
#definition(label: <sh-def1>)[D2]
#lemma(label: <sh-lem1>)[L3]
#theorem(label: <sh-thm2>)[T4]

#context {
  let e1 = _env-ref-entry(<sh-thm1>)
  let e2 = _env-ref-entry(<sh-def1>)
  let e3 = _env-ref-entry(<sh-lem1>)
  let e4 = _env-ref-entry(<sh-thm2>)
  assert(e1.number == "1", message: "shared thm1")
  assert(e2.number == "2", message: "shared def1")
  assert(e3.number == "3", message: "shared lem1")
  assert(e4.number == "4", message: "shared thm2")
}

// ============================================================================
// 3. Shared counter via counter-shared: true toggle
// ============================================================================
#beautiframe-reset-config()
#beautiframe-reset()
#beautiframe-setup(counter-shared: true)

#theorem(label: <cs-thm1>)[T1]
#definition(label: <cs-def1>)[D2]

#context {
  let e1 = _env-ref-entry(<cs-thm1>)
  let e2 = _env-ref-entry(<cs-def1>)
  assert(e1.number == "1", message: "counter-shared thm1")
  assert(e2.number == "2", message: "counter-shared def1")
}

// ============================================================================
// 4. Single external counter passed directly to counter-mode
// ============================================================================
#beautiframe-reset-config()
#beautiframe-reset()
#let ext-single = counter("test-ext-single")
#beautiframe-setup(counter-mode: ext-single)

#theorem(label: <ext-thm1>)[T1]
#lemma(label: <ext-lem1>)[L2]
#definition(label: <ext-def1>)[D3]

#context {
  let e1 = _env-ref-entry(<ext-thm1>)
  let e2 = _env-ref-entry(<ext-lem1>)
  let e3 = _env-ref-entry(<ext-def1>)
  assert(e1.number == "1", message: "ext thm1")
  assert(e2.number == "2", message: "ext lem1")
  assert(e3.number == "3", message: "ext def1")
  assert(ext-single.get().first() == 3, message: "ext-single value")
}

// ============================================================================
// 5. Dictionary grouping: sharing lemma & proposition with theorem
// ============================================================================
#beautiframe-reset-config()
#beautiframe-reset()
#beautiframe-setup(counter-mode: (
  lemma: "theorem",
  proposition: "theorem",
  corollary: "theorem",
))

#theorem(label: <dict-thm1>)[T1]
#lemma(label: <dict-lem1>)[L2]
#definition(label: <dict-def1>)[D1 (independent)]
#proposition(label: <dict-prop1>)[P3]
#corollary(label: <dict-cor1>)[C4]
#theorem(label: <dict-thm2>)[T5]
#definition(label: <dict-def2>)[D2 (independent)]

#context {
  assert(_env-ref-entry(<dict-thm1>).number == "1", message: "dict thm1")
  assert(_env-ref-entry(<dict-lem1>).number == "2", message: "dict lem1")
  assert(_env-ref-entry(<dict-def1>).number == "1", message: "dict def1")
  assert(_env-ref-entry(<dict-prop1>).number == "3", message: "dict prop1")
  assert(_env-ref-entry(<dict-cor1>).number == "4", message: "dict cor1")
  assert(_env-ref-entry(<dict-thm2>).number == "5", message: "dict thm2")
  assert(_env-ref-entry(<dict-def2>).number == "2", message: "dict def2")
}

// ============================================================================
// 6. Dictionary with external counter instances & group strings
// ============================================================================
#beautiframe-reset-config()
#beautiframe-reset()
#let ext-results = counter("test-results")
#let ext-defs = counter("test-defs")
#beautiframe-setup(counter-mode: (
  theorem: ext-results,
  lemma: ext-results,
  definition: ext-defs,
  example: ext-defs,
))

#theorem(label: <extd-thm1>)[T1]
#lemma(label: <extd-lem1>)[L2]
#definition(label: <extd-def1>)[D1]
#example(label: <extd-ex1>)[E2]
#theorem(label: <extd-thm2>)[T3]

#context {
  assert(_env-ref-entry(<extd-thm1>).number == "1", message: "extd thm1")
  assert(_env-ref-entry(<extd-lem1>).number == "2", message: "extd lem1")
  assert(_env-ref-entry(<extd-def1>).number == "1", message: "extd def1")
  assert(_env-ref-entry(<extd-ex1>).number == "2", message: "extd ex1")
  assert(_env-ref-entry(<extd-thm2>).number == "3", message: "extd thm2")
}

// ============================================================================
// 7. Custom environments via new-env
// ============================================================================
#beautiframe-reset-config()
#beautiframe-reset()
#beautiframe-setup(counter-mode: "shared")
#let conjecture = new-env("Conjecture", base: "theorem")

#theorem(label: <custom-thm1>)[T1]
#conjecture(label: <custom-conj1>)[C2]
#definition(label: <custom-def1>)[D3]

#context {
  assert(_env-ref-entry(<custom-thm1>).number == "1", message: "custom thm1")
  assert(_env-ref-entry(<custom-conj1>).number == "2", message: "custom conj1")
  assert(_env-ref-entry(<custom-def1>).number == "3", message: "custom def1")
}

// Custom env with explicit counter override:
#beautiframe-reset-config()
#beautiframe-reset()
#let independent-axiom = new-env("Axiom", base: "theorem", counter: "independent")
#let shared-prop = new-env("Prop", base: "theorem", counter: "theorem")

#theorem(label: <exp-thm1>)[T1]
#independent-axiom(label: <exp-ax1>)[A1]
#shared-prop(label: <exp-prop1>)[P2]
#theorem(label: <exp-thm2>)[T3]
#independent-axiom(label: <exp-ax2>)[A2]

#context {
  assert(_env-ref-entry(<exp-thm1>).number == "1", message: "exp thm1")
  assert(_env-ref-entry(<exp-ax1>).number == "1", message: "exp ax1")
  assert(_env-ref-entry(<exp-prop1>).number == "2", message: "exp prop1")
  assert(_env-ref-entry(<exp-thm2>).number == "3", message: "exp thm2")
  assert(_env-ref-entry(<exp-ax2>).number == "2", message: "exp ax2")
}

// ============================================================================
// 8. Section-linked numbering and reset with shared counter
// ============================================================================
#beautiframe-reset-config()
#beautiframe-reset()
#set heading(numbering: "1.1.")
#beautiframe-setup(counter-mode: "shared", link-to-section: true, counter-reset: "section")

= First section
#theorem(label: <sec-thm1>)[T 1.1]
#definition(label: <sec-def1>)[D 1.2]

= Second section
#lemma(label: <sec-lem1>)[L 2.1]
#theorem(label: <sec-thm2>)[T 2.2]

#context {
  assert(_env-ref-entry(<sec-thm1>).number == "1.1", message: "sec thm1")
  assert(_env-ref-entry(<sec-def1>).number == "1.2", message: "sec def1")
  assert(_env-ref-entry(<sec-lem1>).number == "2.1", message: "sec lem1")
  assert(_env-ref-entry(<sec-thm2>).number == "2.2", message: "sec thm2")
}

// ============================================================================
// 9. Cross-references (env-ref and env-refs)
// ============================================================================
#beautiframe-reset-config()
#beautiframe-reset()
#beautiframe-setup(counter-mode: "shared")

#theorem(label: <ref-thm1>)[T1]
#definition(label: <ref-def1>)[D2]
#theorem(label: <ref-thm2>)[T3]

#context {
  let r1 = env-ref(<ref-thm1>, page: false)
  let r2 = env-ref(<ref-def1>, page: false)
  let refs = env-refs(<ref-thm1>, <ref-def1>, page: false)
  assert(r1 != none and r1 != [], message: "r1 exists")
  assert(r2 != none and r2 != [], message: "r2 exists")
  assert(refs != none and refs != [], message: "refs exists")
}

// ============================================================================
// 10. beautiframe-reset()
// ============================================================================
#beautiframe-reset-config()
#beautiframe-reset()
#beautiframe-setup(counter-mode: "shared")

#theorem[T1]
#definition[D2]
#beautiframe-reset()
#theorem(label: <reset-thm1>)[T1 after reset]

#context {
  assert(_env-ref-entry(<reset-thm1>).number == "1", message: "reset-thm1 is 1")
}
