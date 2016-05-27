//
//  IHFAlertController.m
//  IHFAlertController
//
//  Created by linsir on 16/5/27.
//  Copyright © 2016年 linsir. All rights reserved.
//

#import "IHFAlertController.h"

@interface IHFAlertController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundMaskImageView;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *alertImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertImageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *alertTitle;
@property (weak, nonatomic) IBOutlet UILabel *alertMessage;
@property (weak, nonatomic) IBOutlet UIStackView *alertActionStackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertActionStackViewHeightConstraint;

@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

BOOL usingDaynamicAnimation = YES;

@implementation IHFAlertController

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message image:(UIImage *)image style:(IHFAlertControllerStyle)style {
    if ([super init]) {
        NSArray *nib = [self loadViewFromNib];
        
        if (nib) self.view = [nib lastObject];
        
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        _alertView.layer.cornerRadius = 8.0;
        
        if (image != nil) {
            _alertImageView.image = image;
        } else {
            _alertImageViewHeightConstraint.constant = 0;
        }
        
        _alertTitle.text = title;
        _alertMessage.text = message;
        
        if (style == IHFAlertControllerStyleAlert) _alertViewWidthConstraint.constant = 270;
        else if (style == IHFAlertControllerStyleSheet) _alertViewWidthConstraint.constant = [[UIScreen mainScreen] bounds].size.width - 60;
        
        [self setShadowForAlertView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)addAction:(IHFAlertAction *)alertAction {
    [_alertActionStackView addArrangedSubview:alertAction];
    
    NSInteger ALERT_ACTION_HEIGHT = [[UIScreen mainScreen] bounds].size.height < 568.0 ? 40 : 62;
    
    if ([_alertActionStackView.arrangedSubviews count] > 2) {
        _alertActionStackViewHeightConstraint.constant = ALERT_ACTION_HEIGHT * _alertActionStackView.arrangedSubviews.count;
        _alertActionStackView.axis = UILayoutConstraintAxisVertical;
    } else {
        _alertActionStackViewHeightConstraint.constant = ALERT_ACTION_HEIGHT;
        _alertActionStackView.axis = UILayoutConstraintAxisHorizontal;
    }
    
    [alertAction addTarget:self action:@selector(dismissAlertController:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dismissAlertController:(IHFAlertAction *)alertAction {
    [self animationDismissViewController];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)loadViewFromNib {
    NSBundle *podBundle = [NSBundle bundleForClass:self.classForCoder];
    NSURL *pathUrl = [podBundle URLForResource:@"IHFAlertController" withExtension:@"bundle"];
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"IHFAlertController" owner:self options:nil];
    if (pathUrl) {
        NSBundle *bundle = [NSBundle bundleWithURL:pathUrl];
        return [bundle loadNibNamed:@"IHFAlertController" owner:self options:nil];
    } else if (nib) {
        return nib;
    } else {
        assert(@"can't not create a path to load bundle");
    }
    return nil;
}

- (void)setShadowForAlertView {
    _alertView.layer.shadowOffset = CGSizeMake(0, 0);
    _alertView.layer.shadowRadius = 8;
    _alertView.layer.shadowOpacity = 0.5;
    _alertView.layer.masksToBounds = NO;
}

- (void)animationDismissViewController {
    if (usingDaynamicAnimation) {
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        
        UIGravityBehavior *gBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.alertView]];
        gBehavior.gravityDirection = CGVectorMake(0, 1);
        
        [_animator addBehavior:gBehavior];
        
        UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.alertView]];
        [itemBehavior addAngularVelocity:3.14 * 4 forItem:self.alertView];
        
        [_animator addBehavior:itemBehavior];
    }
}

@end
