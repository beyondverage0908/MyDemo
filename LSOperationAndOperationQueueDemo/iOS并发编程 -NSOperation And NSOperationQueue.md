# iOS 并发编程 - Operation And NSOperation Queue

* 基本概念
	1. 术语
	2. 串行 vs 并发(concurrency)
	3. 同步 vs 异步
	4. 队列 vs 线程

* iOS的并发编程模型

* Operation Queues vs. Grand Central Dispatch (GCD)

* 关于Operation对象
	1. 并发的Operation 和非并发的Operation
	2. 创建NSBlockOperation对象 
	3. 创建NSInvocationOperation对象

* 自定义Operation对象
	1. 自定义的非并发NSOperation－不实现取消操作
	2. 自定义的非并发NSOperation－实现取消操作

* 定制Operation对象的执行行为
	1. 修改Operation在队列中的优先级
	2. 修改Operation执行任务线程的优先级
	3. 设置Completion Block

* 执行Operation对象
	1. 添加Operation到Operation Queue中
	2. 手动执行Operation
	3. 取消Operation
	4. 等待Operation执行完成
	5. 暂停和恢复Operation Queue

* 添加Operation Queue中Operation对象之间的依赖

* 总结

******************************

看过上面的结构预览，下面就开始我们这篇blog

## 术语

> Operation: The NSOperation class is an abstract class you use to encapsulate the code and data associated with a single task.

解释：Operation是一个抽象类，用于概括由一段代码和数据组成的任务。

> Operation Queue: The NSOperationQueue class regulates the execution of a set of NSOperation objects.

解释： NSOperationQueue用于规则的去执行一系列Operation。

## 串行 vs 并发

