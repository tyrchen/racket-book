#lang scribble/doc

@(require (for-label racket)
          scribble/manual
          "../../util/common.rkt")

@title[#:tag "practical-racket-crop"]{照片裁剪}

@margin-note{当然，osx本身就提供了 @r[_sips] 这个程序让你可以很方便地写个bash脚本（或者Python脚本）就能完成这个任务。}

现在进入正题。假设你正为你的孩子做一本画册，为了排版方便，里面的很多素材都需要正方形大小的800x800的图片（或者其它的什么尺寸），而你平日照下来的照片都不符合此要求，需要裁剪。当然，有一些工具可以帮助你完成这一要求，但如果你有成百上千张这样的照片需要处理，你就不得不考虑写个程序来完成这一任务了。

@margin-note{这里假设你依旧使用 @(drr)}

我们先来实验一下算法。使用你喜欢的编辑器创建一个新的文件，并将其存放在 @bold{~/study/racket/face.rkt} 下。接下来你需要准备一幅图片，我们随便下载一张 @rh["https://c1.staticflickr.com/9/8064/8257151659_fa29614b17_z.jpg" "无版权的照片"]，存为 @bold{face.jpg}，放在和你当前工作目录相同的地方，然后在编辑器中输入：


@re[
(require 2htdp/image
         racket/cmdline
         (only-in racket/draw read-bitmap))
(define perfect-woman (read-bitmap "face.jpg"))
perfect-woman
]

运行后，你会看到这幅图被加载出来了。

@image["assets/images/woman.jpg" #:style "cover"]

在Racket里，@r[crop] 可以用来裁剪图片，我们试验一下：

@re[
(crop 100 100 300 300 perfect-woman)
]

嗯，从图片的 @bold{(100, 100)} 起（左上角为 @bold{(0, 0)}），剪切宽300，长300的图片，正是我们需要的！了解了 @r[crop] 的运作方式，我们便可以尝试撰写第一个版本的函数：

@re[
(define (image-to-box1 img width)
  (define (f x y) (/ (- x y) 2))
  (let*-values ([(w) (image-width img)]
                [(h) (image-height img)]
                [(∂w ∂h) (if (> w h) (values (f w h) 0) (values 0 (f h w)))]
                [(∂w1 ∂h1) (values (+ ∂w (f w width)) (+ ∂h (f h width)))])
    (crop ∂w1 ∂h1 width width img)))
(image-to-box1 perfect-woman 400)
]

感觉还不错，是不是挺简单的？这里 @r[image-width] 和 @r[image-height] 用于获取图片的长和宽。算法很简单：如果图片的长宽不一致，先计算长或者宽额外需要略过的像素，然后再加上长宽分别要略过的像素。

接下来我们稍作修改，让其能接受一个文件：

@re[
(define (image-to-box img/file width)
  (define (f x y) (/ (- x y) 2))
  (let*-values ([(img) (if (string? img/file) (read-bitmap img/file) img/file)]
                [(w) (image-width img)]
                [(h) (image-height img)]
                [(∂w ∂h) (if (> w h) (values (f w h) 0) (values 0 (f h w)))]
                [(∂w1 ∂h1) (values (+ ∂w (f w width)) (+ ∂h (f h width)))])
    (crop ∂w1 ∂h1 width width img)))
(image-to-box "face.jpg" 400)
]

越来越接近我们的目标了。如果要让这段代码能在命令行下运行，接受用户传入的参数，比如说：

@code-hl[#:lang "bash"]{
$ racket face.rkt face.jpg 400
}

@margin-note{
注意第一行要声明语言：

@code-hl[#:lang "racket"]{
#lang racket
}

否则，会报错。
}
那么我们需要 @r[command-line] 的支持。它定义在：@r[racket/cmdline] 下。我们继续在编辑器里工作，最终完工的代码如下：

@rb[
(require 2htdp/image
         racket/cmdline
         (only-in racket/draw read-bitmap))

(define women (read-bitmap "face.jpg"))

(define (image-to-box img/file width)
  (define (f x y) (/ (- x y) 2))
  (let*-values ([(img) (if (string? img/file) (read-bitmap img/file) img/file)]
                [(w) (image-width img)]
                [(h) (image-height img)]
                [(∂w ∂h) (if (> w h) (values (f w h) 0) (values 0 (f h w)))]
                [(∂w1 ∂h1) (values (+ ∂w (f w width)) (+ ∂h (f h width)))])
    (crop ∂w1 ∂h1 width width img)))

(define (normalize-name filename width)
  (string-replace filename "." (format "-~a." width)))


(command-line
 #:args (filename width)
 (save-image (image-to-box filename (string->number width))
             (normalize-name filename width)))

]

试着在命令行下运行：

@code-hl[#:lang "bash"]{
$ racket face.rkt face.jpg 400
#t
}

我们发现，这个目录下生成了一个新的图片 @bold{face-400.jpg}。一切如我们所期望的那样。

目前这段代码有个问题，如果 @r[_width] 大于图片的长或者宽呢？显然会出错。这就留给读者自行修改吧。

细心的读者会发现，生成的图片大小怎么这么大？让我们看看为什么：

@code-hl[#:lang "bash"]{
$ file face-400.jpg
face-400.jpg: PNG image data, 400 x 400, 8-bit/color RGBA, non-interlaced
}

哈。@r[save-image] 生成的竟然是PNG。看来它没有根据扩展名进行判断处理。为什么 @r[save-image] 生成的是PNG呢？如果你打开 @bold{/Applications/Racket v6.1.1/share/pkgs/htdp-lib/2htdp/private} 里的 @bold{image-more.rkt}，会发现它最终调了 @r[(send bm save-file filename 'png)]，所以不管扩展名怎么设置，都只能生成PNG。建议读者可以修改或者重写这个函数，让它更符合自己的需要。