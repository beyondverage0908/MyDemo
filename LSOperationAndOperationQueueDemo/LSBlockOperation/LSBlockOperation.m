//
//  LSBlockOperation.m
//  LSOperationAndOperationQueueDemo
//
//  Created by linsir on 16/6/7.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import "LSBlockOperation.h"

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

@end
