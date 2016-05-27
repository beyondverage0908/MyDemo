//
//  IHFAlertAction.m
//  IHFAlertController
//
//  Created by linsir on 16/5/27.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import "IHFAlertAction.h"

@interface IHFAlertAction ()

@property (nonatomic, copy) void (^action)();

@property (nonatomic, strong) UIImageView *sepatator;

@end

@implementation IHFAlertAction

- (instancetype)initWithTitle:(NSString *)title style:(IHFAlertActionStyle)style action:(void (^)())action {
    if (self = [super init]) {
        
        self.action = action;
        [self addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self setTitle:title forState:UIControlStateNormal];
        
        if (style == IHFAlertActionStyleDefault) {
            [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        } else if (style == IHFAlertActionStyleCancle) {
            [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else if (style == IHFAlertActionStyleConfirm) {
            [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }
        [self addSeparator];
    }
    return self;
}

- (void)tapped:(IHFAlertAction *)action {
    if (self.action) self.action();
}

- (void)addSeparator {
    self.sepatator = [[UIImageView alloc] init];
    [self addSubview:_sepatator];
    
    self.sepatator.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    self.sepatator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sepatator.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.sepatator.leadingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.leadingAnchor constant:8.0].active = YES;
    [self.sepatator.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor constant:-8.0].active = YES;
    [self.sepatator.heightAnchor constraintEqualToConstant:1.0].active = YES;
}

@end
