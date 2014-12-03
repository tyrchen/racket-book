#lang racket

(require scribble/eval
		 racket/syntax
		 racket/date
		 scribble/manual
		 db
		 pict
		 plot
		 plot/utils
		 (for-label racket
		 			pict
		 			plot
		 			plot/utils
		 			db))

(provide (all-defined-out)
		 (all-from-out plot)
		 (all-from-out plot/utils)
		 (all-from-out db)
		 (all-from-out pict)
		 (for-label (all-from-out racket
                                  pict
                                  db
                                  plot
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

;; shortcut for racket
;;
(define-syntax-rule (r body ...)
   (racket body ...))

;; shortcut for hyperlink
;;
(define-syntax-rule (rh body ...)
   (hyperlink body ...))

(require (only-in scribble/core style element)
         (only-in scribble/manual para)
         (only-in scribble/html-properties attributes alt-tag))

;; For use in Scribble source file. Lets you create a <pre><code class="#:lang"> 
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