<div align="center">

<img src="https://raw.githubusercontent.com/neu-data/.github/main/assets/banner.svg" alt="Neudata Consulting Ltd" width="100%" />

# Neudata Quarto report template

**Branded client reports in HTML, PDF and Word — from one Quarto document.**

![Quarto](https://img.shields.io/badge/Quarto-%E2%89%A51.4-055F56?style=flat&logo=quarto&logoColor=white)
![Formats](https://img.shields.io/badge/formats-HTML%20%C2%B7%20PDF%20%C2%B7%20Word-0B376C?style=flat)
![Neudata](https://img.shields.io/badge/Neudata-brand-04242F?style=flat)

</div>

---

## What you get

| Format | Output | Highlights |
|---|---|---|
| `neudata-html` | Self-contained web report | Brand strip, navy→teal title banner, client and reference in the title block, sidebar contents, Neudata footer |
| `neudata-typst` | PDF (no LaTeX needed) | Cover page with navy band, logo header, numbered sections with teal rules, striped navy-header tables |
| `neudata-docx` | Word document | Neudata heading colours and fonts, logo in header, branded footer, *Key Findings* style |

See the rendered samples in [`examples/`](examples/).

## Start a new report

```bash
quarto use template neu-data/quarto-report-template
```

This creates a folder with `template.qmd` renamed to your folder name and the extension in `_extensions/neudata/`.

To add the formats to an **existing** project instead:

```bash
quarto add neu-data/quarto-report-template
```

## Render

```bash
quarto render report.qmd                    # all three formats
quarto render report.qmd --to neudata-typst # PDF only
```

## Report metadata

```yaml
---
title: "Report title"
subtitle: "Short descriptive subtitle"
author:
  - name: Analyst Name
    affiliations:
      - name: Neudata Consulting Ltd
date: today
client: "Client organisation"       # shown on cover / title block
reference: "NDC-2026-000"           # contract or project reference
confidentiality: "Confidential"     # optional classification
abstract: |
  Executive summary…
format:
  neudata-html: default
  neudata-typst: default
  neudata-docx: default
---
```

## Brand elements

**Key-findings box** — works in all three formats:

```markdown
::: {.key-findings}
**Key findings**

- Finding one.
- Finding two.
:::
```

**Figure palette** (already set up in the template's `setup` chunk):

| Teal | Blue | Navy | Light teal | Light blue | Grey |
|---|---|---|---|---|---|
| `#055F56` | `#0B376C` | `#04242F` | `#5FA39B` | `#6C8DB8` | `#8A99A3` |

Code is hidden by default (`echo: false`). Set `echo: true` on a chunk to show it.

## Requirements

- [Quarto](https://quarto.org) 1.4 or later (Typst PDF output is built in)
- R with `ggplot2` and `knitr` for the example code chunks

---

<div align="center">

**Neudata Consulting Ltd** · *Insight. Impact. Innovation.*
[www.neu-data.com](https://www.neu-data.com) · [contact@neu-data.com](mailto:contact@neu-data.com)

</div>
