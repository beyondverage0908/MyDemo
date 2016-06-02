//
//  XiaoMing.m
//  RuntimeTest
//
//  Created by linsir on 16/5/31.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import "XiaoMing.h"
#import "Dog.h"

@implementation XiaoMing

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    return [super resolveInstanceMethod:sel];
//}

//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    return [[Dog alloc] init];
//}

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

@end