最简单的理解就是，串行和并发是用来修饰是否可以同时执行任务的数量的。串行设计只允许同一个时间段中只能一个任务在执行。并发设计在同一个时间段中，允许多个任务在逻辑上交织进行。(在iOS中，串行和并发一般用于描述队列)
**说个题外话，刚开始是将并发写成并行的，后觉得并发和并行的概念一直挥之不去，可以参考这篇，很赞奥——[还在疑惑并发和并行？](https://laike9m.com/blog/huan-zai-yi-huo-bing-fa-he-bing-xing,61/)**

## 同步 vs 异步

同步操作，只有当该操作执行完成返回后，才能执行其他代码，会出现等待，易造成线程阻塞。异步操作，不需要等到当前操作执行完，就可以返回，执行其他代码。(一般用于描述线程)

## 队列 vs 线程

队列用于存放Operation。在iOS中，队列分为串行队列和并发队列。使用NSOperationQueue时，我们不需要自己创建去创建线程，我们只需要自己去创建我们的任务(Operation)，将Operation放到队列中去。队列会负责去创建线程执行，执行完后，会销毁释放线程占用的资源。

*****************************

## iOS并发编程模型

对于一个APP，需要提高应用的性能，一般需要创建其它的线程去执行任务，在整个APP的声明周期内，我们需要自己手动去创建，销毁线程，以及暂停，开启线程。对于这创建一个这样的线程管理器，已经是非常复杂且艰巨的任务。但是苹果爸爸为开发者提供了两套更好的解决方案：**[NSOperation](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class/)**，**[Grand Central Dispatch (GCD) Reference](https://developer.apple.com/library/ios/documentation/Performance/Reference/GCD_libdispatch_Ref/)**，GCD的方式具体的本文暂不讨论。

使用NSOperationQueue 和 NSOperation的方式是苹果基于GCD再一次封装的一层，比GCD更加的灵活，而且是一种面向对象设计，更加适合开发人员。虽然相对于GCD会牺牲一些性能，但是我们可以对线程进行更多的操作，比如暂停，取消，添加Operation间的依赖。但是GCD如果暂停和取消线程操作则十分的麻烦。

## Operation Queues vs. Grand Central Dispatch (GCD)

> 简单来说，GCD 是苹果基于 C 语言开发的，一个用于多核编程的解决方案，主要用于优化应用程序以支持多核处理器以及其他对称多处理系统。而 Operation Queues 则是一个建立在 GCD 的基础之上的，面向对象的解决方案。它使用起来比 GCD 更加灵活，功能也更加强大。下面简单地介绍了 Operation Queues 和 GCD 各自的使用场景：

> Operation Queues ：相对 GCD 来说，使用 Operation Queues 会增加一点点额外的开销，但是我们却换来了非常强大的灵活性和功能，我们可以给 operation 之间添加依赖关系、取消一个正在执行的 operation 、暂停和恢复 operation queue 等；
> GCD ：则是一种更轻量级的，以 FIFO 的顺序执行并发任务的方式，使用 GCD 时我们并不关心任务的 调度情况，而让系统帮我们自动处理。但是 GCD 的短板也是非常明显的，比如我们想要给任务之间添加依赖关系、取消或者暂停一个正在执行的任务时就会变得非常棘手。

**上引用自[Operation Queues vs. Grand Central Dispatch (GCD)](http://blog.leichunfeng.com/blog/2015/07/29/ios-concurrency-programming-operation-queues/)**

## 关于Operation对象

`NSOperation`对象是一个抽象类，是不能直接创建对象的。但是它有两个子类——`NSBlockOperation`，`NSInvocationOperation`.通常情况下我们都可以直接使用这两个子类，创建可以并发的任务。

我们查看关于NSOperation.h的头文件，可以发现任意的operation对象都可以自行开始任务(start)，取消任务(cancle)，以及添加依赖(addDependency:)和移除依赖(removeDependency:).**关于依赖，有一种很好的一种开发思路**。在operation对象中有很多属性，可以用于检测当前任务的状态，如`isCancelled`:是否已经取消，`isFinished`:是否已经完成了任务。
![NSOperation](/Users/user/Desktop/屏幕快照 2016-06-07 下午8.29.04.png)

* **创建NSBlockOperation**

以下使用到的代码片段取自我的[LSOperationAndOperationQueueDemo](https://github.com/beyondverage0908/MyDemo/tree/master/LSOperationAndOperationQueueDemo)

`NSBlockOperation`顾名思义，是是用block来创建任务，主要有两种方式创建，一种是是用类方法，一种是创建operation对象，再添加任务。上代码：以下代码包括了两种block创建任务的方式。以及已经有任务的operation对象再添加任务。及直接添加任务到queue中。

	@implementation LSBlockOperation

	+ (LSBlockOperation *)lsBlockOperation {
	    return [[LSBlockOperation alloc] init];
	}
	
	- (void)operatingLSBlockOperation {
	    
	    NSBlockOperation *blockOpt1 = [NSBlockOperation blockOperationWithBlock:^{
	        NSLog(@"-------- blockOpt1, mainThread:%@, currentThread:%@", [NSThread mainThread], [NSThread currentThread]);
	    }];
	    /// 继续添加执行的block
	    [blockOpt1 addExecutionBlock:^{
	        NSLog(@"-------- blockOpt1 addExecutionBlock1 mainThread:%@, currentThread:%@", [NSThread mainThread], [NSThread currentThread]);
	    }];
	    
	    [blockOpt1 addExecutionBlock:^{
	        NSLog(@"-------- blockOpt1 addExecutionBlock2 mainThread:%@, currentThread:%@", [NSThread mainThread], [NSThread currentThread]);
	    }];
	    
	    NSBlockOperation *blockOpt2 = [[NSBlockOperation alloc] init];
	    [blockOpt2 addExecutionBlock:^{
	        NSLog(@"-------- blockOpt2 mainThread:%@, currentThread:%@", [NSThread mainThread], [NSThread currentThread]);
	    }];
	    
	    NSBlockOperation *blockOpt3 = [[NSBlockOperation alloc] init];
	    [blockOpt3 addExecutionBlock:^{
	        NSLog(@"-------- blockOpt3 mainThread:%@, currentThread:%@", [NSThread mainThread], [NSThread currentThread]);
	    }];
	    
	    NSBlockOperation *blockOpt4 = [NSBlockOperation blockOperationWithBlock:^{
	        NSLog(@"-------- blockOpt4 mainThread:%@, currentThread:%@", [NSThread mainThread], [NSThread currentThread]);
	    }];
	    
	    // 添加执行优先级 - 并不能保证执行顺序
	//    blockOpt2.queuePriority = NSOperationQueuePriorityVeryHigh;
	//    blockOpt4.queuePriority = NSOperationQueuePriorityHigh;
	    
	    /// 可以设置Operation之间的依赖关系 - 执行顺序3 2 1 4
	    [blockOpt2 addDependency:blockOpt3];
	    [blockOpt1 addDependency:blockOpt2];
	    [blockOpt4 addDependency:blockOpt1];
	    
	    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	    [queue addOperation:blockOpt1];
	    [queue addOperation:blockOpt2];
	    [queue addOperation:blockOpt3];
	    [queue addOperation:blockOpt4];
	    [queue addOperationWithBlock:^{
	        NSLog(@"-------- queue addOperationWithBlock1 mainThread:%@, currentThread:%@", [NSThread mainThread], [NSThread currentThread]);
	    }];
	    [queue addOperationWithBlock:^{
	        NSLog(@"-------- queue addOperationWithBlock2 mainThread:%@, currentThread:%@", [NSThread mainThread], [NSThread currentThread]);
	    }];
	}
	
* **创建NSInvocationOperation**

`NSInvocationOperation`是另一种可创建的operation对象的类。但是在Swift中已经被去掉了。`NSInvocationOperation`是一种可以非常灵活的创建任务的方式，主要是其中包含了一个`target`和`selector`。假设我们现在有一个任务，已经在其它的类中写好了，为了避免代码的重复，我们可以将当前的`target`指向为那个类对象，方法选择器指定为那个方法即可，如果有参数，可以在`NSInvocationOperation`创建中指定对应的Object(参数).

具体的可以看如下代码：[LSOperationAndOperationQueueDemo](https://github.com/beyondverage0908/MyDemo/tree/master/LSOperationAndOperationQueueDemo)

	@implementation LSInvocationOperation

	+ (LSInvocationOperation *)lsInvocationOperation {
	    return [[LSInvocationOperation alloc] init];
	}
	
	- (void)operationInvocationOperation {
	    
	    NSInvocationOperation *invoOpt1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invoOperated1) object:self];
	    NSInvocationOperation *invoOpt2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invoOperated2) object:self];
	    
	    // invocated other obj method
	    /// 可以执行其它类中方法，并且可以带参数
	    NSInvocationOperation *invoOpt4 = [[NSInvocationOperation alloc] initWithTarget:[[Person alloc] init] selector:@selector(running:) object:@"linsir"];
	    
	    // 设置优先级 － 并不能保证按指定顺序执行
	//    invoOpt1.queuePriority = NSOperationQueuePriorityVeryLow;
	//    invoOpt4.queuePriority = NSOperationQueuePriorityVeryLow;
	//    invoOpt2.queuePriority = NSOperationQueuePriorityHigh;
	    
	    // 设置依赖 - 线性执行
	    [invoOpt1 addDependency:invoOpt2];
	    [invoOpt2 addDependency:invoOpt4];
	    
	    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	    [queue addOperation:invoOpt1];
	    [queue addOperation:invoOpt2];
	    [queue addOperation:invoOpt4];
	}
	
	- (void)invoOperated1 {
	    NSLog(@"--------- invoOperated1, mainThread:%@, currentThread:%@", [NSThread mainThread],[NSThread currentThread]);
	}
	
	- (void)invoOperated2 {
	    NSLog(@"--------- invoOperated2, mainThread:%@, currentThread:%@", [NSThread mainThread],[NSThread currentThread]);
	}
	
	@end

## 自定义Operation对象

上文介绍了两种系统定义的NSOperation，通常情况下，我们可以直接使用，已经可以满足了大部分的需求。但是当系统的不能满足时候，我们就需要自定义我们自己的Operation对象。Operation对象可以分为并发的和非并发的两类。从实现角度上而言，非并发的更容易实现的多。因为非并发的Operation对象中的很多属性，它的父类已经做好了管理，我们只需要直接使用就可以了。**(通常情况下，实现多线程是由NSOperationQueue对象管理的，而不是NSOperation对象)**实现自定义的NSOperation对象，最少需要重写两个方法，一个是初始化init方法(传值)，一个是mian方法(主要的逻辑实现)。

* **自定义的非并发NSOperation－不实现取消操作**
	
	代码片段取自[LSOperationAndOperationQueueDemo](https://github.com/beyondverage0908/MyDemo/tree/master/LSOperationAndOperationQueueDemo)
	
		@interface LSNonConcurrentOperation ()

		@property (nonatomic, strong)id data;
		
		@end
		
		/**
		 自定义一个非并发的Operation，最少需要实现两个方法，一个初始化的init方法，另一个是mian方法，即主方法，逻辑的主要执行体。
		 */
		@implementation LSNonConcurrentOperation
		
		- (id)initWithData:(id)data {
		    self = [self init];
		    if (self) {
		        self.data = data;
		    }
		    return self;
		}
		
		// 该主方法不支持Operation的取消操作
		- (void)main {
		    @try {
		        
		        NSLog(@"-------- LSNonConcurrentOperation - data:%@, mainThread:%@, currentThread:%@", self.data, [NSThread mainThread], [NSThread currentThread]);
		        sleep(2);
		        NSLog(@"-------- finish executed %@", NSStringFromSelector(_cmd));
		        
		    } @catch (NSException *exception) {
		        
		        NSLog(@"------- LSNonConcurrentOperation exception - %@", exception);
		        
		    } @finally {
		        
		    }
		}

* **自定义的非并发NSOperation－实现取消操作**

		- (void)main {
		    // 执行之前，检查是否取消Operation
		    if (self.isCancelled) return;
		
		    @try {
		        NSLog(@"-------- LSNonConcurrentOperation - data:%@, mainThread:%@, currentThread:%@", self.data, [NSThread mainThread], [NSThread currentThread]);
		        
		        // 循环去检测执行逻辑过程中是否取消当前正在执行的Operation
		        for (NSInteger i = 0; i < 10000; i++) {
		            
		            NSLog(@"run loop -- %@", @(i + 1));
		            
		            if (self.isCancelled) return;
		            sleep(1);
		        }
		        NSLog(@"-------- finish executed %@", NSStringFromSelector(_cmd));
		    } @catch (NSException *exception) {
		        NSLog(@"------- LSNonConcurrentOperation exception - %@", exception);
		        
		    } @finally {
		        
		    }
		}

**由上可以知道，取消一个任务的执行，其实并不是立即就会取消，而是会在一个runloop中不断的去检查，判断isCancle的值，直到为yes时候，则取消了操作。所以，设置Operation为cancle的时候，至少需要一个runloop的时间才会结束操作。**

## 定制Operation对象的执行行为

* **修改Operation在队列中的优先级**

`NSOperation`对象在Queue中可以设置执行任务的优先级。我们可以通过设置operation对象的`setQueuePriority:`方法，改变任务在队列中的执行优先级。但是真正决定一个operation对象能否执行的是`isReady`，假设一个operation对象的在队列执行的优先级很高，另一个很低，但是高的operation对象的`isReady`是NO，也只会执行优先级低的operation任务。另一个影响任务在队列中执行顺序的是依赖(下文会讲到)，假设operation A依赖于operation B，所以一定先执行operation B,再执行operation A.

* **修改Operation执行任务线程的优先级**

从iOS4.0开始，我们可以设置operation中任务执行的线程优先级。从iOS4.0到iOS8.0，operation对象可以通过方法`setThreadPriority:`，这里的参数是一个double类型，范围是0.0到1.0，设置越高，理论上讲，线程执行的可能性就越高。但是从iOS8.0之后，这个方法已经被废弃了，使用`setQualityOfService:`代替，这里参数是一个预设的枚举值。

* **设置Completion Block**

同上，从iOS4.0开始，可以给每个operation对象设置一个主任务完成之后的完成回调`setCompletionBlock:`。所设置的block执行是在检测到operation的`isFinished`为YES后执行的。值得注意的是：**我们并不能保证block所在的线程一定在主线程，所以当我们需要对主线程上做一些操作的时候，我们应该切换线程到主线程中，如需在其他线程执行的某些操作，亦需要切换线程。**
> Therefore, you should not use this block to do any work that requires a very specific execution context. Instead, you should shunt that work to your application’s main thread or to the specific thread that is capable of doing it. 

## 执行Operation对象

对于执行一个Operation对象，一般的做法是将operation对象添加到一个队列中去，之后队列会根据当前系统的状态，以及内核的状态，自行的去执行operation中的任务。

	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	[queue addOperation:opt];
	
还有一种做法是，我们可以手动的执行一个operation对象，直接调用operation的`start`方法

	[opt start];
	
* **添加Operation到Operation Queue中**

将operation对象添加到queue中非常简单

首先创建一个队列：
	
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	
添加到队列的方法如下：

	- (void)addOperation:(NSOperation *)op;
	- (void)addOperations:(NSArray<NSOperation *> *)ops waitUntilFinished:(BOOL)wait NS_AVAILABLE(10_6, 4_0);
	- (void)addOperationWithBlock:(void (^)(void))block NS_AVAILABLE(10_6, 4_0);
	
第一个：添加意境存在的operation对象   
第二个：添加一组operation对象  
第三个：直接添加一个block到队列中，无需创建operation对象

* **手动执行Operation**

一般情况下，我们不需要手动的去执行一个operation对象，但如果需要，亦可，调用`start`方法。

	[opt start];
	
* **取消Operation**

当我们将一个operation对象添加到队列中之后，operation就已经被队列所拥有。我们可以在某个需要的时候调用operation对象的`cancle`方法，将operation出列。并且此时operation的`isFinished`也会为YES，所以此时依赖于它的operation就回继续得到执行。当然，我们可以直接调用队列的`cancelAllOperations`方法，取消了队列中所有的operation执行。

* **等待Operation执行完成**

等待一个Operation对象的执行完成，可以使用`waitUntilFinished`方法。但是应该注意到，等待一个任务执行完，会阻塞当前线程。所以我们绝不应该在主线程中做该操作，那样会带来非常差的体验。所以该操作应该使用辅助线程中。
我们也可以调用`NSOperationQueue`对象的`waitUntilAllOperationsAreFinished`方法，知道所有的任务都执行完成。

* **暂停和恢复Operation Queue**

通过设置队列的`setSuspended`,我们可以暂停一个队列中还没有开始执行的operation对象，对于已经开始的执行的任务，将继续执行。并且，已经暂停了队列，仍然可以继续添加operation对象，但是不会执行，只能等到从暂停(挂起)状态切换到非暂停状态。即设置`setSuspended`为NO。对于单个的operation，是没有暂停的概念的。

>When the value of this property is NO, the queue actively starts operations that are in the queue and ready to execute. Setting this property to YES prevents the queue from starting any queued operations, but already executing operations continue to execute. You may continue to add operations to a queue that is suspended but those operations are not scheduled for execution until you change this property to NO.


## 添加Operation Queue中Operation对象之间的依赖

在`NSOperationQueue`中，如果没有经过对operation添加依赖，都是使用并发处理的。但是在某些情况下，我们对任务的执行是有非常严格的规定的。即需要串行执行，此时，我们就需要对operation对象间进行添加依赖处理。

	- (void)addDependency:(NSOperation *)op;
	- (void)removeDependency:(NSOperation *)op;

第一个：添加依赖   
第二个：移除依赖

**依赖，是一种非常好用功能，在我们做项目(生活中)的时候，很多时候都一种依赖的概念。比如，用户需要上传一张照片到自己的空间，但是此时必须检测该用户是否已经登录。以前我们可能将两个逻辑写在一起，但是现在可以将成写成两个不同的operation，并设置它们的依赖。这样的好处非常可见的：  
第一点：它可以帮我们解藕，不同的逻辑分在不一样的对象中。  
第二点：某些常用的逻辑会经常用到，不需要一次次的重复，可读性增强，以后需要的时候直接调用，设置其依赖即可。比如检测是否登录**


## 总结

多线程执行任务看似十分的复杂，但是如果将复杂的任务交给`NSOperation` and `NSOperationQueue`，就可以简化它的难度，并且它似乎可以比我们自己处理的更好。
