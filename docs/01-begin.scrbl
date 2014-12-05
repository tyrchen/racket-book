#lang scribble/doc

@(require (for-label racket)
          scribble/manual
          "../util/common.rkt")

@title[#:tag "begin"]{开始}
@section[#:tag "begin-why"]{为什么是Racket}

@margin-note{Lisp/scheme的链接指向wikipedia，可能需要翻墙。建议读者在阅读本书的时候自行进入翻墙模式，以便减少不必要的麻烦}

想一句话说清楚什么是Racket很困难。Racket是 @rh["http://zh.wikipedia.org/wiki/Scheme" "Scheme"] 的一种方言，而Scheme又是 @rh["http://zh.wikipedia.org/zh-cn/LISP" "Lisp"] 的一种方言。作为一门古老的计算机语言，Lisp一直被许多人视为史上最非凡的编程语言。50多年前诞生的时候，它就带来了诸多革命性的创新，并且极大地影响了后来编程语言的发展，即使在一大批现代语言不断涌现的今天，Lisp的诸多特性仍然未被超越。Paul Graham在他的 @rh["http://book.douban.com/subject/6021440/" "「黑客与画家」"] 中写到Lisp诞生时，就包含了9种思想，而这九种思想至今在其它语言中还只实现了一部分：

@margin-note{本段内容引用自阮一峰的博文：@rh["http://www.ruanyifeng.com/blog/2010/10/why_lisp_is_superior.html" "为什么Lisp语言如此先进？（译文）"]}

@verbatim[#:indent 4]{
1. 条件结构（即"if-then-else"结构）。现在大家都觉得这是理所当然的，但是Fortran I就没有这个结构，它只有基于底层机器指令的goto结构。

2. 函数也是一种数据类型。在Lisp语言中，函数与整数或字符串一样，也属于数据类型的一种。它有自己的字面表示形式（literal representation），能够储存在变量中，也能当作参数传递。一种数据类型应该有的功能，它都有。

3. 递归。Lisp是第一种支持递归函数的高级语言。

4. 变量的动态类型。在Lisp语言中，所有变量实际上都是指针，所指向的值有类型之分，而变量本身没有。复制变量就相当于复制指针，而不是复制它们指向的数据。

5. 垃圾回收机制。

6. 程序由表达式（expression）组成。Lisp程序是一些表达式区块的集合，每个表达式都返回一个值。这与Fortran和大多数后来的语言都截然不同，它们的程序由表达式和语句（statement）组成。
区分表达式和语句，在Fortran I中是很自然的，因为它不支持语句嵌套。所以，如果你需要用数学式子计算一个值，那就只有用表达式返回这个值，没有其他语法结构可用，因为否则就无法处理这个值。
后来，新的编程语言支持区块结构（block），这种限制当然也就不存在了。但是为时已晚，表达式和语句的区分已经根深蒂固。它从Fortran扩散到Algol语言，接着又扩散到它们两者的后继语言。

7. 符号（symbol）类型。符号实际上是一种指针，指向储存在哈希表中的字符串。所以，比较两个符号是否相等，只要看它们的指针是否一样就行了，不用逐个字符地比较。

8. 代码使用符号和常量组成的树形表示法（notation）。

9. 无论什么时候，整个语言都是可用的。Lisp并不真正区分读取期、编译期和运行期。你可以在读取期编译或运行代码；也可以在编译期读取或运行代码；还可以在运行期读取或者编译代码。
}

作为Lisp的一种方言，Racket包含了几乎所有Lisp的优点，同时也提供了大量有用的库，降低初学者学习的成本 —— 值得一提的是，Racket在很多高校中都作为程序语言的入门语言用于教学。目前，整个Lisp社区被主流软件公司接受的程度还很低，而Lisp中最受人瞩目的当属Clojure和Racket。

@section[#:tag "begin-hello"]{从Hello world开始}

让计算机输出 "Hello world" 基本上是一门语言入门的第一步，我们来看看C语言如何实现：

@code-hl[#:lang "c"]{
#include <stdio.h>

int main(void)
{
    printf("Hello world!\n");
    return 0;
}
}

Java略微复杂一些：

@code-hl[#:lang "java"]{
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello world");
    }
}
}

而Python要简单得多：

@code-hl[#:lang "python"]{
print "Hello world!"
}

对于Racket来说，Hello world也仅仅需要一行代码：

@rb[
(displayln "Hello world!")
]

就语言的表现力来说，Racket和Python这样动态执行的语言明显占了上风。

@section[#:tag "begin-install"]{安装和运行Racket}

@margin-note{REPL: Read Evaluate Print Loop，详情见 @rh["http://zh.wikipedia.org/zh/%E8%AF%BB%E5%8F%96%EF%B9%A3%E6%B1%82%E5%80%BC%EF%B9%A3%E8%BE%93%E5%87%BA%E5%BE%AA%E7%8E%AF" "wikipedia：REPL"]}

作为一门解释型语言，Racket标配一个REPL解释器；除此之外，它还提供一个非常强大的IDE：DrRacket。下载和安装Racket非常简单，在 @rh["http://download.racket-lang.org/" "官方下载页面"] 选择合适的操作系统下的版本，按提示安装即可。对于OSX的用户，安装后的程序位于 @bold{/Applications/Racket v6.1.1/} 下，如果想在shell下直接运行 @r[racket] 或者 @(drr)，请将 @bold{/Applications/Racket v6.1.1/bin} 添加到 @r[$PATH] 下。

之后，可以运行 @(drr)：

@code-hl[#:lang "shell"]{
	$ drracket
}

你将会看到如下界面：

@image["assets/images/drracket.png" #:scale 0.8]

正如你所看到的那样，@(drr) 允许你使用任意对象，包括图片。

@(drr) 的窗口分为上下两个部分，上部是一个编辑器，用来输入大段代码的，可以通过点击工具栏上的 @bold{Run} 查看运行结果；下部是一个REPL解释器，可以即时输入代码，查看运行结果。当点击 @bold{Run} 时，REPL解释器将会刷新并显示编辑器里面代码的运行结果。本章接下来的小节，如无特殊说明，代码都是输入在 @(drr) 里的REPL解释器中。

@section[#:tag "begin-first-impression"]{Racket初印象}

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

@section[#:tag "begin-play"]{与Racket共舞}

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

@item{@rh["http://docs.racket-lang.org/teachpack/2htdpimage.html" "2htdp/image的文档（内有很多例子）"]}

]
