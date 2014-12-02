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

(struct book (name author cover copyright last-update keyword))

(define racket-book (book "Racket语言入门"
						  "Tyr Chen"
						  "assets/images/cover.jpg"
						  "Copyright (c) 2014-2015 by Tyr Chen. All rights reserved."
						  (string-append "最后更新于：" (date->string (current-date) #t))
						  "racket,scheme,lisp,racket入门"))

(define-syntax-rule (rb body ...)
   (racketblock body ...))

(define-syntax-rule (r body ...)
   (racket body ...))

