//
//  IHFAlertController.h
//  IHFAlertController
//
//  Created by linsir on 16/5/27.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IHFAlertAction.h"

typedef enum : NSUInteger {
    IHFAlertControllerStyleAlert,
    IHFAlertControllerStyleSheet
} IHFAlertControllerStyle;

@interface IHFAlertController : UIViewController

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image style:(IHFAlertControllerStyle)style;

- (void)addAction:(IHFAlertAction *)action;

@end
