#lang racket

(require "shared/utility.rkt"
         (rename-in 2htdp/image [rotate rotate-1])
         2htdp/universe)

(define PIECE_DIST '(2 2 2 2 2 2 2 2 2 4))

(define (make-board n)
  (make-list n (make-list n 0)))

(define (init-board n)
  (put-random-piece (put-random-piece (make-board n))))

(define (get-a-piece)
  (choice PIECE_DIST))

; e.g. '((2 0) (2 4)) -> #t
(define (avail? lst)
  (if (list? lst)
      (ormap avail? lst)
      (zero? lst)))

; e.g. '((2 2) (2 0) (0 0)) -> '(1 2)
(define (get-empty-refs lst zero-fun?)
  (for/list ([item lst]
             [i (range (length lst))]
             #:when (zero-fun? item))
    i))

; e.g. '(0 2 0 0) -> '(0 2 0 2)
; e.g. '((0 2 0 0) (2 4 8 16) (0 4 4 8) (2 0 0 0)) -> 
;      '((0 2 0 0) (2 4 8 16) (0 4 4 8) (2 0 2 0))
(define (put-random-piece lst)
  (if (avail? lst)
      (if (list? lst)
          (let* ([i (choice (get-empty-refs lst avail?))]
                 [v (list-ref lst i)])
            (append (take lst i)
                    (cons (put-random-piece v) (drop lst (add1 i)))))
          (get-a-piece))
      lst))

; e.g. '(2 2 2 4 4 4 8) -> '(4 2 8 4 8)
(define (merge row)
  (cond [(<= (length row) 1) row]
        [(= (first row) (second row))
         (cons (* 2 (first row)) (merge (drop row 2)))]
        [else (cons (first row) (merge (rest row)))]))

; e.g. '(2 0 4 4) #f -> (0 0 2 8)
(define (move-row row v left?)
  (let* ([n (length row)]
         [l (merge (filter (λ (x) (not (zero? x))) row))]
         [padding (make-list (- n (length l)) v)])
    (if left?
        (append l padding)
        (append padding l))))

(define (move lst v left?)
  (map (λ (x) (move-row x v left?)) lst))

(define (move-left lst)
  (put-random-piece (move lst 0 #t)))

(define (move-right lst)
  (put-random-piece (move lst 0 #f)))

(define (move-up lst)
  ((compose1 rotate move-left rotate) lst))

(define (move-down lst)
  ((compose1 rotate move-right rotate) lst))

(define ALL-OPS (list move-right move-down move-left move-up))

; '((2 8 4 2) (8 4 8 16) (4 32 2 4) (2 16 4 2)) -> #t
(define (finished? lst)
  (andmap (λ (op) (equal? lst (op lst))) ALL-OPS))

(define (test-play lst step)
  (if (and (not (avail? lst)) (finished? lst))
      (values lst step)
      (test-play ((choice ALL-OPS) lst) (add1 step))))


;; game
(define ALPHA #xb8)

(define GRID-COLOR (hex->rgb "#bbada0"))

(define TILE-BG
  (make-hash (map (λ (item) (cons (first item) (hex->rgb (second item))))
       '((0    "#ccc0b3") (2    "#eee4da") (4    "#ede0c8")
         (8    "#f2b179") (16   "#f59563") (32   "#f67c5f")
         (64   "#f65e3b") (128  "#edcf72") (256  "#edcc61")
         (512  "#edc850") (1024 "#edc53f") (2048 "#edc22e")))))

(define TILE-FG 'white)

(define TILE-SIZE 80)
(define TILE-TEXT-SIZE 50)
(define MAX-TEXT-SIZE 65)
(define TILE-SPACING 5)

(define (make-tile n)
  (define (text-content n)
    (if (zero? n) ""
        (number->string n)))

  (overlay (let* ([t (text (text-content n) TILE-TEXT-SIZE TILE-FG)]
                  [v (max (image-width t) (image-height t))]
                  [s (if (> v MAX-TEXT-SIZE) (/ MAX-TEXT-SIZE v) 1)])
             (scale s t))
           (square TILE-SIZE 'solid (hash-ref TILE-BG n))
           (square (+ TILE-SIZE (* 2 TILE-SPACING)) 'solid GRID-COLOR)))

(define (show-board b)
  (let ([images (for/list ([row b])
                  (hc-append (map make-tile row) TILE-SPACING))])
    (vc-append images TILE-SPACING)))

(define (show-board-over b)
  (let* ([board (show-board b)]
         [layer (square (image-width board) 'solid (color 0 0 0 90))])
    (overlay (text "Game over!" 40 TILE-FG)
             layer board)))

(define (key->ops a-key)
  (cond
    [(key=? a-key "left")  move-left]
    [(key=? a-key "right") move-right]
    [(key=? a-key "up")    move-up]
    [(key=? a-key "down")  move-down]
    [else (λ (x) x)]))

(define (change b key)
  ((key->ops key) b))

(define (start n)
  (big-bang (init-board n)
            (to-draw show-board)
            (on-key change)
            (stop-when finished? show-board-over)
            (name "2048 - racket")))
(start 4)
