# 自定义实现UIAlertController

在iOS8之后，系统就将UIAlertView废除了。推荐使用UIAlertController。但是系统的alertController样式比较简单。

一次在微博中看到了一个自定义的UIAlertController的实现，便下载了源码。看了源码后自己实现了Objective-c的版本(原版本是Swift的)。

如下gif图:


![TwoAlertTouch.gif](http://upload-images.jianshu.io/upload_images/1626952-5e3a6ae4bc29f225.gif?imageMogr2/auto-orient/strip)


![
![Uploading ThreeAlertTouch_869806.gif . . .]](http://upload-images.jianshu.io/upload_images/1626952-b6f0713632ae692c.gif?imageMogr2/auto-orient/strip)



![ThreeAlertTouch.gif](http://upload-images.jianshu.io/upload_images/1626952-8d3d38694c229bcf.gif?imageMogr2/auto-orient/strip)




![ThreeSheetTouch.gif](http://upload-images.jianshu.io/upload_images/1626952-c441c323125c677d.gif?imageMogr2/auto-orient/strip)

***********************

简单的介绍下实现的思路，具体的可以查看我的[github源码](https://github.com/beyondverage0908/MyDemo/tree/master/IHFAlertController)

* 1.使用xib进行布局，主要有四部分，头部的图片UIImageView，中间的Title，及描述Message，下方的按钮部分。由于按钮采用的是线性布局，所以使用UIStackView作为按钮的容器。
* 2.合理的设置如UIImageView高度的约束(当没有图片的时候高度约束为0)，以及Title和描述Message对应的UILable的高度(为可变的)约束.
* 3.管理UIStackView，当按钮的个数达到一定的个数的时候使用纵向布局，少于2个(可自己定义)的时候使用横向布局.