//
//  LSBlockOperationTest.m
//  LSOperationAndOperationQueueDemo
//
//  Created by linsir on 16/6/7.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LSBlockOperation.h"

@interface LSBlockOperationTest : XCTestCase

@end

@implementation LSBlockOperationTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// 进行单元测试
- (void)testExample {
    LSBlockOperation *bp = [LSBlockOperation lsBlockOperation];
    [bp operatingLSBlockOperation];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
