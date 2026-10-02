-- Neudata filters
--  * ::: {.key-findings} divs become a branded box in every output format
--    (HTML is styled by neudata.scss; Typst and Word are handled here).
--  * In HTML, client / reference / confidentiality metadata are emitted so
--    header.html can place them in the title block.
--  * A closing copyright page (centred logo, notice in monospace) is added to
--    every format. Turn it off with `copyright-page: false`.

local function meta_text(meta, key)
  local v = meta[key]
  if v == nil then return nil end
  return pandoc.utils.stringify(v)
end

local COPYRIGHT_PARAS = {
  "All property rights and copyright are reserved.",
  "This document contains proprietary data, information, and materials developed by Neudata for " ..
    "dedicated use only and may not be communicated, copied, reproduced, distributed, published, or " ..
    "cited, in whole or in part, without the prior written consent of Neudata. Where explicit written " ..
    "permission has been granted, appropriate attribution must be included, followed by " ..
    "\u{201C}by courtesy of Neudata\u{201D}.",
  "Any unauthorized use or infringement of these materials may give rise to legal action and claims " ..
    "for damages, without prejudice to any other rights of Neudata, including rights relating to " ..
    "patents, trademarks, or other forms of intellectual property protection.",
}

local function copyright_title()
  return "Copyright \u{00A9} Neudata, " .. os.date("%Y")
end

local function html_escape(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function typst_escape(s)
  return (s:gsub("([#%$%*_@<>%[%]\\`])", "\\%1"))
end

local function copyright_blocks()
  if quarto.doc.is_format("typst") then
    local paras = {}
    for _, p in ipairs(COPYRIGHT_PARAS) do table.insert(paras, typst_escape(p)) end
    return pandoc.List({ pandoc.RawBlock("typst", table.concat({
      "#pagebreak()",
      "#v(1fr)",
      '#align(center, image("neudata-logo.png", height: 4.2cm))',
      "#v(1.5em)",
      "#block[",
      '  #text(size: 13pt, weight: "bold", fill: neudata-navy)[' .. typst_escape(copyright_title()) .. "]",
      "  #v(0.4em)",
      '  #set text(font: ("Consolas", "DejaVu Sans Mono"), size: 8.5pt)',
      "  #set par(justify: false, leading: 0.55em)",
      "  " .. table.concat(paras, "\n\n  "),
      "]",
      "#v(1fr)",
    }, "\n")) })
  end

  if quarto.doc.is_format("html") then
    local paras = {}
    for _, p in ipairs(COPYRIGHT_PARAS) do table.insert(paras, "<p>" .. html_escape(p) .. "</p>") end
    return pandoc.List({ pandoc.RawBlock("html",
      '<section class="neudata-copyright">' ..
      '<img src="neudata-logo.png" alt="Neudata Consulting Ltd">' ..
      '<p class="neudata-copyright-title">' .. html_escape(copyright_title()) .. '</p>' ..
      '<div class="neudata-copyright-text">' .. table.concat(paras) .. '</div>' ..
      '</section>') })
  end

  if quarto.doc.is_format("docx") then
    local blocks = pandoc.List({
      pandoc.RawBlock("openxml", '<w:p><w:r><w:br w:type="page"/></w:r></w:p>'),
      pandoc.Div({ pandoc.Para({ pandoc.Image({}, "neudata-logo.png", "", { height = "4.2cm" }) }) },
        pandoc.Attr("", {}, { { "custom-style", "Copyright Logo" } })),
      pandoc.Div({ pandoc.Para({ pandoc.Str(copyright_title()) }) },
        pandoc.Attr("", {}, { { "custom-style", "Copyright Heading" } })),
    })
    local text = {}
    for _, p in ipairs(COPYRIGHT_PARAS) do table.insert(text, pandoc.Para({ pandoc.Str(p) })) end
    blocks:insert(pandoc.Div(text, pandoc.Attr("", {}, { { "custom-style", "Copyright Text" } })))
    return blocks
  end

  return pandoc.List({})
end

function Div(el)
  if not el.classes:includes("key-findings") then
    return nil
  end

  if quarto.doc.is_format("typst") then
    local blocks = pandoc.List({ pandoc.RawBlock("typst", "#key-findings[") })
    blocks:extend(el.content)
    blocks:insert(pandoc.RawBlock("typst", "]"))
    return blocks
  end

  if quarto.doc.is_format("docx") then
    el.attributes["custom-style"] = "Key Findings"
    return el
  end

  return nil
end

function Pandoc(doc)
  -- Closing copyright page, unless switched off
  local cp = doc.meta["copyright-page"]
  local off = (cp == false) or (cp ~= nil and pandoc.utils.stringify(cp) == "false")
  if not off then
    doc.blocks:extend(copyright_blocks())
  end

  if not quarto.doc.is_format("html") then
    return doc
  end

  local fields = {
    { "client", "Client" },
    { "reference", "Reference" },
    { "confidentiality", "Classification" },
  }
  local html = {}
  for _, f in ipairs(fields) do
    local value = meta_text(doc.meta, f[1])
    if value then
      table.insert(html, string.format(
        '<div><div class="quarto-title-meta-heading">%s</div>' ..
        '<div class="quarto-title-meta-contents"><p>%s</p></div></div>',
        f[2], value))
    end
  end

  if #html > 0 then
    doc.blocks:insert(1, pandoc.RawBlock("html",
      '<div class="neudata-project-meta" hidden>' .. table.concat(html) .. '</div>'))
  end
  return doc
end
