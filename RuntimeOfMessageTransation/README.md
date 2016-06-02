# Runtime - 消息转发

## 引言

Objective-C作为iOS开发的主力语言(目前)，将来必然被Swift替代。我们都知道在OC中我们是使用一对方括号`[receiver message]`进行消息的发送。曾经，以为这种方式和C语言中的函数调用是一样的，在编译阶段就已经确定方法的调用。现在知道OC中的`[receiver message]`在编译阶段仅仅是将方法调用翻译成`objc_msgSend(receiver, selector)`.如果消息中带有参数，则翻译成`objc_msgSend(receiver, selector, arg1, arg2, arg3, ...)`


> Objective-C是一门动态语言，所以它总是想办法把一些决定工作从编译连接推迟到运行时。


## 正文

**消息转发**

我们先从一个错误开始。为了方便，我新建了一个Person类，当一个类在Person.h中声明了方法签名，但是没有在对应的Person.m文件中得到实现，此时调用该方法则会得到如下的错误信息：

	2016-06-02 10:15:27.242 RuntimeTest[20331:1030929] *** Terminating app due to 
	uncaught exception 'NSInvalidArgumentException', reason: '-[Person run]: 
	unrecognized selector sent to instance 0x7feea84ae9f0'
	
**这个错误就是由于在程序运行时没有在对应的.m中捕获到run方法而造成的**

*****************************

**其实当程序运行过程中，发现如上在.m文件没有实现对应的run方法时候，程序不回立刻就crash掉，它会转发消息，给了我们三套解决方案让我们补救程序。—— 这也是运行时的好处，在最危机的时刻还留有余地。接下来我们尽量用简单的语言来了解这三套消息转发的机制。**

## 第一套 

	+ (BOOL)resolveInstanceMethod:(SEL)sel;
	+ (BOOL)resolveClassMethod:(SEL)sel;

还是以前面的Person类为例子。当外部调用`run`方法时候，发现.m文件中没有方法的实现，此时会自动调用如上两个中的一个，此处调用的是`+ (BOOL)resolveInstanceMethod:(SEL)sel`. 注：实例方法调用第一个，类方法调用第二个。

我们重写上面的第一个方法：如下

	void run (id self, SEL _cmd){
    	NSLog(@"%@, %s", self, sel_getName(_cmd));
	}

	+ (BOOL)resolveInstanceMethod:(SEL)sel {
    	if (sel == @selector(run)) {
        	class_addMethod(self, sel, (IMP)run, "v@:");
        	return YES;
    	}
    	return [super resolveInstanceMethod:sel];
	}


上面方法的含义是，判断当前调用的方法是否是run方法，如果是就将我们新增的C语言run方法实现加入到当前类的方法列表之中，并返回yes。如果不是run方法，则调用父类实现。


## 第二套

	- (id)forwardingTargetForSelector:(SEL)aSelector;

官方的解释：
> The object to which unrecognized messages should first be directed.

我的理解：就是返回了一个可以响应未被识别的消息对象。

为了演示方便，我这里又新建了两个类，一个是XiaoMing类，一个是Dog类。


此时的场景是：XiaoMing.h中有一个rundog方法，但是XiaoMing.m中没有实现。但是Dog.m中有实现rundog的方法.

所以此时在XiaoMing.m中重写`- (id)forwardingTargetForSelector:(SEL)aSelector;`方法，返回Dog对象.如下：

	- (id)forwardingTargetForSelector:(SEL)aSelector {
    	return [[Dog alloc] init];
	}

Dog类的Dog.m文件

	- (void)rundog {
    	NSLog(@"dog running!!!!");
	}

此时会成功调用，并打印出`dog running`


## 第三套

	// Returns an NSMethodSignature object that contains a description of the method identified by a given selector.
	- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector; 
	
	// Overridden by subclasses to forward messages to other objects.
	- (void)forwardInvocation:(NSInvocation *)anInvocation; 

第一个方法：返回的是一个包含了方法所有信息的方法签名。记得最开始的那个错误信息么，就是由于这个方法没有返回一个和调用方法相匹配的方法签名。所以就会有这样的错误信息。

第二个方法：利用一个其它对象去响应消息(第一个方法返回来的方法签名)。

为了方便，我们注释掉XiaoMing.m中的第二套代码，重写如下：

	- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	    NSString *sel = NSStringFromSelector(aSelector);
	    
	    if ([sel isEqualToString:@"rundog"]) {
	        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
	    }
	    return [super methodSignatureForSelector:aSelector];
	}

	- (void)forwardInvocation:(NSInvocation *)anInvocation {
	    
	    SEL sel = anInvocation.selector;
	    
	    Dog *dog = [[Dog alloc] init];
	    
	    if ([dog respondsToSelector:sel]) {
	        [anInvocation invokeWithTarget:dog];
	    }
	}

成功的调用了Dog.m中的rundog方法。

![屏幕快照 2016-06-02 上午11.52.48.png](http://upload-images.jianshu.io/upload_images/1626952-12a1c16ca9a5bb35.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

关于生成方法签名做如下解释：

> 生成签名的类型"v@:"解释一下。每一个方法会默认隐藏两个参数，self、_cmd，self代表方法调用者，
> _cmd代表这个方法的SEL，签名类型就是用来描述这个方法的返回值、参数的，v代表返回值为void，@表示
> self，:表示_cmd。

## 总结

OC的Runtime除了消息转发，还有很多其它的有用的用法。之后博客希望能更深入的去了解OC Runtime的其它用法。

******************

非常感谢如下的文章，对我的帮助很大

[轻松学习之一－－Objective-C消息转发](http://www.jianshu.com/p/1bde36ad9938)

[Objective-C Runtime](http://yulingtianxia.com/blog/2014/11/05/objective-c-runtime/)

[Objective-C Runtime](http://tech.glowing.com/cn/objective-c-runtime/)