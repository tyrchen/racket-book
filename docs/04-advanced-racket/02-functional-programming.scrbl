#lang scribble/doc

@(require (for-label racket)
          scribble/manual
          "../../util/common.rkt")


@title[#:tag "advanced-racket-fp"]{函数式编程}



@section[#:tag "advanced-racket-fp-func"]{高阶函数（High-ordered Function）}

@section[#:tag "advanced-racket-fp-pure-func"]{纯函数（Pure Function）}

@section[#:tag "advanced-racket-fp-closure"]{闭包}

@section[#:tag "advanced-racket-fp-recursion"]{递归}

@section[#:tag "advanced-racket-fp-curry"]{柯里化（Currying）}

@rb[
(define rdoc (curry (lambda (libname name) (secref name #:doc libname))))
(define rdoc-ref (rdoc '(lib "scribblings/reference/reference.scrbl")))
(define rdoc-teachpack (rdoc '(lib "teachpack/teachpack.scrbl")))
]

@section[#:tag "advanced-racket-fp-lazy-eval"]{惰性求值（Lazy Evaluation）}