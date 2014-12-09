#lang scribble/doc

@(require (for-label racket)
          scribble/manual
          "../../util/common.rkt")

@title[#:tag "begin-first-impression"]{Racket初印象}

在任何一个「正常」的编程语言中，最简单的求值看起来是这个样子的：

@code-hl[#:lang "python"]{
> 1 + 1 # python
> 2
}

在Racket的世界里，它被写成这样：

@rb[
(+ 1 1)
]

@margin-note{比如说在Python中，有这些关键字：
@verbatim[#:indent 0]{
and      del     from   not
as       elif    global or
assert   else    if     pass
break    except  import print
class    exec    in     raise
continue finally is     return
def      for     lambda try
while    with    yield}
关键字是语言本身内置的语法单元，每个关键字有自己的特定含义。}

Racket没有其它编程语言中的「关键字」（或者「保留字」的概念，语言的一切细节都可以由表达式 @bold{(...)} 完成，而表达式的基本构成单元是函数。Racket一个表达式大概是这个样子的：

@rb[
(function-name args1 ...)
]

函数的参数也可以是表达式。在上面的 @r[(+ 1 1)] 的例子中，@bold{+} 是一个函数，随后的两个 @bold{1} 是函数的参数。作为初学者，我们暂且先放下这些语法细节，写一些更多的代码耍耍吧。


@#reader scribble/comment-reader(racketblock
> (+ 2 4 6)
12
> (* 2 (+ 3 4))
14
> (expt 2 3) @; 指数函数
8
> (quotient 5 2) ; 求商
2
> (remainder 5 2) ; 求余
1
> (/ 35 7) ; 除
5
> (/ 4 6) ; 注意不能整除时，Racket用分数形式表示
2/3
> (exact->inexact 2/3)
; 转换成非精度实数，exact->inexact是一个函数，尽管看起来比较怪异
0.6666666666
> (* 1+2i 3+4i) ; 你还能手算虚数的乘除么？
> -5+10i
> (not #t) ; true/false用#t, #f表示，not是一个函数，表示「非」
#f
> (and -1 #f)
; 与函数，只要有参数不为#t，就返回#f。在and运算时，任何非#f的数据均相当于#t。
#f
> (and -1 2)
; 由于任何非#f的数据均相当于#t，所以and的结果在为#t时，会返回一个比#t更有意义的结果。
2
> (or -1 #f) ; 或函数
-1
> (or #f #f)
#f
> (xor #f 10) ; 异或
10
> (xor 10 20)
#f
> (> 1 2)
#f
> (< -1 0)
#t
> (= 10 20)
#f
> (string-append "你好" "，" "世界！")
; 在Racket中，字符串由""括起来，string-append可以将多个字符串连接起来
"你好，世界！"
> (format "~a，~a！" "你好" "世界") ; format可以格式化字符串
"你好，世界！"
> (printf "~a，~a！" "你好" "世界")
; printf用来输出字符串，注意format/printf的输出在DrRacket里的颜色的不同
你好，世界！
> (number->string 42) ; 数字转字符串
"42"
> (string->number "42") ; 字符串转数字
42
> (string->number "hello world")
false
> (string-length "hello world!") ; 求字符串长度
12
> (string-length "你好，世界！") ; Racket认识unicode，所以给出正确的长度
6
> (string? "你好") ; 测试参数是否为字符串
#t
> (number? "1") ; 测试参数是否为数字
#f
> (number? 1+2i)
#t
)

@margin-note{更多关于函数副作用的知识，请参考：@rh["http://zh.wikipedia.org/wiki/%E5%87%BD%E6%95%B0%E5%89%AF%E4%BD%9C%E7%94%A8" "Wikipedia：函数副作用"]}

在Racket中，绝大多数函数是没有副作用的，像 @r[printf] 这样的函数，除了有一个返回值以外，还向外设（这里是显示器）输出了字符，所以是有副作用的。注意 @r[printf] 的返回值并非一个字符串，我们通过下面的例子可以看到：

@#reader scribble/comment-reader(racketblock
> (string-append (format "~a，" "你好") "世界！")
"你好，世界！"
> (string-append (printf "~a，" "你好") "世界！")
; 会给出错误提示，告诉你 string-append 期待 string?，却等来了 #<void>
)

我们先把函数的副作用放在一边，在 @secref{advanced-racket} 那一章里面谈函数式编程时会讲到。

在上面的例子中，我们看到了两种「奇怪」的函数：@r[string->number] 这样中间用 @bold{->} 连接的，以及 @r[string?] 这样结尾为 @bold{?} 的函数。在Racket里，函数（或者变量）的命名非常宽松，不像其它语言那么死板，你甚至可以这么定义一个函数：

@rb[
> (define (-@&*123y!!!->!my_god? x) x)
> (-@&*123y!!!->!my_god? 10)
10
]

因此，在Racket里，人们往往使用一些约定俗成的符号来让函数的可读性更强，比如说判定系列的函数都统一用 @bold{?} 来结尾，
而转换系列的函数用 @bold{->} 来注明。

既然提到了函数和变量，我们来看看它们是如何定义的：

@rb[
> (define PI 3.1415926)
> (define hello "hello world")
> (format "~a:~a" hello PI)
"hello world:3.1415926"
]

使用 @r[define] 这个函数，我们可以定义一个变量，同样，我们也可以定义函数：

@#reader scribble/comment-reader(racketblock
> (define
    (circle-area r) ; 函数名 参数列表
    (* pi (sqr r))  ; 函数体
  )
> (circle-area 10)
314.1592653589793
)

我们之前讲到Racket中没有关键字，那么，@r[define define 10] 会有什么后果？

@#reader scribble/comment-reader(racketblock
> (define define 10)
> define
10
> (define a 10) ; 这里就会抛出异常，和执行 (10 a 10)的错误一样
> (10 a 10)
)

所以，当你对Racket掌握到一定程度后，你可以任意改造这门语言，让它成为你的私人禁脔。

对了，现在你已经把 @(drr) 的REPL解释器折腾坏了，不过没关系，运行一下 @(drr) 工具栏上的 @bold{Run}，一切又恢复如初了。
