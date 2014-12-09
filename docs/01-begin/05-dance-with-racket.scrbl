#lang scribble/doc

@(require (for-label racket)
          scribble/manual
          "../../util/common.rkt")

@title[#:tag "begin-play"]{与Racket共舞}

Racket内置了很多库，在了解更多的语法细节前，让我们轻松一下，体验体验Racket和 @(drr) 带来的无穷乐趣。

要想引入一个库中的可用函数，可以使用 @r[require]，比如接下来我们要体验的库：

@margin-note{2htdp意为：How To Develop Program, 2nd Edition，是Racket语言为教学而设计的一套库，其同名电子书可以在 @rh["http://www.ccs.neu.edu/home/matthias/HtDP2e/" "这里"] 阅读。}

@rb[
(require 2htdp/image)
]

引入 @r[image] 库后，我们接下来就要做一些有意思的事情了。


@rb[
> (define flag (rectangle 100 61.8 "solid" "red"))
> flag
#,(rectangle 100 61.8 "solid" "red")
> (define big-star (star 15 "solid" "yellow"))
> big-star
#,(star 15 "solid" "yellow")
> (overlay big-star flag)
#,(overlay (star 15 "solid" "yellow") (rectangle 100 61.8 "solid" "red"))
]

@r[rectangle] 和 @r[star] 用来生成图形，@r[overlay] 将一个图形盖到另一个上面。我们再看看这些例子：

@rb[
> (triangle 40 "solid" "tan")
#,(triangle 40 "solid" "tan")
> (rhombus 40 60 "outline" "magenta")
#,(rhombus 40 60 "outline" "magenta")
> (circle 20 "solid" "green")
#,(circle 20 "solid" "green")
> (regular-polygon 50 3 "outline" "red")
#,(regular-polygon 50 3 "outline" "red")
> (regular-polygon 40 4 "solid" "blue")
#,(regular-polygon 40 4 "solid" "blue")
> (regular-polygon 20 8 "solid" "red")
#,(regular-polygon 20 8 "solid" "red")
> (ellipse 50 30 "solid" "purple")
#,(ellipse 50 30 "solid" "purple")
> (overlay (ellipse 10 10 "solid" "red")
           (ellipse 20 20 "solid" "black")
           (ellipse 30 30 "solid" "red")
           (ellipse 40 40 "solid" "black")
           (ellipse 50 50 "solid" "red")
           (ellipse 60 60 "solid" "black"))
#,(overlay (ellipse 10 10 "solid" "red")
           (ellipse 20 20 "solid" "black")
           (ellipse 30 30 "solid" "red")
           (ellipse 40 40 "solid" "black")
           (ellipse 50 50 "solid" "red")
           (ellipse 60 60 "solid" "black"))
> (overlay/xy (rectangle 20 20 "solid" "red")
              10 10
              (rectangle 20 20 "solid" "black"))
#,(overlay/xy (rectangle 20 20 "solid" "red")
              10 10
              (rectangle 20 20 "solid" "black"))
]

这里大部分函数都很好理解，就不详细解释，最后的 @r[overlay/xy] 也是一个函数，Racket约定使用 @bold{/} 符号的函数代表其属于同一族，即 @r[overlay/xy] 是 @r[overlay] 的变体。

我们以一个动画来结束本小结的内容吧：

@rb[
> (radial-star 8 8 64 "solid" "darkslategray")
#,(radial-star 8 8 64 "solid" "darkslategray")
> (define (my-star x)
   (radial-star x 8 64 "solid" "darkslategray"))
> (my-star 20)
#,(radial-star 20 8 64 "solid" "darkslategray")
> (place-image (my-star 30) 75 75 (empty-scene 150 150))
#,(place-image (radial-star 30 8 64 "solid" "darkslategray")
               75 75 (empty-scene 150 150))
> (require 2htdp/universe)
> (animate (#,(hl lambda) (x)
           (place-image (my-star (+ x 2)) 75 75 (empty-scene 150 150))))
]

这里我们引入了 @r[lambda] 的概念，这是因为 @r[animate] 需要一个接受一个参数的函数作为其参数，所以我们需要给它一个函数。@r[lambda] 是用来声明一个匿名函数的，这里：

@rb[
> (animate (lambda (x)
           (place-image (my-star (+ x 2)) 75 75 (empty-scene 150 150))))
]

等价于：

@rb[
> (define (my-image x)
          (place-image (my-star (+ x 2)) 75 75 (empty-scene 150 150)))
> (animate my-image)
195
]

@r[animate] 会启动一个时钟，每秒产生 @r[28] 个tick，从 @r[0] 开始，每次tick加 @r[1]，然后把生成的值传给传入的函数。由于 @r[radial-star] 的角的个数至少是2，所以这里在定义 @r[my-image] 时，为传入的 @r[x] 加了 @r[2]。@r[animate] 会无限运行下去，直到你把打开的窗口关掉。此时，返回的结果就是走过的tick数。

我们可以重新定义一下 @r[my-star]，使这个动画运行一段时间后重头循环运行：

@rb[
> (define (my-star x)
          (radial-star (+ (remainder x 100) 2) 8 64 "solid" "darkslategray"))
]

你可以尝试重新运行动画，看看效果，然后自行理解其含义。:)

Racket的还提供了另一种动画方案 @r[big-bang]，可以这么使用：

@rb[
> (define (my-star x) (radial-star x 8 64 "solid" "blue"))
> (define (ten? x) (equal? x 10))
> (big-bang 100
            [to-draw my-star]
            [on-tick sub1]
            [stop-when ten?]
            [on-key (lambda (s ke) 100)])
]

它允许你设置一个初始条件（@r[100]），执行函数（@r[my-star])，tick发生时对初值的改变（@r[sub1])，以及何时停止动画（@r[ten?])。此外，当动画未停止之前，有键盘事件发生时（你敲了任意键），初始条件又恢复成 (@r[100])，见 @r[on-key] 里的 @r[lambda] 函数。

如果读完本节，对图形处理你还意犹未尽，可以读以下文档：
@itemlist[

@item{@rh["http://docs.racket-lang.org/quick/" "Quick: An Introduction to Racket with Pictures"]}

@item{@rh["http://www.ccs.neu.edu/home/matthias/HtDP2e/part_prologue.html" "Prologue of \"How to Design Programs 2nd\""]}

@item{@rdoc-teachpack{image}（内有很多例子）}

]
