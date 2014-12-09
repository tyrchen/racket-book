#lang scribble/doc

@(require (for-label racket)
          scribble/manual
          "../../util/common.rkt")

@title[#:tag "begin-hello"]{从Hello world开始}

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
