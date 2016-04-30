//
//  ViewController.m
//  CornerRadius
//
//  Created by linsir on 16/4/28.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import "ViewController.h"
#import "DrCorner.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [self.view addSubview:label];
    
    [label dr_addCornerRadius:10 borderWidth:1.0 backgroundColor:[UIColor yellowColor] borderCorlor:[UIColor blueColor]];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    imageView.image = [UIImage imageNamed:@"beautiful_girl"];
    [self.view addSubview:imageView];

    [imageView dr_addCornerRadius:50];
    
    
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(100, 350, 100, 50)];
    textfield.placeholder = @"please input text";
    [self.view addSubview:textfield];
    
    [textfield dr_addCornerRadius:10 borderWidth:1.0 backgroundColor:[UIColor purpleColor] borderCorlor:[UIColor yellowColor]];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 450, 100, 50)];
    [self.view addSubview:view];
    
    [view dr_addCornerRadius:10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
