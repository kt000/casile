local book = SILE.require("classes/book")
local plain = SILE.require("classes/plain")
local cabook = book { id = "cabook" }

cabook:declareOption("crop", "true")
cabook:declareOption("background", "true")
cabook:declareOption("verseindex", "false")

if cabook.options.verseindex() == "true" then
  cabook:loadPackage("verseindex", CASILE.casiledir)
else
  SILE.registerCommand("markverse", function (options, content) end)
end

cabook.endPage = function (self)
  cabook:moveTocNodes()
  if cabook.options.verseindex() == "true" then cabook:moveTovNodes() end

  if not SILE.scratch.headers.skipthispage then
    SILE.settings.pushState()
    SILE.settings.reset()
    if cabook:oddPage() then
      SILE.call("output-right-running-head")
    else
      SILE.call("output-left-running-head")
    end
    SILE.settings.popState()
  end
  SILE.scratch.headers.skipthispage = false

  return plain.endPage(cabook)
end

cabook.finish = function (self)
  if cabook.options.verseindex() == "true" then
    cabook:writeTov()
    SILE.call("tableofverses")
  end
  local ret = book:finish()
  return ret
end

-- CaSILE books sometimes have sections, sometimes don't.
-- Initialize some sectioning levels to work either way
SILE.scratch.counters["sectioning"] = {
  value =  { 0, 0 },
  display = { "ORDINAL", "STRING" }
}

-- I can't figure out how or where, but book.endPage() gets run on the last page
book.endPage = cabook.endPage

return cabook
