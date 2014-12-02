#lang racket

(require racket/runtime-path
         "../util/common.rkt")

(define ga-code
#<<EOF
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
	  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
	    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-57258984-1', 'auto');
ga('send', 'pageview');
</script>
EOF
)

(define (meta k v)
  (format "<meta name=\"~a\" content=\"~a\">" k v))

(define metas
  (string-append
   (meta "keywords" (book-keyword racket-book))
   (meta "description" (book-name racket-book))
   (meta "author" (book-author racket-book))
   (meta "charset" "utf-8")))
  
(define </head> "</head>")

(define all (string-append metas ga-code </head>))
(define subst (regexp-replace* "\n" all "")) ;minify

(define (do-file path)
  (define old (file->string path))
  (define new (regexp-replace </head> old subst))
  (with-output-to-file path
    (lambda () (display new))
    #:mode 'text
    #:exists 'replace))


(define-runtime-path here "../html")
(for ([path (find-files (lambda (path)
                          (regexp-match? #rx"\\.html" path))
                        here)])
  (do-file path))
