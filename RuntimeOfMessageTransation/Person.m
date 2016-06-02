//
//  Person.m
//  RuntimeTest
//
//  Created by linsir on 16/5/31.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person

void run (id self, SEL _cmd){
    NSLog(@"%@, %s", self, sel_getName(_cmd));
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    if (sel == @selector(run)) {
        class_addMethod(self, sel, (IMP)run, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}


+ (BOOL)resolveClassMethod:(SEL)sel {
    return [super resolveClassMethod:sel];
}
@end
