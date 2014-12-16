#lang scribble/doc

@(require (for-label racket)
          scribble/manual
          "../../util/common.rkt")

@title[#:tag "practical-2048"]{做个2048小游戏}

@rh["http://gabrielecirulli.github.io/2048/" "2048游戏"] 是个曾经风靡一时的javascript小游戏，玩家在一个4x4的棋盘上，通过上下左右四个键移动棋盘上的棋子，规则是这样：

@itemlist[
@item{开始时棋盘上随机有两个棋子，2或4都有可能，其它为空}
@item{玩家可以用方向键移动棋子。移动时所有棋子一起整体移动到用户按下的方向，直到不能移动为止}
@item{在移动方向上，相邻的两个数字如果相同，则合并为一个，合并后的结果为两个数字之和（即乘以2）}
@item{每次合并的结果作为得分，累加起来}
@item{每移动一次，棋盘上空闲的位置会随机出现2或者4，出现2的几率（90%）要远大于4（10%）}
@item{当棋子布满棋盘，四个方向移动时又无法进行合并，则游戏结束}
]

感谢racket的 @r[2htdp/universe] package，我们可以很轻松地制作这样一个游戏。

@section[#:tag "practical-2048-algorithm"]{数据结构和算法}

对于这样一个4x4的棋盘，最直观的想法是用一个嵌套的 @r[list] 来表达：

@re[
(define (make-board n)
  (make-list n (make-list n 0)))
(make-board 4)
]

@margin-note{用过python的人应该知道，可以使用 @bold{random.choice} 从一个列表中随机选择。racket貌似没有这样的函数，不过没关系，我们自己写}
我们需要在棋盘上的空闲位置随机放两个棋子，所以我们先要能够随机从 @r['(2 2 2 2 2 2 2 2 2 4)] 中挑一个出来做棋子：

@re[
(define PIECE_DIST '(2 2 2 2 2 2 2 2 2 4))
(define (choice l)
  (if (list? l) (list-ref l (random (length l)))
      (vector-ref l (random (vector-length l)))))

(define (get-a-piece)
  (choice PIECE_DIST))

(get-a-piece)
]

接下来我们要随机找出一个空闲的位置：

@re[
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

(put-random-piece '((0 2 0 0) (2 4 8 16) (0 4 4 8) (2 0 0 0)))
]

@r[_avail?] 递归查看一个棋盘或者棋盘上的一行是否有 @r[0]，来决定是否可以往上放棋子。@r[_get-empty-refs] 获取当前棋盘（或者一行）上面的的可放棋子的行（或者行中元素）的索引列表，以便于我们随机摆放棋子。最后，我们可以递归选择一个随机的行，随机的列，放入一个随机的棋子。

@re[
(get-empty-refs '(0 0 0 2) avail?)
(get-empty-refs '((2 2) (2 0) (0 0)) avail?)
(put-random-piece '((0 2 0 0) (2 4 8 16) (0 4 4 8) (2 0 0 0)))
]

这样，我们就可以初始化棋盘了：

@re[
(define (init-board n)
  (put-random-piece (put-random-piece (make-board n))))

(init-board 4)
(init-board 4)
(init-board 4)
(init-board 4)
]

接下来就是按照规则合并棋子：

@re[
(define (merge row)
  (cond [(<= (length row) 1) row]
        [(= (first row) (second row))
         (cons (* 2 (first row)) (merge (drop row 2)))]
        [else (cons (first row) (merge (rest row)))]))
(merge '(2 2 2 4 4 4 8))
]

@r[_merge] 会从第一个元素起递归处理列表中的所有元素，如果相等就两两合并，然后返回合并后的列表。但是，如果两个数值相同的元素，比如：@r['(2 0 2 0)]，中间隔着 @r[0] 怎么办？我们可以用 @r[filter] 返回非 @r[0] 的元素，然后再把 @r[0] 补齐。这就是 @r[_move-row] 要做的事情：

@re[
(define (move-row row v left?)
  (let* ([n (length row)]
         [l (merge (filter (λ (x) (not (zero? x))) row))]
         [padding (make-list (- n (length l)) v)])
    (if left?
        (append l padding)
        (append padding l))))
(define (move lst v left?)
  (map (λ (x) (move-row x v left?)) lst))
(move '((0 2 0 0) (2 4 8 16) (0 4 4 8) (2 0 0 0)) 0 #t)
]

进一步，我们实现四个方向上的移动：

@re[
(define (move-left lst)
  (put-random-piece (move lst 0 #t)))

(define (move-right lst)
  (put-random-piece (move lst 0 #f)))

(define (transpose lsts)
  (apply map list lsts))

(define (move-up lst)
  ((compose1 transpose move-left transpose) lst))

(define (move-down lst)
  ((compose1 transpose move-right transpose) lst))
]

@r[apply] 是个神奇的函数，如果你学过其它函数式编程语言，或者经常写javascript，那么你一定知道 @r[apply]。它能够让传递给函数的列表展开，成为函数执行时的若干个参数。下面的两个表达式是等价的：

@re[
(apply map list '((1 2) (3 4)))
(map list '(1 2) '(3 4))
]

@margin-note{请自行类比 @r[add1] 和 @r[add]}

@margin-note{关于函数链的更多信息，请参考 @rh["http://en.wikipedia.org/wiki/Method_chaining" "wikipedia: Method_chaining"]}

@r[compose1] 是 @r[compose] 的只接受一个参数的特殊形式。@r[compose] 是函数式编程中另一个很重要的函数，它能够把传入的若干个接收同样参数并返回和参数相同形式的返回值的函数组合成一个 @bold{函数链}，就像一个新函数一样。在函数链上，代码的执行是由内到外，如下所示：

@re[
((compose1 - sqrt add1) 8)
((compose1 add1 sqrt -) 8)
]

更多函数式编程的内容，请参考 @secref{advanced-racket-fp}。我们回到2048游戏的算法设计中。当任意一个方向上移动的结果和移动前相同，意味着游戏结束：

@re[
(define ALL-OPS (list move-right move-down move-left move-up))

(define (finished? lst)
  (andmap (λ (op) (equal? lst (op lst))) ALL-OPS))
(finished? '((2 8 4 2) (8 4 8 16) (4 32 2 4) (2 16 4 2)))
]

我们测试一下，随机走，能走多少步，游戏结束：

@re[
(define (test-play lst step)
  (if (and (not (avail? lst)) (finished? lst))
      (values lst step)
      (test-play ((choice ALL-OPS) lst) (add1 step))))
(test-play (init-board 4) 0)
(test-play (init-board 4) 0)
(test-play (init-board 4) 0)
]

4x4的棋盘不够过瘾，我们来个大的：

@re[
(test-play (init-board 6) 0)
]

OK，现在这个游戏的基本算法就有了，geek们已经开始可以通过 @r[_move-xx] 等 API 在 @(drr) 中进行游戏了。

@section[#:tag "practical-2048-game"]{制作游戏}

我们先来点体力活，定义游戏的配色。由于互联网世界的颜色表示均使用十六进制的hex码，而 @r[2htdp/image] 里使用的 @r[color] 是用RGBA定义，因此我们需要做个颜色的转换：

@re[
(define (hex->rgb hex [alpha 255])
  (define r (regexp-match #px"^#(\\w{2})(\\w{2})(\\w{2})$" hex))
  (define (append-hex s) (string-append "#x" s))
  (define (color-alpha c) (apply color (append c (list alpha))))
  (if r
      (color-alpha (map (compose1 string->number append-hex) (cdr r)))
      #f))
(hex->rgb "#aabbcc" #xba)
]

有了这个函数，我们就可以很方便地定义配色和棋子大小：

@re[
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
]

接下来就是显示一个棋子。不同数值的棋子的颜色不同，而值为 @r[0] 的棋子不显示数字。我们还得处理一些显示的问题，比如说 @r[2048] 这样的数值，如果以预定义的大小显示，则会超出棋子的大小，所以我们需要 @r[scale]：

@re[
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
(make-tile 2048)
(make-tile 2)
(make-tile 0)
]

如果你读了 @other-doc['(lib "scribblings/quick/quick.scrbl")] 的话，你会对 @r[racket/pict] 中的 @r[hc-append] 和 @r[vc-append] 两个函数有印象。可惜这两个函数不接受我们使用 @r[2htdp/image] 中的各种方式制作出来的 image，所以 @r[_make-tile] 生成的图片无法使用这两个函数，那我们就只好自己写了：

@re[
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
(hc-append (map make-tile '(0 2 4 8)) 5)
(vc-append (map make-tile '(1024 256 4 8)) 5)
]

合并的方式很简单 —— 先将列表中头两个图片合并成一个，和剩下的图片组成新的列表，然后递归下去，直至合并成一张。@r[_hc-append] 和 @r[_vc-append] 其实就是调用 @r[overlay/xy] 的参数不同，所以这里抽象出来一个 @r[_image-append]。

有了这两个函数，那么展示一个棋盘就轻而易举了：

@re[
(define (show-board b)
  (let ([images (for/list ([row b])
                  (hc-append (map make-tile row) TILE-SPACING))])
    (vc-append images TILE-SPACING)))
(show-board (init-board 4))
(show-board (init-board 6))
]

@section[#:tag "practical-2048-animation"]{让游戏运行起来}

在 @r[2htdp/universe] 中，提供了 @r[big-bang] 函数。我们在之前的章节中见过这个函数。@r[big-bang] 接受键盘和鼠标事件，还会定期发出 @r[on-tick] 事件。@r[big-bang] 中所有函数都会接受一个调用者指定的参数，这个参数在 @r[big-bang] 的第一个参数中提供初值，并且根据各种事件产生后处理函数的返回值变化。你可以认为这是一个有关游戏状态的参数。在2048游戏中，棋盘就是一个游戏状态，其它的如用户得分，总共走下的步数等等，都属于游戏状态。为简单起见，我们就认为这个游戏的状态就是我们之前反复操作的棋盘。

@margin-note{如果用户敲了其它键，我们返回一个对棋盘状态什么也不做的函数}
首先我们先把键盘操作映射成为我们之前制作好的函数：

@re[
(require 2htdp/universe)
(define (key->ops a-key)
  (cond
    [(key=? a-key "left")  move-left]
    [(key=? a-key "right") move-right]
    [(key=? a-key "up")    move-up]
    [(key=? a-key "down")  move-down]
    [else (λ (x) x)]))
]

接下来我们定义整个游戏：

@re[
(define (show-board-over b)
  (let* ([board (show-board b)]
         [layer (square (image-width board) 'solid (color 0 0 0 90))])
    (overlay (text "Game over!" 40 TILE-FG)
             layer board)))

(show-board-over (init-board 5))

(define (change b key)
  ((key->ops key) b))

(define (start n)
  (big-bang (init-board n)
            (to-draw show-board)
            (on-key change)
            (stop-when finished? show-board-over)
            (name "2048 - racket")))
]

@r[_(init-board n)] 初始化一个棋盘，这个棋盘状态会传入 @r[_show_board]，@r[_change]，@r[_finished?] 和 @r[_show-board-over] 中。同样，这些函数都会返回一个新的棋盘状态，供 @r[big-bang] 下次事件发生的时候使用。

当键盘事件发生时，@r[_change] 会被调用，此时，棋盘会按照用户的按键进行变化；变化完成后，结果会通过 @r[_show-board] 展示出来；同时，每次状态改变发生后，@r[big-bang] 都会检查是否 @r[_finished?]，如果为 @r[#t]，则调用 @r[_show-board-over]。

现在，你可以调用 @r[(start 4)] 开始游戏了。是不是非常简单？

如果你想查阅本节所述的代码，可以打开 @rh["https://github.com/tyrchen/racket-book/blob/master/code/my-2048.rkt" "my-2048.rkt"]。有部分公用的代码我将其放在了 @rh["https://github.com/tyrchen/racket-book/blob/master/code/shared/utility.rkt" "utility.rkt"] 中，日后的例子中可能还会看到这些函数的倩影。

如果你已经将 @rh["https://github.com/tyrchen/racket-book" "tyrchen/racket-book"] 这个 repo 克隆到了本地，那么你可以在 @bold{code} 目录下运行：

@code-hl[#:lang "bash"]{
$ racket my-2048.rkt
}

稍待片刻，游戏就会开始运行。

@section[#:tag "practical-2048-more"]{课后作业}

这个游戏和原版游戏相比，山寨度也就达到了70%。目前还有以下遗憾：

@itemlist[
@item{没有记录和显示用户的得分，以及走过的步数}
@item{没有动画效果，游戏的体验比较生硬}
@item{没有计时，无法提供更多的玩法}
@item{没有音效，略嫌枯燥}
]

这些遗憾就交由感兴趣的读者完成。