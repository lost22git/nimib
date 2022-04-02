import std/[os, strutils, sugar]
import nimib / [types, blocks, docs, boost, config, options, capture]
export types, blocks, docs, boost, sugar
# types exports mustache, tables, paths

from nimib / themes import nil
export themes.useLatex, themes.darkMode, themes.`title=`

from nimib / renders import nil

from mustachepkg/values import searchTable, searchDirs, castStr
export searchTable, searchDirs, castStr

template nbInit*(theme = themes.useDefault, backend = renders.useHtmlBackend, thisFileRel = "") =
  var nb {.inject.}: NbDoc

  nb.initDir = getCurrentDir().AbsoluteDir
  loadOptions nb
  loadCfg nb

  # nbInit can be called not from inside the correct file (e.g. when rendering markdown files in nimibook)
  if thisFileRel == "":
    nb.thisFile = instantiationInfo(-1, true).filename.AbsoluteFile
  else:
    nb.thisFile = nb.srcDir / thisFileRel.RelativeFile
    echo "[nimib] thisFile: ", nb.thisFile

  try:
    nb.source = read(nb.thisFile)
  except IOError:
    echo "[nimib] cannot read source"

  if nb.options.filename == "":
    nb.filename = nb.thisFile.string.splitFile.name & ".html"
  else:
    nb.filename = nb.options.filename

  if nb.cfg.srcDir != "":
    echo "[nimib] srcDir: ", nb.srcDir
    nb.filename = (nb.thisDir.relativeTo nb.srcDir).string / nb.filename
    echo "[nimib] filename: ", nb.filename

  if nb.cfg.homeDir != "":
    echo "[nimib] setting current directory to nb.homeDir: ", nb.homeDir
    setCurrentDir nb.homeDir

  # can be overriden by theme, but it is better to initialize this anyway
  nb.templateDirs = @["./", "./templates/"]
  nb.partials = initTable[string, string]()
  nb.context = newContext(searchDirs = @[]) # templateDirs and partials added during nbSave

  # apply render backend (default backend can be overriden by theme)
  backend nb

  # apply theme
  theme nb

# block generation templates
template newNbCodeBlock*(cmd: string, body, blockImpl: untyped) =
  newNbBlock(cmd, true, nb, nb.blk, body, blockImpl)

template newNbSlimBlock*(cmd: string, blockImpl: untyped) =
  # a slim block is a block with no body
  newNbBlock(cmd, false, nb, nb.blk, "", blockImpl)

# block templates
template nbCode*(body: untyped) =
  newNbCodeBlock("nbCode", body):
    captureStdout(nb.blk.output):
      body

template nbCodeInBlock*(body: untyped): untyped =
  block:
    nbCode:
      body

template nbText*(text: string) =
  newNbSlimBlock("nbText"):
    nb.blk.output = text

template nbTextWithCode*(body: untyped) =
  newNbCodeBlock("nbText", body):
    nb.blk.output = body

template nbImage*(url: string, caption = "") =
  newNbSlimBlock("nbImage"):
    nb.blk.context["url"] =
      if isAbsolute(url) or url[0..3] == "http":
        url
      else:
        nb.context["path_to_root"].vString / url
    nb.blk.context["caption"] = caption

template nbFile*(name: string, content: string) =
  ## Generic string file
  newNbSlimBlock("nbFile"):
    name.writeFile content
    nb.blk.context["filename"] = name
    nb.blk.context["ext"] = name.getExt
    nb.blk.context["content"] = content

template nbFile*(name: string, body: untyped) =
  newNbCodeBlock("nbFile", body):
    name.writeFile nb.blk.code
    nb.blk.context["filename"] = name
    nb.blk.context["ext"] = name.getExt
    nb.blk.context["content"] = nb.blk.code

template nbRawOutput*(content: string) =
  newNbSlimBlock("nbRawOutput"):
    nb.blk.output = content

template nbClearOutput*() =
  if not nb.blk.isNil:
    nb.blk.output = ""
    nb.blk.context["output"] = ""

template nbSave* =
  # order if searchDirs/searchTable is relevant: directories have higher priority. rationale:
  #   - in memory partial contains default mustache assets
  #   - to override/customize (for a bunch of documents) the best way is to modify a version on file
  #   - in case you need to manage additional exceptions for a specific document add a new set of partials before calling nbSave
  nb.context.searchDirs(nb.templateDirs)
  nb.context.searchTable(nb.partials)

  write nb
  if nb.options.show:
    open nb

# how to change this to a better version using nb?
template relPath*(path: AbsoluteFile | AbsoluteDir): string =
  (path.relativeTo nb.homeDir).string

# aliases to minimize breaking changes after refactoring nbDoc -> nb. Should be deprecated at some point?
template nbDoc*: NbDoc = nb
template nbBlock*: NbBlock = nb.blk
template nbHomeDir*: AbsoluteDir = nb.homeDir

# use --nbShow runtime option instead of this
template nbShow* =
  nbSave
  open nb
