#lang scribble/manual

@(require (for-label racket)
          scribble/racket
          "util/common.rkt")



@title{@(book-name racket-book)}

@author[@(book-author racket-book)]


@image[@(book-cover racket-book) #:style "cover"]
@para[@smaller{@(book-copyright racket-book)}]
@para[@smaller[@(book-last-update racket-book)]]
@para{如果您发现本书的任何问题，请在 @hyperlink["https://github.com/tyrchen/racket-book/issues" "该书的github项目上提交问题单，多谢！"].}

这是一本关于racket的入门书。程序君在学习racket的过程中，发现racket的中文资料几乎为零，于是萌生了撰写这本书的想法。写这本书，某种程度上是出于私利，因为我一直认为最好的学习方法就是将自己学到的东西教授出去。在教授的过程中，自己能够学得更扎实。

于是，在学了racket也就一个周末之后，我开了这个repo，来记录和传授我学习racket的心得。撰写这本书，并不意味着我对racket的掌握有什么过人之处，恰恰相反，我和打算起步的你一样，不断挣扎于对这门语言的理解。

由于racket提供了 @hyperlink["http://docs.racket-lang.org/scribble/" "scribble"]这门专门用于撰写文档的语言，所以这本书也一反我的习惯，没用 markdown 或 asciidoc 撰写，而是全部用 scribble 完成。使用scribble的体验很好，在这个过程中，它也激励我使用racket去解决一些实际的问题。是的，如果你浏览这个repo的源码，你会发现，racket并非一个「花瓶」语言，只能用于去理解一些高深的宏编程或者函数式编程的思想，而是一门很实用的工具，可以做几乎任何通用语言（如python）能做的事情。

由于本书面向初学者，所以，如果你顺着读下来发现有些概念或者知识没有解释清楚，请向我提出，以便我修订。文中出现的任何问题，也欢迎大家提bug。

你可以通过 http://racket.tchen.me/ 访问本书的最新版本。

如果你觉得这本书对你有帮助，你可以扫描下面的二维码「打赏」程序君 ^_^

@image["assets/images/weixin10.jpg"]

@bold{@larger{贡献者}}

以下github用户为本书的疏漏贡献了很多，他们是（排名不分先后）：

longhua

@bold{@larger{资助者}}

以下微信用户资助了本书的撰写，他们是（排名不分先后）：

Z张明峰，海东，黄龙华，叶翔Timo，守望者，solu

@bold{@larger{版权声明}}

版权归作者所有。你可以免费阅读本书的在线电子版，也可以自行编译本书，在自己的私人电脑中阅读。本书的内容可以被引用，引用时请注明出处（github repo的链接及本书的在线地址）。

@; table-of-contents[]

@; -------------------------------------------------
@; include-section["docs/preface.scrbl"]
@include-section["docs/01-begin/index.scrbl"]
@include-section["docs/02-basics/index.scrbl"]
@include-section["docs/03-practical-programs/index.scrbl"]
@include-section["docs/04-advanced-racket/index.scrbl"]
@include-section["docs/05-plotting.scrbl"]
@include-section["docs/06-scribble.scrbl"]
@include-section["docs/07-package-system.scrbl"]
@include-section["docs/08-macro.scrbl"]
@include-section["docs/09-advanced-macro.scrbl"]
@include-section["docs/10-continuation.scrbl"]
@include-section["docs/11-server.scrbl"]
@include-section["docs/12-web.scrbl"]
@include-section["docs/13-real-world.scrbl"]
@include-section["docs/14-misc.scrbl"]
@include-section["docs/15-typed-racket.scrbl"]
@include-section["docs/16-further-readings.scrbl"]
@include-section["docs/postscript.scrbl"]