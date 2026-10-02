-- Neudata filters
--  * ::: {.key-findings} divs become a branded box in every output format
--    (HTML is styled by neudata.scss; Typst and Word are handled here).
--  * In HTML, client / reference / confidentiality metadata are emitted so
--    header.html can place them in the title block.

local function meta_text(meta, key)
  local v = meta[key]
  if v == nil then return nil end
  return pandoc.utils.stringify(v)
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
