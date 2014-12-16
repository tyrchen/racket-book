#lang racket
(require (rename-in 2htdp/image [rotate rotate-1]))

(provide (all-defined-out))

(define (choice lst)
  (if (list? lst) (list-ref lst (random (length lst)))
      (vector-ref lst (random (vector-length lst)))))

; http://stackoverflow.com/questions/23177388/rotate-a-list-of-lists
(define (rotate lsts)
  (apply map list lsts))

; #aabbcc -> '(170 187 204)
(define (hex->rgb hex [alpha 255])
  (define r (regexp-match #px"^#(\\w{2})(\\w{2})(\\w{2})$" hex))
  (define (append-hex s) (string-append "#x" s))
  (define (color-alpha c) (apply color (append c (list alpha))))
  (if r
      (color-alpha (map (compose1 string->number append-hex) (cdr r)))
      #f))

(define (image-append images get-pos overlap)
  (if (<= (length images) 1)
      (car images)
      (let* ([a (first images)]
             [b (second images)]
             [img (apply overlay/xy 
                         (append (list a) (get-pos a overlap) (list b)))])
        (image-append (cons img (drop images 2)) get-pos overlap))))

(define (hc-append images [overlap 0])
  (image-append images
                (λ (img o) (list (- (image-width img) o) 0))
                overlap))

(define (vc-append images [overlap 0])
  (image-append images
                (λ (img o) (list 0 (- (image-height img) o)))
                overlap))