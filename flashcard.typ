#let parse_front(res_front, title-line, title) = align(horizon + center, [
  #strong(res_front.at(0))
])

#let format_back_with_title(pair) = {
  (strong(pair.at(0)), emph(pair.at(1)))
}

#let parse_back(res_back, title-line, title) = align(horizon + center, [
  #if title {
    box(width: 80%, grid(
      columns: (auto, auto),
      row-gutter: 14pt,
      align: (left, center),
      ..title-line.zip(res_back).map(format_back_with_title).flatten()
    ))
  } else {
    for i in res_back {
      emph(if title {i.at(1)} else {i})
      linebreak()
    }
  }
])

#let split_row(row, front, title-line, front-title, back-title) = (
  parse_front(
    row.slice(0, front), 
    title-line.slice(0, front), 
    front-title
  ), 
  parse_back(
    row.slice(front), 
    title-line.slice(front),
    back-title
  )
)

#let styling = rect.with(
  width: 100%,
  height: 100%
)

#let flashcard(
  source,
  front: 1,
  front-title: false,
  back-title: true
) = {
  let data = csv(source)
  let title-line = data.at(0)
  set page(
    margin: (x: 16pt, y: 32pt)
  )
  _ = data.remove(0)
  data = data.chunks(4)
  for i in data {
    grid(
      columns: (1fr, 1fr),
      rows: (1fr, 1fr, 1fr, 1fr),
      column-gutter: 16pt,
      row-gutter: 40pt,

      ..i.map(row => split_row(row, front, title-line, front-title, back-title)).flatten().map(styling)
    )
  }
}