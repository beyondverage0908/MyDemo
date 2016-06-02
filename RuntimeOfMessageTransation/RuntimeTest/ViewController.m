//
//  ViewController.m
//  RuntimeTest
//
//  Created by linsir on 16/5/31.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "XiaoMing.h"

@interface ViewController ()

@property (nonatomic, strong)Person *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)personRun:(id)sender {
    self.person = [[Person alloc] init];
    
    [_person run];
}

- (IBAction)dogRun:(id)sender {
    
    XiaoMing *xiaoming = [[XiaoMing alloc] init];
    [xiaoming rundog];
    
}


@end
