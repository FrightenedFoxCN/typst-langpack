#let annot(annot: none, body) = context {
    if annot != none {[
        #metadata((body, annot)) <__annot>
    ]}
    underline(body)
}

#let place-annot(hide-annot) = context {
    box(width: 100%)[
        #for i in query(<__annot>) {
            text(weight: "bold", i.value.first())
            linebreak()
            if hide-annot {
                hide(i.value.last())
            } else {
                i.value.last()
            }
            linebreak()
            v(1pt)
        }
    ]
}

#let annotated(doc, show-annot: true, hide-annot: false) = grid(
    columns: (2fr, 1fr),
    column-gutter: 2em,
    doc,
    if show-annot {place-annot(hide-annot)}
)