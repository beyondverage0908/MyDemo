//
//  IHFAlertAction.h
//  IHFAlertController
//
//  Created by linsir on 16/5/27.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    IHFAlertActionStyleDefault,
    IHFAlertActionStyleCancle,
    IHFAlertActionStyleConfirm
} IHFAlertActionStyle;

@interface IHFAlertAction : UIButton

- (instancetype)initWithTitle:(NSString *)title style:(IHFAlertActionStyle)style action:(void (^)())action;

@end
