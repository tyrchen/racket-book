#lang scribble/doc

@(require (for-label racket)
          scribble/manual
          "../../util/common.rkt")

@title[#:tag "basics-grammar"]{Racket语法基础}

在Racket的世界里，一切皆为表达式。表达式可以返回一个值，或者一个列表（list）。而函数，则是构成表达式的基本要素。在这一章里，我们深入到Racket的语言细节，看看语言基本的库都提供了哪些必备的功能。

@section[#:tag "basics-grammer-set"]{变量绑定}

在Racket中，默认情况下，变量的值是不可变的，它只能绑定和重新绑定，如下面的例子：

@rb[
> (define x 1)
> (define x (+ x 1))
> x
2
]

@r[define] 是可以做全局绑定的，每次只能绑定一个变量。如果想一次绑定多个变量，可以使用 @r[let]：

@#reader scribble/comment-reader(racketblock
> (let ([a 3]
        [b (list-ref '(1 2 3 4) 3)])
    (sqr (+ a b)))
49
> #,(hl (or a b))  ;; 这里会抛出undefined异常
)

@r[let] 和 @r[define] 最大的不同是 @r[let] 是局部绑定，绑定的范围仅仅在其作用域之内，上面的例子中，@r[_a] 和 @r[_b] 出了 @r[let] 的作用域便不复存在了。

如果在绑定的过程中，需要互相引用，可以使用 @r[let*]。我们可以看下面的例子：

@re[
(let* ([x 10]
         [y (* x x)])
    (list x y))
]

有时候，你希望一次绑定多个值，可以使用 @r[let-values]：

@re[
(let-values ([(x y) (quotient/remainder 10 3)])
    (list y x))
]

它也有对应的 @r[let*-values] 形式。如下例：

@re[
(let*-values ([(pi r rr) (values 3.14159 10 (lambda (x) (* x x)))]
              [(perimeter area) (values (* 2 pi r) (* pi (rr r)))])
    (list area perimeter))
]

在这个例子里，我们看到 @r[let] 也能把一个变量和一个 @r[lambda] 函数进行绑定。我们看到，@r[_rr] 在使用的过程中，需要为其传入一个已经绑定好的变量，比如本例中的 @r[_r]。那么问题来了，如果函数的参数要延迟到 @r[let] 语句的 @r[_body] 里才能获得，那该怎么办？Racket提供了 @r[letrec]：

@re[
(letrec ([is-even? (lambda (n)
                       (or (zero? n)
                           (is-odd? (sub1 n))))]
         [is-odd? (lambda (n)
                      (and (not (zero? n))
                           (is-even? (sub1 n))))])
    (is-odd? 11))
]

在介绍它的功能之前，我们先看看同样的例子如果用 @r[let] 会有什么后果：

@re[
(let ([is-even? (lambda (n)
                       (or (zero? n)
                           (is-odd? (sub1 n))))]
           [is-odd? (lambda (n)
                      (and (not (zero? n))
                           (is-even? (sub1 n))))])
    (is-odd? 11))
]

这里会提示 @r[_is-even?] 没有定义。@r[letrec] 引入了一个语法层面的概念 @r[locations]，这个概念我们 @secref{advanced-racket} 那一章再讲。现在，我们只要这么理解：@r[letrec] 会先初始化每个要绑定的变量，为其放上一个占位符，等到引用的时候才真正开始计算。

当然，这种方法并不适用于任何场合：被引用的表达式不能是立即求值的表达式，而是延迟计算的，如上例中的 @r[lambda]。几种错误的 @r[letrec] 用法：

@re[
(letrec ([x (+ y 10)]
         [y (+ z 10)]
         [z 10])
    x)

(letrec ([x (y 10)]
         [y (z 10)]
         [z (lambda (a) (+ a 10))])
    x)
]

正确的用法是：

@re[
(letrec ([x (lambda () (+ (y) 10))]
         [y (lambda () (+ (z) 10))]
         [z (lambda () 10)])
    (x))
]

@margin-note{如果你不畏艰险，执意要攻克这些语句，那么可以访问 @rh["http://docs.racket-lang.org/reference/let.html" "这里"] 阅读Racket的官方文档。}

要完全理解 @r[letrec] 并非易事。就目前我们的能力而言，基本的 @r[let] 和 @r[let*] 在绝大多数场景下都足够用了。Racket还提供了其它一些绑定相关的语句：@r[letrec-values]，@r[let-syntax]，@r[letrec-syntax]，@r[let-syntaxes]，@r[letrec-syntaxes]，@r[letrec-syntaxes+values]。如果你看得头晕目眩，不知所以，那么恭喜你，咱俩感觉一样一样的！我们暂且跳过它们，稍稍休息一下，换换脑子，然后进入下一个环节。

@section[#:tag "basics-grammer-cond"]{条件语句}

@margin-note{注意：这里说条件语句其实是不严谨的，应该是条件表达式。一切皆为表达式，不是吗？}

在Racket里，条件语句也是函数。我们看最基本的条件语句：

@defproc[(if [test-expr (判断条件)]
             [true-expr (当条件为真时执行的表达式)]
             [false-expr (当条件为假时执行的表达式)])
         value]{
对于 @r[if] 表达式，最终执行的表达式的结果为整个表达式的结果。下面是几个例子：

@rb[
> (if (positive? -5) (error "doesn't get here") 2)
2
> (if (member 2 (list 1 2 3 4)) 1 (error "doesn't get here"))
1
> (if 'this-is-a-symbol "yes" "no")
"yes"
]
}

再次强调：判断条件只要不是 @r[#f]，任何其它值都等价于 @r[@t]。

对于其它常见的语言，条件语句可以有多个分支，比如Python里有 @r[elif]，使用如下：

@code-hl[#:lang "python"]{
if score > 90:
    return "A"
elif score > 70:
    return "B"
elif score > 60:
    return "Pass"
else:
    return "Not Pass"
}

Racket的 @r[if] 没有多个分支，但是可以通过嵌套来完成相同的功能：

@rb[
> (define score 55)
> (if (> score 90) "A"
                   (if (> score 70) "B"
                                    (if (> score 60) "Pass"
                                                     "Not Pass")))
"Not Pass"
]

@margin-note{Racket里的 @r[cond] 跟其它语言中的 @r[switch] 类似，可以类比一下。}

当然，同样的功能可以 @r[cond] 来完成。@r[cond] 的语法如下：

@specform/subs[#:literals (else =>)
               (cond cond-clause ...)
               ([cond-clause [test-expr then-body ...+]
                             [else then-body ...+]
                             [test-expr => proc-expr]
                             [test-expr]])]

在 @r[cond] 表达式中，每个 @r[_test-expr] 都按定义的顺序去求值并判断。如果判断结果为 @r[#f]，对应的 @r[_body]s 会被忽略，下一个 @r[_test-expr] 会被求值并判断；在这个过程中，只要任何一个计算到的 @r[_test-expr] 的结果为 @r[#t]，其 @r[_body]s 就会得到执行，执行的结果作为 @r[cond] 整个表达式的返回值。

在 @r[cond] 表达式中，最后一个 @r[_test-expr] 可以被定义为 @r[else]。这样，如果前面的判断条件都测试失败，该 @r[_test-expr] 对应的 @r[_body]s 会作为缺省的行为得到执行。


上面的嵌套 @r[if] 的写法可以用 @r[cond] 表述得更加优雅一些：

@rb[
> (cond [(> score 90) "A"]
        [(> score 70) "B"]
        [(> score 60) "Pass"]
        [else "Not Pass"])
"Not Pass"
]

有一种特殊的 @r[_test-expr]，它可以将自己的结果传递给 @r[_proc-expr] 作为参数进行处理，定义如下：

@specform[[test-expr => proc-expr]]

@margin-note{注意 @r[=>] 只能用于 @r[cond] 表达式中。}

我们看一个例子：

@rb[
> (cond
   [(member 2 '(1 2 3 4)) => (lambda (l) (map sqr l))])
'(4 9 16)
> (member 2 '(1 2 3 4))
'(2 3 4)
]

通过这个例子，我们可以感受到条件表达式往往不返回 @r[#t]，而尽可能返回一个有意义的值的妙处了。

除了 @r[if] 和 @r[cond] 这样的标准条件表达式外，由于支持表达式的部分计算，@r[and] 和 @r[or] 也常常被用做条件表达式的简写。我们看一些例子：

@rb[
> (and)
#t
> (and 1)
1
> (and (values 1 2))
1
2
> (and #f (error "doesn't get here"))
#f
> (and #t 5)
5
> (or)
#f
> (or 1)
1
> (or (values 1 2))
1
2
> (or 5 (error "doesn't get here"))
5
> (or #f 5)
5
]

对于上面的根据 @r[score] 返回成绩评定的条件表达式，可以用 @r[or] 这么写：

@rb[
> (or (and (> score 90) "A")
      (and (> score 70) "B")
      (and (> score 60) "Pass")
      "Not Pass")
"Not Pass"
]

当然，这么写并不简单，读起来不如 @r[cond] 的形式舒服。考虑下面的嵌套 @r[if]，用 @r[and] 表达更漂亮一些：

@margin-note{这个例子的逻辑是，退出编辑器时，如果文件修改了，则弹窗询问用户是否保存，如果用户选择是，则存盘退出，否则都直接退出。}

@rb[
> (if (file-modified? f) (if (confirm-save?) (save-file)
                                            #f)
                        #f)
> (and (file-modified? f) (confirm-save?) (save-file))
]

@section[#:tag "basics-grammer-loop"]{循环与递归}

一般而言，函数式编程语言没有循环，只有递归，无论是什么形式的循环，其实都可以通过递归来完成。比如说这样一个循环：

@rb[
> (for ([i '(1 2 3)])
    (display i))
123
]

可以这样用递归来实现：

@rb[
> (define (for/recursive l f)
    (if (> (length l) 0) (let ([h (car l)]
                               [t (cdr l)])
                            (f h)
                            (for/recursive t f))
        (void)))
> (for/recursive '(1 2 3) display)
123
]

然而，@r[for] 这样的循环结构毕竟要简单清晰一些，因此，Racket提供了多种多样的 @r[for] 循环语句。我们先看一个例子：

@rb[
> (for ([i '(1 2 3 4)])
    (displayln (sqr i)))
1
4
9
16
]

@margin-note{一个表达式，如果没有返回值，又没有副作用，那么它存在的必要何在？}

注意 @r[for] 表达式返回值为 @r[void]，并且一般而言，它是有副作用的。@r[for] 有很多无副作用的变体，如下所示：

@deftogether[[
@defform[(for/list (clause ...) body ...+)]
@defform[(for/hash (clause ...) body ...+)]
@defform[(for/hasheq (clause ...) body ...+)]
@defform[(for/hasheqv (clause ...) body ...+)]
@defform[(for/vector (clause ...) body ...+)]
@defform[(for/flvector (clause ...) body ...+)]
@defform[(for/extflvector (clause ...) body ...+)]
@defform[(for/and (clause ...) body ...+)]
@defform[(for/or   (clause ...) body ...+)]
@defform[(for/first (clause ...) body ...+)]
@defform[(for/last (clause ...) body ...+)]
@defform[(for/sum (clause ...) body ...+)]
@defform[(for/product (clause ...) body ...+)]
@defform[(for*/list (clause ...) body ...+)]
@defform[(for*/hash (clause ...) body ...+)]
@defform[(for*/hasheq (clause ...) body ...+)]
@defform[(for*/hasheqv (clause ...) body ...+)]
@defform[(for*/vector (clause ...) body ...+)]
@defform[(for*/flvector (clause ...) body ...+)]
@defform[(for*/extflvector (clause ...) body ...+)]
@defform[(for*/and (clause ...) body ...+)]
@defform[(for*/or   (clause ...) body ...+)]
@defform[(for*/first (clause ...) body ...+)]
@defform[(for*/last (clause ...) body ...+)]
@defform[(for*/sum (clause ...) body ...+)]
@defform[(for*/product (clause ...) body ...+)]
]]{
这里的 @r[_clause] 是 @r[[id sequence-expr]]，可以有多个，当存在多个 @r[_clause] 时，不带 @bold{*} 的版本会同时处理每个 @r[_sequence-expr]，并且，只要任何一个 @r[_sequence-expr] 结束，循环便结束；而带 @bold{*} 的版本会嵌套处理每个 @r[_sequence-expr]，直至全部可能都被穷尽。@r[_for] 表达式的返回值根据 @bold{/} 后面的symbol确定，比如说 @r[for/list] 的返回值是一个列表。
}

我们通过一些例子来具体看看这些循环表达式如何使用：

@rb[
> (for/list ([i '(1 2 3 4)]
             [name '("goodbye" "farewell" "so long")])
    (format "~a: ~a" i name))
'("1: goodbye" "2: farewell" "3: so long")
> (#,(hl for*/list) ([i '(1 2 3 4)]
             [name '("goodbye" "farewell" "so long")])
    (format "~a: ~a" i name))
'("1: goodbye"
  "1: farewell"
  "1: so long"
  "2: goodbye"
  "2: farewell"
  "2: so long"
  "3: goodbye"
  "3: farewell"
  "3: so long"
  "4: goodbye"
  "4: farewell"
  "4: so long")
]

注意看 @r[for*/list] 和 @r[for/list] 的区别。再看几个例子：

@rb[
> (for/product ([i '(1 2 3)]
                [j '(4 5 6)])
    (* i j))
720
> (for/sum ([i '(1 2 3)]
            [j '(4 5 6)])
    (* i j))
32
> (for/last ([i '(1 2 3)]
             [j '(4 5 6)])
    (* i j))
18
> (for/hash ([i '(1 2 3)]
             [j '(4 5 6)])
    (values i j))
'#hash((1 . 4) (2 . 5) (3 . 6))
]

@r[for] 循环还有很多内置的函数来获取循环中的值，比如 @r[in-range]，@r[in-naturals] 等等，如下例所示：

@rb[
> (for/sum ([i 10]) (sqr i))
285
> (for/list ([i (in-range 10)])
    (sqr i))
'(0 1 4 9 16 25 36 49 64 81)
> (for ([i (in-naturals)])
    (if (= i 10)
        (error "too much!")
        (display i)))
0123456789
too much!
]

我们可以看到，@r[in-naturals] 会生成一个无穷的序列，除非在 @r[_body] 中抛出异常，否则循环无法停止。这个特性可以用于类似其它语言的 @r[_while(1)] 这样的无限循环。

很多时候，循环不是必须的。Racket是一门函数式编程语言，有很多优秀的用于处理 @r[_sequence] 的函数，如 @r[map]，@r[filter]，@r[foldl] 等等，当你打算使用 @r[for] 循环时，先考虑一下这些函数是否可以使用。

更多有关 @r[for] 循环的细节，请参考 @rh["http://docs.racket-lang.org/guide/for.html" "Racket官方文档：iterations and comprehensions"]。