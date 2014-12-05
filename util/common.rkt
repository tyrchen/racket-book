#lang racket

(require scribble/core
		 scribble/racket
		 scribble/eval
		 racket/syntax
		 racket/date
		 scribble/manual
		 db
		 2htdp/image
		 2htdp/universe
		 plot/utils
		 (for-label racket
		 			2htdp/image
		 			2htdp/universe
		 			plot/utils
		 			db))

(provide (all-defined-out)
		 (all-from-out plot/utils)
		 (all-from-out scribble/eval)
		 (all-from-out db)
		 (all-from-out 2htdp/image)
		 (all-from-out 2htdp/universe)
		 (for-label (all-from-out racket
                                  2htdp/image
                                  2htdp/universe
                                  db
                                  plot/utils)))

;; for the document meta data
;;
(struct book (name author cover copyright last-update keyword))

(define racket-book (book "Racket语言入门"
						  "Tyr Chen"
						  "assets/images/cover.jpg"
						  "Copyright (c) 2014-2015 by Tyr Chen. All rights reserved."
						  (string-append "最后更新于：" (date->string (current-date) #t))
						  "racket,scheme,lisp,racket入门"))

(define (drr) (racket DrRacket))

;; shortcut for racketblock
;;

(define-syntax-rule (rb body ...)
   (racketblock body ...))

;; shortcut for examples
(define basic-eval (make-base-eval))
(interaction-eval #:eval basic-eval
	(require racket/base
	         racket/math
	         racket/string
	         racket/list))
;; Here we can actually define more eval for different situation, such as plot-eval...
(define-syntax re
  (syntax-rules ()
    [(_ #:eval . rest)
     (interaction #:eval . rest)]
    [(_ . rest)
     (interaction #:eval basic-eval . rest)]))

;; shortcut for racket
;;
(define-syntax-rule (r body ...)
   (racket body ...))

;; shortcut for hyperlink
;;
(define-syntax-rule (rh body ...)
   (hyperlink body ...))

(require (only-in scribble/html-properties attributes alt-tag))

;; For use in Scribble source file. Lets you create a <pre> class="code"<code class="#:lang"> 
;; block with a language tag that can be syntax highlighted by highlight.js.
;;
;; Example usage:
;;
;; @code-hl[#:lang "js"]{function foo() {return 1;}}
;;
(define (code-hl #:lang lang . xs)
	(element (style "code" (list (alt-tag "pre")))
		(element (style lang (list (alt-tag "code")))
		xs)))

(define reduces (make-element #f (list 'rarr)))

;; For use in Scribble source file. Lets you highlight code on source code enclosed with @rb[].
;;
;; Example usage:
;;
;; @rb[(define #,(hl name) "Tyr Chen")]
;;
(define *hl (lambda (c)
                  (make-element highlighted-color (list c))))
(define-syntax hl
   (syntax-rules () [(_ a) (*hl (racket a))]))