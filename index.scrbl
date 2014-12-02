#lang scribble/manual

@(require (for-label pict racket)
          scribble/racket
          pict
          "util/common.rkt")



@title{@(book-name racket-book)}

@author[@(book-author racket-book)]


@image[@(book-cover racket-book)]
@para[@smaller{@(book-copyright racket-book)}]
@para[@smaller[@(book-last-update racket-book)]]
@para{如果您发现本书的任何问题，请在 @hyperlink["https://github.com/greghendershott/fear-of-macros/issues" "该书的github项目上提交问题单，多谢！"].}


@table-of-contents[]

@; -------------------------------------------------
@include-section[ "docs/begin.scrbl"]