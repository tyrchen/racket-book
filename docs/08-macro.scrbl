#lang scribble/doc

@(require (for-label racket)
          scribble/manual
          "../util/common.rkt")

@title[#:tag "macro"]{可爱的宏}

有时候，一门语言的语法让你感觉不爽，如果能够做点微调，该多好啊？比如说Racket提供了 @r[lambda] 和 @r[λ] 来生成匿名函数，lambda对我来说太长，而λ在我的mbp的键盘上无法直接输入（不像ƒ这样的字符可以 @bold{ALT+f} 输入，而是需要打开greek语言），如果我想用 @bold{ƒ} 定义函数，该怎么做？

在Python中我还还真不知道该怎么做，也没这么想过，C可以用宏替换：

@code-hl[#:lang "C"]{
#define ƒ λ
}

@margin-note{
所以在C里，很多时候宏的写法需要特殊处理，比如说：
@code-hl[#:lang "C"]{
#define MACRO(x, y) do { \
	// macro body		 \
while(0)
}
很丑很暴力。
}
}

不过我们知道，C的宏替换仅仅是预处理阶段基本不太考虑语法的情况下直接对目标做字符串替换，所以这么做有很多潜在的风险。那么Racket呢？能不能直接用 @r[define] 定义一下？

@re[
(define ƒ λ)
]

好吧，语法错误。@r[define] 实际上是把后一个表达式求值然后绑定到 @r[_ƒ] 变量上，而这里 @r[_λ] 不是个可求值的表达式。都说lisp强大到可以生成任何编程语言，那么这么个小问题该怎么解决？简单：

@re[
(define-syntax-rule (ƒ x y)
  (λ x y))
(define area (ƒ (r) (* pi r r)))
(area 10)
]

这就是我们这一章要讲的宏。