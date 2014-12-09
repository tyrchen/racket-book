#lang scribble/doc

@(require (for-label racket)
          scribble/manual
          "../../util/common.rkt")

@title[#:tag "basics-data"]{基本数据结构}

了解了最基本的控制结构，我们来看看Racket提供了哪些数据结构。@rh["http://en.wikipedia.org/wiki/Algorithms_%2B_Data_Structures_%3D_Programs" "Wirth 说过"]：

@verbatim[#:indent 4]{
Program = Algorithm + Data Structure
}

掌握了一门语言支持的数据结构，你就已经掌握了这门语言的一半的精髓。

@section[#:tag "basics-data-number"]{数值}

数值是Racket的最基本的类型。Racket支持的数值类型非常丰富：整数，浮点数（实数），虚数，有理数（分数）等等。我们看一些例子：

@re[
1234
(+ 1000000000000000000000000000000000000000000000000000000000000 4321)
1.41414141414141414141414141414141414141414141414141414141414
1414141414141414141414141414.14141414141414141414141414141414
(/ 2 3)
(/ 2 3.0)
1+2i

(number? 1.4)
(number? (/ 9 10))
(number? 1+2i)
(number? 1.4e27)

(exact->inexact 1/3)
(floor 1.9)
(ceiling 1.01)
(round 1.5)
#b111
#o777
#xdeadbeef
]

最后的三个例子里展示了Racket可以通过 @bold{#b}，@bold{#o}，@bold{#x} 来定义二进制，八进制和十六进制的数字。

@section[#:tag "basics-data-string"]{string}

字符串是基本上所有语言的标配，Racket也不例外。我们看看这些例子：

@re[
(string? "Hello world")
(string #\R #\a #\c #\k #\e #\t)
(make-string 10 #\c)
(string-length "Tyr Chen")
(string-ref "Apple" 3)
(substring "Less is more" 5 7)
(string-append "Hello" " " "world!")
(string->list "Eternal")
(list->string '(#\R #\o #\m #\e))
]

Racket还提供了一个关于 @r[string] 的库 @r[racket/string]，可以 @r[(require racket/string)] 后使用：

@re[
(string-join '["this" "is" "my" "best" "part"])
(string-join '("随身衣物" "充电器" "洗漱用品") "，"
               #:before-first "打包清单："
               #:before-last "和"
               #:after-last "等等。")
(string-split "  foo bar  baz \r\n\t")
(string-split "股票，开盘价，收盘价，最高价，最低价" "，")
(string-trim "  foo bar  baz \r\n\t")
(string-replace "股票，开盘价，收盘价，最高价，最低价" "，" "\n")
(string-replace "股票，开盘价，收盘价，最高价，最低价" "，" "\n" #:all? #f)
]

延伸阅读：更多和 @r[string] 相关的函数，可以参考 @rdoc-ref{strings}。

@section[#:tag "basics-data-list"]{列表}

@r[list] 是Lisp（LISt Processor）的精髓所在，其重要程度要比 @r[lambda] 更胜一筹。其实软件无非是一个处理输入输出的系统：一组输入经过这个系统的若干步骤，变成一组输出。「一组输入」是列表，「若干步骤」是列表，「一组输出」也是列表。所以程序打交道的对象大多是列表。

Lisp里最基本的操作是 @r[car]（读/ˈkɑr/） 和 @r[cdr]（读/ˈkʌdər/），他们是操作 @r[cons] 的原子操作。@r[cons] 也被称为pair，包含两个值，@r[car] 获取第一个值，@r[cdr] 获取第二个值。Racket继承了Lisp的这一特性：

@re[
(cons 'x 'y)
'(10 . 20)
(define pair (cons 10 20))
(car pair)
(cdr pair)
]

如果把第二个元素以后的内容看作一个列表，列表也可以被看作是 @r[cons]。我们做几个实验：

@re[
(cons 1 (cons 2 3))
(cons 1 (cons 2 (cons 3 '())))
(cons 1 (cons 2 empty))
(list 1 2 3)
(define l1 '(1 2 3 4 5 6 7 8))
(car l1)
(cdr l1)
(car (cdr l1))
(cadr l1)
(cdr (cdr l1))
(cddr l1)
(caddr l1)
(cddddr l1)
]

在Racket里，@r[_pair] 不是 @r[_list]，但 @r[_list] 是 @r[_pair]：

@re[
(pair? '(1 . 2))
(list? '(1 . 2))
(pair? '(1 2))
(list? '(1 2))
]

那么，@r[(cons 1 (cons 2 3))] 代表什么呢？为什么结果这么奇特，不是一个正常的列表？我们暂且放下这么疑问，留待以后再回答这个问题。

我们看看主要的列表操作的函数：

@re[
(define l (list 234 123 68 74 100 1 3 5 8 4 2))
(first l)
(rest l)
(take l 4)
(drop l 4)
(split-at l 4)
(takef l even?)
(dropf l even?)
(length l)
(list-ref l 0)
(list-tail l 4)
(append l '(0 1 2))
(reverse l)

(flatten (list '(1) '(2) '(3)))
(remove-duplicates '(1 2 3 2 4 5 1))

(filter (lambda (x) (> x 100)) l)
(partition (lambda (x) (< x (first l))) l)
]

@r[partition] 是个有趣的函数，它把列表按照你给定的条件分成两个列表：满足条件的；不满足条件的。嗯，让我们来利用这一函数，写个自己的 @r[_quicksort] 函数：

@re[
(define l (list 234 123 68 74 100 1 3 5 8 4 2))
(define (qsort1 l)
  (if (or (empty? l) (empty? (cdr l))) l
      (let*-values ([(key) (car l)]
                     [(small big)
                      (partition (lambda (x) (< x key))
                                 (cdr l))])
        (append (qsort1 small)
                (list key)
                (qsort1 big)))))

(qsort1 l)
]

对于给定的列表，我们拿出第一个元素µ，把剩下里的元素分成两份：小于µ的元素列表和大于µ的元素列表。然后对整个过程进行递归，直到所有元素排完。我们虽然实现了 @r[_quicksort] 的基本功能，但目前只能实现数字的排序，如果是其它数据结构呢？这个实现太不灵活。让我们稍稍修改一下，把比较的逻辑抽取出来：

@rb[
(define (qsort2 l #,(hl cmp))
  (if (or (empty? l) (empty? (cdr l))) l
      (let*-values ([(key) (car l)]
                     [(small big)
                      (partition (lambda (x)(#,(hl cmp) x key))
                                 (cdr l))])
        (append (qsort2 small #,(hl cmp))
                (list key)
                (qsort2 big #,(hl cmp))))))

> (qsort2 l <)
'(1 2 3 4 5 8 68 74 100 123 234)
> (qsort2 l >)
'(234 1 2 3 4 5 8 68 74 100 123)
> (qsort2 (list "hello" "world" "baby") string<?)
'("baby" "hello" "world")
]

如果你用过Python，一定知道其 @r[_sorted] 函数可以这样使用：

@code-hl[#:lang "python"]{
sorted([(1, "a"), (3, "b"), (2, "c")], key=lambda x: x[0])
[(1, 'a'), (2, 'c'), (3, 'b')]
}

我们自然想让自己的 @r[_qsort] 有这样的功能了。这也不难，我们需要把 @r[_key] 的获取抽象出来：

@rb[
(define (qsort3 l cmp #,(hl key))
  (if (or (empty? l) (empty? (cdr l))) l
      (let*-values ([(item) (car l)]
                    [(small big)
                     (partition (lambda (x) (cmp (#,(hl key) x) (#,(hl key) item)))
                                (cdr l))])
        (append (qsort3 small cmp #,(hl key))
                (list item)
                (qsort3 big cmp #,(hl key))))))

> (qsort3 (list '(3 "关上冰箱") '(1 "打开冰箱") '(2 "把大象塞到冰箱里")) < car)
'((1 "打开冰箱") (2 "把大象塞到冰箱里") (3 "关上冰箱"))
> (qsort3 l < (lambda (x) x))
'(1 2 3 4 5 8 68 74 100 123 234)
]

现在，功能是丰满了，但函数使用起来越来越麻烦，最初的 @r[(qsort1 l)] 变成了如今的 @r[(qsort3 l < (lambda (x) x))]，好不啰嗦。还好，Racket提供了函数的可选参数，我们再来修订一下：

@rb[
(define (qsort l [cmp <] [key (lambda (x) x)])
  (if (or (empty? l) (empty? (cdr l))) l
      (let*-values ([(item) (car l)]
                    [(small big)
                     (partition (lambda (x) (cmp (key x) (key item)))
                                (cdr l))])
        (append (qsort small cmp key)
                (list item)
                (qsort big cmp key)))))

> (qsort l)
'(1 2 3 4 5 8 68 74 100 123 234)
> (qsort l >)
'(234 123 100 74 68 8 5 4 3 2 1)
]

费了这么多口舌，其实Racket自己就提供了一个全功能的 @r[sort]：

@re[
(define l (list 234 123 68 74 100 1 3 5 8 4 2))
(sort l <)
(sort (list "hello" "world" "babay") string<?)
(sort (list '(3 "关上冰箱") '(1 "打开冰箱") '(2 "把大象塞到冰箱里")) #:key car <)
]

延伸阅读：更多和 @r[list] 相关的函数，可以参考 @rdoc-ref{pairs}。

@section[#:tag "basics-data-vector"]{vector}

@r[vector] 是固定长度的数组，@r[vector] 和 @r[list] 的优缺点可以想象一下C语言中的数组和带尾指针（及长度）的双向链表。我们通过代码先感受一下 @r[vector]：

@re[
(define v1 (vector 1 2 3))
v1
(equal? v1 #(1 2 3))
(vector? v1)
(vector->list v1)
(list->vector '(3 2 1))
(vector-ref v1 0)
(for ([i #(1 2 3)]) (display i))
(vector-take v1 1)
(vector-drop v1 1)
(vector-split-at v1 1)
(vector-length v1)
(vector-append v1 #(0 1 2))
]

可以看到，@r[vector] 的使用几乎和 @r[list] 一致，甚至函数的命名都很相似。

延伸阅读：更多和 @r[vector] 相关的函数，可以参考 @rdoc-ref{vectors}。

@section[#:tag "basics-data-hash"]{哈希表}

哈希表（@r[hash]）是目前几乎每种语言都会内置的数据结构。在Python里，它叫 @bold{dict}；在golang中，它叫 @bold{map}。哈希表是由一系列键值对（Key-value pair）组成的数据结构，具备和数组相同的 @bold{O(1)}存取能力。我们看看Racket中的哈希表如何定义的：

@re[
(define ht (make-hash))
]

@section[#:tag "basics-data-datum"]{datum}

@section[#:tag "basics-data-symbol"]{symbol}

在 @secref{basics-data-list} 的例子中，你也许会注意到列表的简写形式：相对于 @r[(list 1 2 3)]，@r['(1 2 3)] 能更简单地表现一个列表。那么，如果要用它定义嵌套的列表呢？该怎么定义？是 @r['('(1 2) '(3 4))] 么？让Racket直接告诉我们：

@re[
(list (list 1 2) (list 3 4))
]

咦！仅需要一个简单的 @bold{'}，我们就可以定义嵌套的列表。那么，@bold{'} 究竟是个什么东西？为什么它能够支持列表的嵌套？而不是我们想象的那样去定义？

@section[#:tag "basics-data-syntax"]{syntax}