//
//  LSInvocationOperation.m
//  LSOperationAndOperationQueueDemo
//
//  Created by linsir on 16/6/7.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import "LSInvocationOperation.h"
#import "Person.h"

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
    
    // 设置优先级 － 并不能保证按指定的顺序执行
//    invoOpt1.queuePriority = NSOperationQueuePriorityVeryLow;
//    invoOpt4.queuePriority = NSOperationQueuePriorityVeryLow;
//    invoOpt2.queuePriority = NSOperationQueuePriorityHigh;
    
//    [invoOpt2 setQualityOfService:NSQualityOfServiceUserInitiated];
    
    // 设置依赖 - 线性执行
    [invoOpt1 addDependency:invoOpt2];
    [invoOpt2 addDependency:invoOpt4];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:invoOpt1];
    [queue addOperation:invoOpt2];
    [queue addOperation:invoOpt4];
    
    [queue setSuspended:YES];
}

- (void)invoOperated1 {
    NSLog(@"--------- invoOperated1, mainThread:%@, currentThread:%@", [NSThread mainThread],[NSThread currentThread]);
}

- (void)invoOperated2 {
    NSLog(@"--------- invoOperated2, mainThread:%@, currentThread:%@", [NSThread mainThread],[NSThread currentThread]);
}

@end
