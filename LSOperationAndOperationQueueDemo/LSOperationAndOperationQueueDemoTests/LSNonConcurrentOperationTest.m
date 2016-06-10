//
//  LSNonConcurrentOperationTest.m
//  LSOperationAndOperationQueueDemo
//
//  Created by linsir on 16/6/9.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LSNonConcurrentOperation.h"

@interface LSNonConcurrentOperationTest : XCTestCase

@end

@implementation LSNonConcurrentOperationTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    LSNonConcurrentOperation *lsNonConcurrentOpt = [[LSNonConcurrentOperation alloc] initWithData:@"linsir-testing"];
    [lsNonConcurrentOpt setCompletionBlock:^{
        NSLog(@"completed with lsNonConcurrent");
    }];
    [lsNonConcurrentOpt start];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
