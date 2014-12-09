#lang scribble/doc

@(require (for-label racket)
          scribble/manual
          "../../util/common.rkt")

@title[#:tag "practical-racket-editor"]{找个称手的编辑器}

@(drr) 本身就是一个很棒的编辑器，可以用 @bold{ctrl+/} 自动补齐。在其右上角还有函数原型的提示，当你光标移动到某个函数上时，就会显示，非常方便。

@image["assets/images/drracket-editor.jpg" #:style "cover"]

如果已经是Vim或者Emacs的用户，那么可以安装 @rh["https://github.com/wlangstroth/vim-racket" "对应的插件"]。由于Emacs本身和Lisp有着千丝万缕的联系，建议如果是撰写Racket代码，可以优先考虑Emacs。我自己比较喜欢的Emacs配置是 @rh["https://github.com/purcell/emacs.d" "purcell大神的配置"]，你可以按照提示安装，打开Emacs后使用 @bold{M-x}（注：alt+x），输入 @bold{package-install}，回车后，输入 @bold{racket-mode} 或者 @bold{geiser} 就可以安装Racket的插件了。当然，你也可以通过下载安装 @rh["https://github.com/greghendershott/racket-mode" "racket-mode"] 或者 @rh["http://www.nongnu.org/geiser/geiser_3.html" "Geiser"]。更多详情，可以参考 @rdoc-guide{Emacs}。

@image["assets/images/emacs.jpg" #:style "cover"]

此外，sublime-text也是一个不错的文本编辑工具，它也提供了 @rh["https://sublime.wbond.net/packages/Racket" "对应的插件"]。

@image["assets/images/sublime.jpg" #:style "cover"]