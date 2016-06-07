//
//  Person.m
//  LSOperationAndOperationQueueDemo
//
//  Created by linsir on 16/6/7.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)running:(NSString *)name {
    NSLog(@"---------- baby running, name is %@, mainThread:%@, currentThread:%@", name, [NSThread mainThread], [NSThread currentThread]);
}

@end
