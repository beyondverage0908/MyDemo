//
//  LSBlockOperation.h
//  LSOperationAndOperationQueueDemo
//
//  Created by linsir on 16/6/7.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSBlockOperation : NSObject

+ (LSBlockOperation *)lsBlockOperation;

- (void)operatingLSBlockOperation;

@end
