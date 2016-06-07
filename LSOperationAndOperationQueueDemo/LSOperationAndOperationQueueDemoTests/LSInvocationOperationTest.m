//
//  LSInvocationOperationTest.m
//  LSOperationAndOperationQueueDemo
//
//  Created by linsir on 16/6/7.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LSInvocationOperation.h"

@interface LSInvocationOperationTest : XCTestCase

@end

@implementation LSInvocationOperationTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    LSInvocationOperation *invoOpt = [LSInvocationOperation lsInvocationOperation];
    [invoOpt operationInvocationOperation];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
