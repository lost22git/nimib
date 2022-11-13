
# Changelog

The changelog includes a bit of the early history of nimib, pointers to relevant
examples of usage of nimib and heartfelt thanks to some of the fine folks that
made this development possible.

When contributing a fix, feature or example please add a new line to briefly explain the changes. It will be used as release documentation here: https://github.com/pietroppeter/nimib/releases

## 0.3.x
* _add next change here_

## 0.3.3

* Refactored nbJs (#148)
  * **Breaking**: All `nbJsFromCode` blocks are now inserted into the same file (Compared to previously when each block was compiled as its own file).
  So this will break any reusable components as you will get `redefinition of variable` errors. The solution is to use `nbJsFromCodeInBlock` which puts the code inside a `block`. Imports can't be done in there though so you must do them in a separate `nbJsFromCode` or `nbJsFromCodeGlobal` before. 
  * See [https://pietroppeter.github.io/nimib/interactivity.html](https://pietroppeter.github.io/nimib/interactivity.html) for a more detailed guide on how to use the new API.
* Added `nimibCode` template. One problem with using `nbCode` is that you can't show *nimib* code using it because it nests blocks and wrecks havoc.
So `nimibCode` allows you to show *nimib* code but at the cost of not capturing output of the code.

## 0.3.2

* Add `hlHtml` and `hlHtml` to nimiBoost
* fix rarely occuring issue of terminal output not being captured (windows only, see example in https://github.com/pietroppeter/nimib/pull/132)
* compress line height in nbCode output (using class `nb-output`), see #133
* Fixed a case when capturing a global in `nbJsFromCode` didn't gensym the symbols, causing the same variable names in the generated code. #136

## 0.3.1

* fix "Did not parse stylesheet at 'https://unpkg.com/normalize.css/' in strict mode" (#120)
* Split untyped and string versions of `nbCodeToJs` into `nbJsFromCode` and `nbJsFromString`. Same for `nbCodeToJsInit` → `nbJsFromCodeInit`, `nbJsFromStringInit` (#125)
* Add `postRender` template to `nbKaraxCode` (#125)
* `nbJsFromCode` now respects `exportc` pragma (#125)
* rename `rawOutput` (deprecated) to `rawHtml`

## 0.3 "Block Maker" (July 2022)

This release started with the aim of making the construction of custom blocks as easy as the construction of native blocks.
A wide refactoring of the codebase was required for this (#78)
and further adjustments were made along the way (#80, #81).
Some new blocks are introduced taking advantage of this (e.g. `nbRawOutput`, `nbPython`) (#80, #83).

Contributing to the codebase is made easier through introduction of proper testing (#80)
docs are now built in CI (#89, #90, #91) and deploy previews have been added (#92, #93).
Documentation has been updated to include all changes so far
and contextually the changelog has been updated (#103).

A big milestone is reached (#88) by introducing templates to add interactivity to documents
taking advantage of nim js backend (`nbCodeToJs` allows to incorporate javascript scripts in the document derived from nim code).
In particular templates to reduce boilerplate when developing karax based apps or
widgets are introduced (`nbKaraxCode`, `karaxHtml`).
Three new example documents are introduced for documenting this change (`interactivity`, `counters`, `caesar`).

Another major change is setting as default the `CodeAsInSource` introduced in 0.2.4
(a number of fixes are made: #105, #106, #108).

Most of these contributions are due to @HugoGranstrom
(thanks for all the awesome work on this ❤️) which joins @pietroppeter
as maintainer and co-creator of nimib! 🥳

List of detailed changes:

* refactoring of `NbBlock` type and rendering of blocks (#78, fixes #24):
  * `NbBlock` type is completely refactored. Instead of having a `kind` with a fixed
    number of values, a block behaviour is specified by a `command` string
    which is set to the name of the command template used to create a block
    (e.g. `nbCode`, `nbText`, `nbImage`, ...) - 
  * `newNbBlock` is now the main template to create a new block
  * Every block now has a `context` field and the rendering backend (either html or markdown)
    has a mechanism to retrieve a `partial` for every command.
  * as an additional mechanism to be able to perform other computations when rendering,
    a sequence of `renderProc`s can be assigned for every command (for a specific backend).
  * `nimib / renders` module completely refactored to take into account the above changes
  * some other accidental or not so welcome changes that happened during the refactoring:
    - `sugar` is now exported _(accidental)_
    - `nb: NbDoc` is mutated when rendered _(unwelcome, will be changed later)_
    - cannot use both Html and Md backend at the same time _(unwelcome, will be changed later)_
* logging has been improved (see changes in `nimib.blocks.newNbBlock`) (#78)
* new `main` partial introduced (#78)
* fixed cheatsheet document (#78, fixes #52)
* tests are added and ptest document is removed (#78)
* aliases to minimize breaking changes that happened in 0.2 (`nbDoc`, `nbBlock`, `nbHomeDir`) are noew removed (#78)
* added a new `readCode: bool` parameter to `newNbBlock` (with an overload that sets it as true) (#80)
* new template `nbRawOutput` that renders raw html (#80)
* new command `nbClearOutput` that removes output from last block processed (#80)
* new templates for creating code blocks `newNbCodeBlock` and `newNbSlimBlock`
  for creating custom blocks and related changes (#81):
  - `newNbCodeBlock`: captures source code of `body`
  - `newNbSlimBlock`: block without a `body` (and in particular no capture of source)
  - all nimib "native" blocks now use one of the two mechanism above
  - now `nbText` does NOT contain its source
  - new `nbTextWithCode` that does contain code source
* new example document `files.nim`, changed the rendering of `nbFile`
  (no more "writing file ..." only the name of file is added) (#81)
* added `loadNimibCfg` proc that can be used for themes (used by nimibook) (#81)
* added `nbInitPython` and `nbPython` templates to support running python in nimib documents using `nimpy` (#83)
  - `md` and `fmd` from `nimib / boost` now deprecated and replaced by `hlMd` and `hlMdF`
  - new `hlPy` and `hlPyF` in `nimib / boost`
* docs now are built in CI (#89, #90, #91)
  - sources of docs are now in folder `docsrc`
  - outputs are in `docs`
* add deploy preview through netlify (#92, #93)
* new templates to introduce interactivity in documents taking advantage of nim's javascript backend (#88)
  - `nbCodeToJs`: a block of nim code is compiled to javascript and added as a script to html file (and allows capturing of variables)
  - `nbCodeToJsInit`, `addCodeToJs`, `addToDocAsJs`: templates to allow splitting in multiple blocks the code in `nbCodeToJs`
  - `nbCodeToJsShowSource`: template to show the nim source of a `nbCodeToJs` block.
  - `nbKaraxCode` (with `karaxHtml`): template to create a karax app/widget with minimal boilerplate (based on `nbCodeToJs`)
  - new example document `interactivity.nim`: explains the basic of `nbCodeToJs` and related templates
  - new example document `counters.nim`: shows how to create counter widgets using `nbCodeToJs`
  - new example document `caesar.nim`: a caesar cipher app built using `nbKaraxCode`
  - new module `nimib / jsutils` to support the implementation of the above 
* `newId` proc for `NbDoc` that gives a new incremental integer every time it is called (#88)
* `CodeAsInSource` is made default:
  - new `nimibCodeFromAst` flag to revert to old default
  - added a warning to `nimibPreviewCodeAsInSource` (now obsolete)
* various fixes to `CodeAsInSource` (#105, #106, #108)
* changelog updated and separated from documentation (#103)
* updated documentation to include most recent changes (#103)
* turned off warning for unused imports in `nimib.nim` (#103)
* fix markdown backend, it was broken since html theme was overiding render backend (#103):
  - new `nbInitMd` to use markdown backend
  - new `themes.noTheme` for empty theme (used by `nbInitMd`)

Thanks to @metagn for improving our CI/nimble file! Every contribution counts!

Relevant examples of usage:

* [nimislides](https://github.com/HugoGranstrom/nimib-reveal): a new nimib theme that allows to create
  slides using [reveal.js](https://revealjs.com) html presentation framework
* some posts in nblog are relevant example of new blocks and customization of nimib:
  - [Making Diagrams using mermaid.js](https://pietroppeter.github.io/nblog/drafts/mermaid_diagram.html)
  - [Plotly in nimib](https://pietroppeter.github.io/nblog/drafts/show_plotly.html)

## 0.2.x (November 2021)

### 0.2.4 - CodeAsInSource

* Update penguins example which now uses datamancer and shows Simpson's paradaox, by @Vindaar (#70)
* code as in source for nbCode (`-d:nimibPreviewCodeAsInSource`) by @HugoGranstrom (#63): with this option the code shown is not derived from Ast but it is read from source code.
* ptest document is turned off from CI

### 0.2.3

* align version in nimble file and tagged version 

### 0.2.2 - nbFile

* add `nbFile` by @Clonkk (#64)

### 0.2.1

* fix to `path_to_root` (renamed from `home_path`, also `here_path` renamed to `path_to_here`) (#67)

## 0.2 "Theme Maker" (November 2021)

this release aims to simplify creating Nimib themes such as nimibook.

It does this through the following changes:
* instead of creating and injecting multiple variables
  (`nbDoc`, `nbBlock`, `nbHomeDir`, ...), nimib now only injects a `nb` variable
  that is a `NbDoc`. Some aliases are provided to minimize breakage.
* handling of paths (`srcDir` and `homeDir`) is changed and is based on the presence
  of a new config file `nimib.toml`
* command line options are now processed and can be used to skip/override the config process.
  Run any nimib file with option `--nbHelp` to see available options.
* note in particular new `--nbShow` option which will automatically open the file in your default browser.
* `nbPostInit` and `nbPreSave` customization mechanism based on includes are now removed 
* documentation has been updated to reflect the above changes and also to add other Nimib references (NimConf video, nimibook, getting-started, ...)
most of the changes break the api

relevant external example:

* [norm](https://norm.nim.town) starts to use nimibook for its documentation

Special thanks again to to @Vindaar, @Clonkk and @HugoGranstrom for this release.

## 0.1.x (March-June 2021)

a growing ecosystem drives most of the development of the 0.1.x series:

* [intro to binarylang](https://ajusa.github.io/binarylang-fun/intro.html) by @ajusa (March 2021): first public use of nimib by someone other than @pietroppeter 
* [SciNim Getting Started](https://scinim.github.io/getting-started/) decided to use nimib and for that purpose
  [nimibook](https://github.com/pietroppeter/nimibook), a book theme (based of mdbook) developments was started
* [nblog](https://github.com/pietroppeter/nblog), a nimib blog, was started as a way to use nimib to explore nim ecosystem and experiment
  the various features of nimib
* [nimiboost](https://github.com/HugoGranstrom/nimiBoost) is a vs code extension to provide
  markdown highlighting and a preview mechanism.

changes:

*  0.1.1:
  - add nbPostInit mechanism to customize document (#32)
  - fix (breaking): code output is escaped by default
  - fix (breaking): code output is not stripped anymore
  - fix: nbDoc.write will create directories if not existing (#44)
* 0.1.2: release to align tag and nimble version
* 0.1.3: added compile-time switches to override nbHomeDir (#53)
* 0.1.4: fix for `nbImage` path (#56)
* 0.1.5: new template `nbCodeInBlock` (#59)
* 0.1.6: added `nimib / boost` module with `md` and `fmd` helpers to support markdown highlight with nimiboost

Thanks for this release series to @Vindaar, @Clonkk and @HugoGranstrom who decided to adopt
nimib in scinim/getting-started and motivated and directly contributed to nimib and nimibook development
to support this use case.

At the end June 2021, nimib was presented at [NimConf2021](https://conf.nim-lang.org).

## 0.1 (March 2021)

* initial version with essential templates `nbInit`, `nbText`, `nbCode`, `nbImage`, `nbSave`
  - capture of output in `nbCode` based on code by @Clonkk
* html backend based on mustache and markdown by @soasme
* default theme using water.css
  - header with home button, minimal title (filename by default), automatic detection of github repo
  - footer with "made with nimib" and Show Source button
* static highlighting of nim code (by @yardanico)
* latex rendering through katex
* markdown backend
* essential documentation in `index.nim`
  - sections: intro, example usage, features, api, roadmap, thanks, Q&A
  - also generates `README.md` and serves as an example of usage of markdown backend
* possibility to customize theme (dark mode, custom stylesheet, add other scripts, ...)
* example documents:
  - `penguins`: data exploration, adding images
  - `numerical`: latex usage, theme customization
  - `cheatsheet`: toc creation, new text block which shows source, custom highlighting
    - also documents the markdown to html generator
  - `mostaccio`: example of using dark mode
    - also documents the templating system mustache
  - `ptest`: print testing for nimib
* deployed using github pages. html files committed in repo.

relevant external examples:

* adventofnim (2020) by @pietroppeter
  - first appeareance of nimib in public (before 0.1 release), see [commit on Dec 1st, 2020](https://github.com/pietroppeter/adventofnim/commit/973f9a2472d41188bb37650c082f115fc5787687#diff-a21a437c51bd7babb945c8291588853296387c7e1950997e05f1eb62d18b54f7)

Initial commit of nimib was on Nov, 25, 2020.
On the same day the [first milestone](https://github.com/pietroppeter/nimib/commit/b02ec7be4663956167701a81a96246d8e528fff3)
reached was the working hello world example.

For this release, thanks to:

* [soasme](https://github.com/soasme) for the excellent libraries nim-markdown and nim-mustache, which provide the backbone of nimib rendering and customization
* [Clonkk](https://github.com/Clonkk) for help in a critical piece of code early on (see [this Stack Overflow answer](https://stackoverflow.com/a/64032172/4178189))
* [yardanico](https://github.com/yardanico) for being the first contributor and great sponsor of this library, even before an official release