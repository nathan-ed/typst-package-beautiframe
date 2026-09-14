// instructor-only-envs — envs hidden by default, per-env override, numbering.
// Compile with
//   typst compile tests/instructor-envs.typ --root . --input mode=student
//   typst compile tests/instructor-envs.typ --root . --input mode=instructor
// The assertions below fail the compilation when the gating is wrong.
#import "/src/lib.typ": *

#let instructor = sys.inputs.at("mode", default: "student") == "instructor"

#set page(width: 16cm, height: auto, margin: 1.6cm)
#set text(size: 10pt, lang: "fr")

#preset-french()
#beautiframe-setup(
  instructor-mode: instructor,
  instructor-only-envs: ("methode", "worked-exercise", "defi", "notation"),
)

#let methode-counter = counter("beautiframe-custom-Méthode")
#let pratique-counter = counter("beautiframe-custom-En pratique")
#let refs() = query(metadata).filter(m => type(m.value) == dictionary and m.value.at("kind", default: none) == "beautiframe-ref")

// Shown in both builds: "theorem" is not in the list.
#theorem(title: "Toujours visible")[Énoncé.]

// Hidden in the student build: "methode" is listed.
#methode(title: "Masquée A")[Contenu.]

// Forced back in by the per-env key, even though "methode" is listed.
#methode(instructor: false, title: "Rétablie")[Contenu.]

#methode(title: "Masquée B")[Contenu.]

// `instructor: true` still hides, whatever the list says.
#theorem(instructor: true, title: "Réservée")[Énoncé.]

#worked-exercise(title: "Exercice résolu", correction: [La correction.])[Énoncé.]

#defi[Un défi.]

#notation[Une notation.]

// A listed env forced visible keeps its label reachable.
#methode(instructor: false, title: "Étiquetée", label: <m-visible>)[Contenu.]
// A hidden env leaves no reference target behind.
#methode(title: "Étiquetée masquée", label: <m-hidden>)[Contenu.]

Renvoi : #env-ref(<m-visible>, page: false).

#context {
  // Three #methode calls reach the page in the instructor build, one in the
  // student build — and that one is numbered 1, without a gap.
  assert.eq(
    methode-counter.get().first(),
    if instructor { 5 } else { 2 },
    message: "compteur methode inattendu",
  )
  // theorem: the plain one always counts, the instructor-only one only when shown.
  assert.eq(
    theorem-counter.get().first(),
    if instructor { 2 } else { 1 },
    message: "compteur theorem inattendu",
  )
  // worked-exercise borrows the `pratique` counter.
  assert.eq(
    pratique-counter.get().first(),
    if instructor { 1 } else { 0 },
    message: "compteur worked-exercise inattendu",
  )
  // Reference markers: <m-visible> always, <m-hidden> only in the instructor build.
  assert.eq(
    refs().len(),
    if instructor { 2 } else { 1 },
    message: "marqueurs de référence inattendus",
  )
  // The exported helper agrees with the list.
  assert(not env-visible("methode") or instructor, message: "env-visible: methode devrait être masquée")
  assert(env-visible("methode", instructor: false), message: "env-visible: override ignoré")
  assert(env-visible("theorem"), message: "env-visible: theorem devrait être visible")
  assert(env-visible("defi", instructor: true) == instructor, message: "env-visible: instructor: true ignoré")
}
