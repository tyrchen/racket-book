#lang scribble/doc

@(require (for-label racket)
          scribble/manual
          "../util/common.rkt")

@title[#:tag "advanced-racket"]{Racket语言进阶}

@section[#:tag "advanced-racket-concepts"]{基本概念}

@section[#:tag "advanced-racket-fp"]{函数式编程}

@subsection[#:tag "advanced-racket-fp-func"]{和高阶函数（High-ordered Function）}

@subsection[#:tag "advanced-racket-fp-pure-func"]{纯函数（Pure Function）}

@subsection[#:tag "advanced-racket-fp-closure"]{闭包}

@subsection[#:tag "advanced-racket-fp-recursion"]{递归}

@subsection[#:tag "advanced-racket-fp-curry"]{柯里化（Currying）}

@rb[
(define rdoc (curry (lambda (libname name) (secref name #:doc libname))))
(define rdoc-ref (rdoc '(lib "scribblings/reference/reference.scrbl")))
(define rdoc-teachpack (rdoc '(lib "teachpack/teachpack.scrbl")))
]

@subsection[#:tag "advanced-racket-fp-lazy-eval"]{惰性求值（Lazy Evaluation）}

@section[#:tag "advanced-racket-debug"]{调试Racket程序}

@section[#:tag "advanced-racket-executable"]{打包Racket代码}