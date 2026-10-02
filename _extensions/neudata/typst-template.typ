// Neudata Consulting Ltd — Typst report template
// Palette sampled from the Neudata logo.

#let neudata-teal = rgb("#055F56")
#let neudata-navy = rgb("#04242F")
#let neudata-blue = rgb("#0B376C")
#let neudata-mist = rgb("#EAF2F5")
#let neudata-grey = rgb("#8A99A3")

// Key-findings box, used from Quarto via ::: {.key-findings}
#let key-findings(body) = block(
  width: 100%,
  fill: neudata-mist,
  stroke: (left: 4pt + neudata-teal),
  inset: (x: 12pt, y: 10pt),
  radius: (right: 4pt),
  body,
)

#let neudata-report(
  title: none,
  subtitle: none,
  authors: (),
  date: none,
  client: none,
  reference: none,
  confidentiality: none,
  abstract: none,
  abstract-title: none,
  lang: "en",
  region: "GB",
  font: ("Segoe UI", "Arial"),
  fontsize: 10.5pt,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: 3,
  doc,
) = {
  set document(title: title)
  set text(lang: lang, region: region, font: font, size: fontsize, fill: rgb("#1F2D33"))
  set par(justify: true, leading: 0.65em)
  set heading(numbering: sectionnumbering)
  show link: set text(fill: neudata-blue)

  show heading.where(level: 1): it => {
    v(1.2em)
    block(below: 0.8em)[
      #set text(size: 16pt, weight: "bold", fill: neudata-navy)
      #it
      #v(-0.5em)
      #line(length: 100%, stroke: 1.5pt + neudata-teal)
    ]
  }
  show heading.where(level: 2): set text(size: 13pt, weight: "bold", fill: neudata-blue)
  show heading.where(level: 3): set text(size: 11pt, weight: "bold", fill: neudata-teal)

  // Tables: navy header row, striped body
  set table(
    stroke: (x, y) => if y == 0 { none } else { (bottom: 0.5pt + neudata-grey.lighten(50%)) },
    fill: (x, y) => if y == 0 { neudata-navy } else if calc.even(y) { neudata-mist } else { none },
  )
  show table.cell.where(y: 0): set text(fill: white, weight: "bold")

  // ---------- Cover page ----------
  page(
    margin: 0pt,
    header: none,
    footer: none,
  )[
    #place(top + left, rect(width: 100%, height: 7pt, fill: neudata-teal))
    #pad(x: 2.2cm, top: 2cm)[
      #image("neudata-logo.png", width: 4.2cm)
    ]
    #place(
      left + horizon,
      dy: -1cm,
      block(width: 100%, fill: neudata-navy, inset: (x: 2.2cm, y: 1.6cm))[
        #set text(fill: white)
        #if title != none { text(size: 26pt, weight: "bold", title) }
        #if subtitle != none { v(0.4em); text(size: 14pt, fill: rgb("#9FD3CB"), subtitle) }
        #if client != none { v(1.2em); text(size: 11pt)[Prepared for: *#client*] }
      ],
    )
    #place(
      left + bottom,
      pad(x: 2.2cm, bottom: 2.4cm)[
        #set text(size: 10pt, fill: neudata-navy)
        #if authors.len() > 0 {
          for a in authors [
            *#a.name* #if a.at("affiliation", default: none) not in (none, []) [— #a.affiliation] \
          ]
        }
        #if date != none [#date \ ]
        #if reference != none [Reference: #reference \ ]
        #if confidentiality != none { v(0.6em); text(fill: neudata-teal, weight: "bold", upper(confidentiality)) }
        #v(1.2em)
        #text(size: 9pt, fill: neudata-grey)[Neudata Consulting Ltd · www.neu-data.com · contact\@neu-data.com]
      ],
    )
  ]

  // ---------- Body pages ----------
  set page(
    paper: "a4",
    margin: (x: 2.2cm, top: 2.6cm, bottom: 2.4cm),
    header: context {
      set text(size: 8pt, fill: neudata-navy)
      grid(
        columns: (1fr, auto),
        align: (left + horizon, right + horizon),
        if title != none { title },
        image("neudata-logo.png", height: 0.85cm),
      )
      v(-4pt)
      line(length: 100%, stroke: 0.75pt + neudata-teal)
    },
    footer: context {
      set text(size: 8pt, fill: neudata-grey)
      grid(
        columns: (1fr, auto),
        [Neudata Consulting Ltd · _Insight. Impact. Innovation._],
        counter(page).display("1 / 1", both: true),
      )
    },
  )
  counter(page).update(1)

  if abstract != none {
    block(fill: neudata-mist, inset: 12pt, radius: 4pt, width: 100%)[
      #text(weight: "bold", fill: neudata-navy)[#if abstract-title != none { abstract-title } else [Summary]]
      #v(0.3em)
      #abstract
    ]
  }

  if toc {
    let title = if toc_title == none { [Contents] } else { toc_title }
    block(above: 1em, below: 2em)[
      #outline(title: title, depth: toc_depth, indent: auto)
    ]
    pagebreak()
  }

  doc
}
