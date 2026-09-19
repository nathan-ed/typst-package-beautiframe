#import "/src/lib.typ": *

#set page(width: 16cm, height: auto, margin: 1.5cm)
#set heading(numbering: "1.1")

// ─────────────────────────────────────────────────────────────────────────────
// Part 1: Continuous global subsection numbering (level: 2, global: true)
// ─────────────────────────────────────────────────────────────────────────────

#beautiframe-setup(
  link-to-section: (level: 2, global: true),
  counter-reset: "section",
)

= Section One
== Subsection One
#theorem(label: <t1-1>)[Theorem 1.1]
#theorem(label: <t1-2>)[Theorem 1.2]
#theorem(label: <t1-3>)[Theorem 1.3]

== Subsection Two
#theorem(label: <t2-1>)[Theorem 2.1]
#theorem(label: <t2-2>)[Theorem 2.2]

= Section Two
== Subsection Three
#theorem(label: <t3-1>)[Theorem 3.1]
#theorem(label: <t3-2>)[Theorem 3.2]

== Subsection Four
#theorem(label: <t4-1>)[Theorem 4.1]

// References
#env-ref(<t1-1>, page: false)
#env-ref(<t1-2>, page: false)
#env-ref(<t1-3>, page: false)
#env-ref(<t2-1>, page: false)
#env-ref(<t2-2>, page: false)
#env-ref(<t3-1>, page: false)
#env-ref(<t3-2>, page: false)
#env-ref(<t4-1>, page: false)

#context {
  let num(lbl) = {
    let l = query(link.where(dest: lbl)).first()
    l.body.children.first().children.last().text
  }
  assert.eq(num(<t1-1>), "1.1")
  assert.eq(num(<t1-2>), "1.2")
  assert.eq(num(<t1-3>), "1.3")
  assert.eq(num(<t2-1>), "2.1")
  assert.eq(num(<t2-2>), "2.2")
  assert.eq(num(<t3-1>), "3.1")
  assert.eq(num(<t3-2>), "3.2")
  assert.eq(num(<t4-1>), "4.1")
}

// ─────────────────────────────────────────────────────────────────────────────
// Part 2: Custom environments created via new-env
// ─────────────────────────────────────────────────────────────────────────────

#let exercice = new-env("Exercice", plural: "Exercices", base: "example")

== Subsection Five
#exercice(label: <ex5-1>)[Exercice 5.1]
#exercice(label: <ex5-2>)[Exercice 5.2]

#env-ref(<ex5-1>, page: false)
#env-ref(<ex5-2>, page: false)

#context {
  let num(lbl) = {
    let l = query(link.where(dest: lbl)).first()
    l.body.children.first().children.last().text
  }
  assert.eq(num(<ex5-1>), "5.1")
  assert.eq(num(<ex5-2>), "5.2")
}
