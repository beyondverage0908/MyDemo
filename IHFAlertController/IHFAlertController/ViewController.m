//
//  ViewController.m
//  IHFAlertController
//
//  Created by linsir on 16/5/27.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import "ViewController.h"
#import "IHFAlertController.h"
#import "IHFAlertAction.h"

@interface ViewController ()

@end

#define alert_message @"我是message我是message我是message我是message我是message"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)alertTouch:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"cartoon"];
    IHFAlertController *alertController = [[IHFAlertController alloc] initWithTitle:@"提示" message:alert_message image:image style:IHFAlertControllerStyleAlert];
    
    IHFAlertAction *cancleAction = [[IHFAlertAction alloc] initWithTitle:@"取消" style:IHFAlertActionStyleCancle action:^{
        NSLog(@"取消");
    }];
    [alertController addAction:cancleAction];
    
    IHFAlertAction *confirmAction = [[IHFAlertAction alloc] initWithTitle:@"确定" style:IHFAlertActionStyleConfirm action:^{
        NSLog(@"确定");
    }];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (IBAction)sheetTouch:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"beautiful_girl"];
    IHFAlertController *sheetController = [[IHFAlertController alloc] initWithTitle:@"提示" message:alert_message image:image style:IHFAlertControllerStyleSheet];
    
    IHFAlertAction *cancleAction = [[IHFAlertAction alloc] initWithTitle:@"取消" style:IHFAlertActionStyleCancle action:^{
        NSLog(@"取消");
    }];
    [sheetController addAction:cancleAction];
    
    IHFAlertAction *confirm = [[IHFAlertAction alloc] initWithTitle:@"确认" style:IHFAlertActionStyleConfirm action:^{
        NSLog(@"确认");
    }];
    [sheetController addAction:confirm];
    
    [self presentViewController:sheetController animated:YES completion:nil];
}

- (IBAction)ThreeAlertTouch:(id)sender {
    
    IHFAlertController *alertController = [[IHFAlertController alloc] initWithTitle:@"提示" message:alert_message image:[UIImage imageNamed:@"beautiful_girl"] style:IHFAlertControllerStyleAlert];
    
    IHFAlertAction *yourGoodAction = [[IHFAlertAction alloc] initWithTitle:@"你好" style:IHFAlertActionStyleCancle action:^{
        NSLog(@"你好");
    }];
    [alertController addAction:yourGoodAction];
    
    IHFAlertAction *meGoodAction = [[IHFAlertAction alloc] initWithTitle:@"我好" style:IHFAlertActionStyleDefault action:^{
        NSLog(@"我好");
    }];
    [alertController addAction:meGoodAction];
    
    IHFAlertAction *allGoodAction = [[IHFAlertAction alloc] initWithTitle:@"大家好" style:IHFAlertActionStyleConfirm action:^{
        NSLog(@"大家好");
    }];
    [alertController addAction:allGoodAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)ThreeSheetTouch:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"beauty"];
    IHFAlertController *sheetController = [[IHFAlertController alloc] initWithTitle:@"提示" message:alert_message image:image style:IHFAlertControllerStyleSheet];
    
    IHFAlertAction *cancleAction = [[IHFAlertAction alloc] initWithTitle:@"取消" style:IHFAlertActionStyleCancle action:^{
        NSLog(@"取消");
    }];
    [sheetController addAction:cancleAction];
    
    IHFAlertAction *delete = [[IHFAlertAction alloc] initWithTitle:@"删除" style:IHFAlertActionStyleCancle action:^{
        NSLog(@"删除");
    }];
    [sheetController addAction:delete];
    
    IHFAlertAction *confirm = [[IHFAlertAction alloc] initWithTitle:@"确认" style:IHFAlertActionStyleConfirm action:^{
        NSLog(@"确认");
    }];
    [sheetController addAction:confirm];
    
    [self presentViewController:sheetController animated:YES completion:nil];
    
}

@end
