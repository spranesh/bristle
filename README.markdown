This file is *auto generated* from README.pdc via the Makefile



# What?

We all like beamer. No, really! It gives us freedom to do what we want to. We
don't have to click ten buttons (and search through menus) to get something
done. And it creates amazing looking presentations.

However, writing LaTeX Beamer *sucks*. Most of my presentations contain the same
elements, similar features, but I end up typing way over what I should be. It
also gets in the way of my thinking my presentation through.

So, I decided to create an EXTREMELY simple "markup" language for helping my
fingers, and to stay out of my while I think. It of course had to support
insertion of arbitrary LaTeX commands.

## Example
[This](example.pdf) is the output obtained by writing [this](example.txt).

# How?

Bristle is a very simple markup language. It is designed from ground up to be
context free. This is to keep translation simple, and easy correlation of
errors in the markup to the errors pointed out by `pdflatex`.

Specifically, Bristle touches lines tagged with their first non space
characters.

## License
This utility is licensed under the Free BSD license.

# Downloading, Installing and Running

## Requirements

Bristle requires

* `ghc` - the Glorious Glasgow Haskell Compiler
* `pdflatex`

## Downloading and Installing

Bristle can be downloaded from [here](bristle.tar.gz). Bristle is written in
*Haskell* and can be compiled by simply typing `make`. It can be installed (into
`/usr/bin`) by typing `make install`.

It can be installed to one's `~/bin` by using `make install-home`.

A typical setup would hence be:

    $ tar -xvzf bristle.tar.gz
    $ cd bristle
    $ make
    $ make install-home

## Running

Bristle takes input from stdin and writes output to stdout. It has *no* command
line options whatsoever (I think that's a good thing). The output from Bristle
can be run through pdflatex directly. Here's an example of a use case.

    $ bristle < ppt.txt > ppt.tex
    $ pdflatex ppt.tex
    $ evince ppt.pdf

There is a shell script provided in the package to simplify this usage. This is
called bristle-compile, and is installed by default. With bristle-compile, the
above workflow then becomes:

    $ bristle-compile ppt.txt # creates a ppt.tex and a ppt.pdf
    $ evince ppt.pdf
 

## Effective Usage

Ideally, Bristle is used for quick prototyping and a first draft of the beamer
presentation. Finer edits are made to the tex file at the end, after one is
satisfied with the results.

# User Guide

## Title, Author, Date

Bristle treats the first three lines specially. Each has to start with a '%'
character, and must contain in order, the title, author and date.

It should warn in case the header is wary (does not start with a percentage).

## Markup

Most Beamer presentations contain the same key elements, at least during the
brainstorming stage.

  * frames
  * enumerations / itemizes
  * sections
  * pauses

(In fact, the only things I use apart from these are images, quotations, and
vspaces. But they are rare enough not to require markup).

Bristle deals with the most commonly occurring scenarios, while staying out of
your way for the rest.

### Frames

Frames are created as

    # Frame Title

They *must* be closed with `##`.

Fragile frames (verbatim) are often required. These can be created by:

    #* A fragile frame

An example:

    # A slide about how cool gulls are

      Gulls are like AWESOME

    ##

### Lists/Enumerations

Unordered lists are started with the `((` tag. They are closed with the `))`
tag. 

Ordered lists are started with the `[[` tag. They are closed with the `]]` tag.

*Note*: Each of these tags must be on a new line by themselves.


Items in the list begin with a `*`.

An example:


    I like

    ((
      * apples
      * oranges
      * mangoes
    ))

    In order I like
    [[
      * mangoes
      * oranges
      * apples
    ]]


### Verbatim

A verbatim section (useful for displaying code, besides other things) is started
with `{{` and ends with `}}`. Remember that the frame containing them must be
marked fragile with a `#*`.

Example:

    #* A slide with code

    Here is some useful C code

    {{
      int fib(int n) {
        if (n == 0 || n == 1) {
          return 1;
        } else {
          return fib(n-1) + fib(n-2)
        }
      }
    }}

    Useful code, that, isn't it?
    ##

### Sections

Sections are marked with a `S#`. The `#` are reminiscent of pandoc's (or
markdown's) tags. As an example:

    ...
    End of last slide
    ## 

    #S How gulls are awesome!

    # Gulls have long beaks
    
    ...
    ...

A `#S` tag can be used wherever a section tag can be used in Haskell.

### Centering

Centering is achieved with the `C(` and the `C)` tags. As an example:

    # Lame Slide

    This is arbitrary text

    C(
      This is centered text
    C)

    ##

### Pauses

Pauses are achieved with a `!!`. They literally expand to a `\pause` and can be
used wherever a `\pause` can be used it.

As an example

    # Barney Stinson says

    ((
      * Wait for it
        !!
      * Wait for it
        !!
      * Wait for it
    ))
    ##

## Escaping
Any line which has its first non whitespace character as `%` will have the `%`
removed and otherwise be completely untouched by it. This is useful for escaping
a line.

Example - escape a `*` at the beginning of a line:

    % *

Example - Insert a `%` at the start of the line:

    %%
This will remove the first `%` keeping the rest of the line intact.

## Quick Reference

 Tag  Meaning
----- -------------------------------
 #     Title - of a frame
 #*    Title of a Fragile Frame
 ##    End Frame
 S#    section
 ((    start of itemize
 ))    end of itemize
 [[    start of enumeration
 ]]    end of enumeration
 *     point in itemize/enumeration
 {{    start of verbatim
 }}    end of verbatim
 C(    begin center
 C)    end center
 !!    pause
 %     escape the rest of the line

## Arbitrary LaTeX commands

Arbitrary LaTeX can be inserted wherever deemed necessary:

    # A slide with vertical spacing
      
      Here is some text
      \vspace{0.3in}
      Here is some \textbf{more}.

    ##

## Header used by Bristle

Bristle uses the following default header in generating the TeX file:

    \documentclass{beamer}
    \usepackage{graphicx}
    \usepackage{beamerthemesplit}
    \usetheme{Warsaw}

It also sets the title, author and date as found in the first three lines of the
file, and creates a default title slide.

## Notes

Some important caveats:

  * Don't forget to close your frames with a `]]`.
  * Escape special characters[^1] just like you would with LaTeX.
  * One might have to compile twice (using pdflatex) to get section headings
    properly.

[^1]: Namely # $ % & ~ _ ^ \ { }

Some limitations:
  * There is no way to currently change the header produced (apart from editing
    the TeX) - not even in verbatim mode. However, these tags occurring at the
    start of line are rare (except maybe the '#' tag in shell script sources).

# What's coming up?
Bristle currently satisfies my itch. So, don't expect anything big
soon (except bug fixes). However, I plan to:

* Create a vim syntax mode for bristle files.
* Automatically insert frame endings `]]` if found absent.

