#lang scribble/doc

@(require (for-label racket)
          scribble/manual
          "../../util/common.rkt")

@title[#:tag "begin-install"]{安装和运行Racket}

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
