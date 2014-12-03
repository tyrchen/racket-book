#lang scribble/doc

@(require (for-label racket)
          scribble/manual
          "../util/common.rkt")

@title[#:tag "begin"]{开始}

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

@image["assets/images/drracket.png"]

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

Racket没有其它编程语言中的「关键字」（或者「保留字」的概念，语言的一切细节都可以由表达式 @bold{{...}} 完成，而表达式的基本构成单元是函数。Racket一个表达式大概是这个样子的：

@rb[
(function-name args1 ...)
]

函数的参数也可以是表达式。在上面的 @r[(+ 1 1)] 的例子中，@bold{+} 是一个函数，随后的两个 @bold{1} 是函数的参数。作为初学者，我们暂且先放下这些语法细节，写一些更多的代码耍耍吧。

@rb[
> (+ 2 4 6)
12
> (* 2 (+ 3 4))
14
> (expt 2 3) ; 指数函数
8
> (quotient 5 2) ; 求商
2
> (remainder 5 2) ; 求余
1
> (/ 35 7) ; 除
5
> (/ 4 6) ; 注意不能整除时，Racket用分数形式表示
2/3
> (exact->inexact 2/3) ; 转换成非精度实数，exact->inexact是一个函数，尽管看起来比较怪异
0.6666666666
> (* 1+2i 3+4i) ; 你还能手算虚数的乘除么？
> -5+10i
> (not #t) ; true/false用#t, #f表示，not是一个函数，表示「非」
#f
> (and -1 #f) ; 与函数，只要有参数不为#t，就返回#f。在and运算时，任何非#f的数据均相当于#t。
#f
> (and -1 2) ; 由于任何非#f的数据均相当于#t，所以and的结果在为#t时，会返回一个比#t更有意义的结果。
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
> (string-append "你好" "，" "世界！") ; 在Racket中，字符串由""括起来，string-append可以将多个字符串连接起来
"你好，世界！"
> (format "~a，~a！" "你好" "世界") ; format可以格式化字符串
"你好，世界！"
> (printf "~a，~a！" "你好" "世界") ; printf用来输出字符串，注意format/printf的输出在DrRacket里的颜色的不同
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
]

@margin-note{更多关于函数副作用的知识，请参考：@rh["http://zh.wikipedia.org/wiki/%E5%87%BD%E6%95%B0%E5%89%AF%E4%BD%9C%E7%94%A8" "Wikipedia：函数副作用"]}

在Racket中，绝大多数函数是没有副作用的，像 @r[printf] 这样的函数，除了有一个返回值以外，还向外设（这里是显示器）输出了字符，所以是有副作用的。注意 @r[printf] 的返回值并非一个字符串，我们通过下面的例子可以看到：

@rb[
> (string-append (format "~a，" "你好") "世界！")
"你好，世界！"
> (string-append (printf "~a，" "你好") "世界！") ; 会给出错误提示，告诉你 string-append 期待 string?，却等来了 #<void>
]

我们先把函数的副作用放在一边，在第四章里面谈函数式编程时会讲到。

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

@rb[
> (define 
    (circle-area r) ; 函数名 参数列表
    (* pi (sqr r))  ; 函数体
  )
> (circle-area 10)
314.1592653589793
]



@section[#:tag "begin-grammar"]{Racket语法基础}

在Racket的世界里，一切皆为表达式。表达式可以返回一个值，或者一个列表（list）。而函数，则是构成表达式的基本要素。和Racket里面

@code-hl[#:lang "racket"]{
;; 行注释
;;
#| 块注释
    #|
       可以嵌套
    |#
|#
}

