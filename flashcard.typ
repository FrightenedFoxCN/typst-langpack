#let parse_front(res_front, title-line, title) = align(horizon + center, [
  #strong(res_front.at(0))
])

#let format_back_with_title(pair) = {
  if pair.at(1) != "" {
    (strong(pair.at(0)), emph(pair.at(1)))
  }
}

#let parse_back(res_back, title-line, title) = align(horizon + center, [
  #if title {
    box(width: 90%, grid(
      columns: (auto, auto),
      row-gutter: 14pt,
      column-gutter: 12pt,
      align: (right, left),
      ..title-line.zip(res_back).map(format_back_with_title).flatten()
    ))
  } else {
    for i in res_back {
      if i != "" {
        emph(if title {i.at(1)} else {i})
        linebreak()
      }
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
  data = data.chunks(4).chunks(2)

  for pairs in data {
    let left = pairs.at(0)
    let right = if pairs.len() > 1 {pairs.at(1)} else {()}

    left = left + (("", ) * title-line.len(), ) * (4 - left.len())
    right = right + (("", ) * title-line.len(), ) * (4 - right.len())

    let left-front = left.map(i => split_row(i, front, title-line, front-title, back-title).at(0))
    let left-back = left.map(i => split_row(i, front, title-line, front-title, back-title).at(1))

    let right-front = right.map(i => split_row(i, front, title-line, front-title, back-title).at(0))
    let right-back = right.map(i => split_row(i, front, title-line, front-title, back-title).at(1))

    grid(
      columns: (1fr, 1fr),
      rows: (1fr, 1fr, 1fr, 1fr),
      column-gutter: 16pt,
      row-gutter: 40pt,

      ..(left-front.zip(right-front)).flatten().map(styling)
    )

    grid(
      columns: (1fr, 1fr),
      rows: (1fr, 1fr, 1fr, 1fr),
      column-gutter: 16pt,
      row-gutter: 40pt,

      ..(left-back.zip(right-back)).flatten().map(styling)
    )
  }
}