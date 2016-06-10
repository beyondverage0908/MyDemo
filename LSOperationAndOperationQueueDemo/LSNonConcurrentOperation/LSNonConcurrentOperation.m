//
//  LSNonConcurrentOperation.m
//  LSOperationAndOperationQueueDemo
//
//  Created by linsir on 16/6/9.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import "LSNonConcurrentOperation.h"

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
//- (void)main {
//    @try {
//        
//        NSLog(@"-------- LSNonConcurrentOperation - data:%@, mainThread:%@, currentThread:%@", self.data, [NSThread mainThread], [NSThread currentThread]);
//        sleep(2);
//        NSLog(@"-------- finish executed %@", NSStringFromSelector(_cmd));
//        
//    } @catch (NSException *exception) {
//        
//        NSLog(@"------- LSNonConcurrentOperation exception - %@", exception);
//        
//    } @finally {
//        
//    }
//}


// 该主方法支持Operation的取消操作
- (void)main {
    // 执行之前，检查是否取消Operation
    if (self.isCancelled) return;

    @try {
        
        NSLog(@"-------- LSNonConcurrentOperation - data:%@, mainThread:%@, currentThread:%@", self.data, [NSThread mainThread], [NSThread currentThread]);
        
        // 循环去检测执行逻辑过程中是否取消当前正在执行的Operation
        for (NSInteger i = 0; i < 5; i++) {
            
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



@end
