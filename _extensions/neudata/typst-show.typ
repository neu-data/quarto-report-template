#show: doc => neudata-report(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(by-author)$
  authors: (
$for(by-author)$
$if(it.name.literal)$
    ( name: [$it.name.literal$],
      affiliation: [$for(it.affiliations)$$it.name$$sep$, $endfor$] ),
$endif$
$endfor$
    ),
$endif$
$if(date)$
  date: [$date$],
$endif$
$if(client)$
  client: [$client$],
$endif$
$if(reference)$
  reference: [$reference$],
$endif$
$if(confidentiality)$
  confidentiality: "$confidentiality$",
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
$if(abstract)$
  abstract: [$abstract$],
  abstract-title: [$labels.abstract$],
$endif$
$if(mainfont)$
  font: ("$mainfont$",),
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$endif$
$if(section-numbering)$
  sectionnumbering: "$section-numbering$",
$endif$
$if(toc)$
  toc: $toc$,
$endif$
$if(toc-title)$
  toc_title: [$toc-title$],
$endif$
  toc_depth: $toc-depth$,
  doc,
)
