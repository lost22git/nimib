import nimib, strformat, nimoji

nbInit
nbDoc.title = "Nimib Docs"

let
  repo = "https://github.com/pietroppeter/nimib"
  docs = "https://pietroppeter.github.io/nimib"
  hello = readFile("hello.nim".RelativeFile)
  assets = "docs/static"
  highlight = "highlight.nim.js"
  defaultHighlightCss = "atom-one-light.css"

nbText: fmt"""
# nimib :whale:

nim :crown: driven :sailboat: publishing :writingHand:

:construction: working towards a 0.1 release :construction:

* [repository]({repo})
* [documentation]({docs})

## :wave: :earthAfrica: Example Usage

First have a look at the following html document: [hello]({docs}/hello.html)

This was produced with `nim r docs/hello`, where [docs/hello.nim]({repo}/blob/main/docs/hello.nim) is:

```nim
{hello}
```

<!--TODO
Note the following:

  * the code that appears in the

### Try it!

*TODO*
-->

## API

### external API

By external API we mean the following templates:

* `nbInit` (*always required*): it initializes the notebook,
   the other templates are not accessible if nbInit is not called.
* `nbText`: it is followed by any expression that evaluates to a string.
  this text is by default assumed to be markdown and it will be rendered as html
  thanks to [nim-markdown](https://github.com/soasme/nim-markdown).
* `nbCode`: followed by a block of code, it will execute the code,
  and capture the output. It will be rendered in the final html document
  as a block of nim code followed by preformatted text.
* `nbSave`: it is required to save the document to a file.
  Rendering takes place at this moment.
  By default the document will be save as an html (templated with [nim-mustache](https://github.com/soasme/nim-mustache))

other templates on top of the four basic ones will likely be added.

### internal api

`nbInit` creates two variables `nbDoc` and `nbBlock`, which are injected in the scope.
At every block of code or text (or else) `nbBlock` is updated and added to `nbDoc`.
`nbBlock` is a ref object, so changes done to it after a block will be reflected in
the content of `nbDoc`.

The specific types `NbDoc` and `NbBlock` are unstable and they will likely change,
but it is likely that access the following elements will be guaranteed:

  * `nbDoc.blocks`: container of all the blocks
  * `nbDoc.render`: a closure from NbDoc to string that produces the rendered document
  * `nbBlock.output`: string with the output of a nbCode/nbText block (not yet rendered)
  * `nbBlock.code`: stringification of the code block through AST.
    if it appears different than what you typed it is because nim likes it better that way.
    In particular only documentation comments survive this process and normal comments will
    not appear.

Here are two examples that show how to abuse the internal api:

* [nolan]({docs}/nolan.html): how to mess up the timeline of blocks :hourglass_flowing_sand:
* [pythno]({docs}/pythno.html): finally the long awaited python-skin for nim! :stuck_out_tongue_winking_eye:

<!--
### extending the api

*TODO*

-->

## Rendering

### html rendering

There are two levels of html rendering.

1. **render-in-the-small**: rendering html fragments. This is mostly taken care by nim-markdown
   and by appropriate semantic tagging in render functions (this can be overriden).
2. **render-in-the-large***: putting together html fragments and other elements to publish one or more documents.
   this is delegated to nim-mustache and to manual creation and update of json and context fields in doc and block objects.

### markdown rendering

For an example on how to output Markdown see [docs/index.nim]({repo}/blob/main/docs/index.nim),
which automatically renders the `README.md` in the repo.

### code highlighting

Code highlighting is provided by [highlight.js](https://highlightjs.org/).
The script `{assets}/{highlight}` contains highlighting assets only for nim language.
The default css style for highlighting is `{assets}/{defaultHighlightCss}`.

If you want to change the style pick one using [highlight demo page](https://highlightjs.org/static/demo/)
(select all languages to find Nim) and make the appropriate change in `templates/head.mustache`.

<!--
## static assets

*TODO*

## paths

*TODO*

default situation for single article that does not access filesystem:

* you do not have to worry about nothing.
  the new html will appear next to your nim file with same name and html extension

if you need to change name or location of html output, or if you need to access
filesystem (in particular if you need it for your web assets), this is what you need to know:

* with nbInit a number of paths are initialized
* we follow compiler/pathutils which is available (exported) from nim paths.
  (along with os stuff also exported)
* nbThisFilename (string): name of this file (with nim extension).
* nbThisDir (RelativeDir): directory where this nim file resides
* nbThisFile (RelativeFile): this should be a template that gives nbThisDir + nbThisFilename
* npProjectDir (AbsoluteDir): the reference directory for the project.
  looks for a nimble file starting from nbThisDir in parent dirs.
  This should be the only Absolute path,
  all other paths should be relative to this path.
* nbProjectFile (RelativeFile): path (and also name since it is
  relative to the nbProjectDir) of the nimble file found as reference for the project.
  (what happens if multiple nimble files are found?)
* nbCurDir (RelativeDir): template that returns current directory.
  it should be set at the beginning as equal to nbProjectDir (with change of directory).
* nbDoc.dir (RelativeDir): this is directory where the specific nbDoc
  (there can be more than on) will be written to. Defaults to nbThisDir.
* nbDoc.filename (string): name of the output document *without extension*
  (default: nbThisFilename removing nim extension). or maybe with extension??
  should I add some magic in order to have a change of filename to check
  if it has extension and add it automatically?
* nbDoc.ext (string): extension (default: html)
* nbDoc.file (RelativeFile): nbDoc.dir + nbDoc.filename + nbDoc.ext
* the above fields of nbDoc become then an API that should be guaranteed for NbDoc object.

other thoughts

- should I add a Filename and Ext distinct string to pathutils?
- since I never remember which slash should I use maybe I could introduce
a +/- operator that work on this distinct strings
- also I should introduce readfile, writefile for this type of objects.

## Future directions / Todos / Roadmap / The long run

*TODO*
-->

## :question: :exclamation: Q & A

### why the name?

corruption of [ninib](https://www.vocabulary.com/dictionary/Ninib):

> a solar deity; firstborn of Bel and consort was Gula;
> god of war and the _chase_ and agriculture; sometimes identified with biblical *Nimrod*

also:

> He explains that the seven directions were interpreted by the Babylonian theologians
> as a reference to the seven great celestial bodies, the sun and moon, Ishtar, Marduk, Ninib, Nergal and Nabu.
>
> This process, which reached its culmination in the post-Khammurabic period, led to identifying
> the planet Jupiter with Marduk, Venus with Ishtar, Mars with Nergal, Mercury with Nebo, and Saturn with Ninib.

and I should not need to tell you what [Marduk](https://jupyter.org/) is
and why [Saturn is the best planet](https://www.theatlantic.com/science/archive/2016/01/a-major-correction/422514/).

### why the whale :whale:?

why do you need a logo when you have emojis?

no particular meaning about the whale apart the fact that I like the emoji and this project is something I have been [chasing](https://en.wikipedia.org/wiki/Captain_Ahab) for a while
(and I expect to be chasing it indefinitely).

also googling `nimib whale` you might discover the existence of a cool place: [Skeleton Coast](https://en.wikipedia.org/wiki/Skeleton_Coast).

### why the emojis?

because I made a [package](https://github.com/pietroppeter/nimoji) for that and someone has to use it

### why the Q & A?

because [someone made it into an art form](https://github.com/oakes/vim_cubed#q--a)
and they tell me [imitation is the sincerest form of flattery](https://www.goodreads.com/quotes/558084-imitation-is-the-sincerest-form-of-flattery-that-mediocrity-can)
""".emojize

nbSave

nbDoc.render = renderMark
nbDoc.filename = "../README.md"
nbSave