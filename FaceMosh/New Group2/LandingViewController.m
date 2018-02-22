//
//  LandingViewController.m
//  FaceMosh
//
//  Created by DabKick Developer on 2/14/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import "LandingViewController.h"
#import "ViewController.h"
#import "TransitionAnimator.h"
#import "TermsViewController.h"

@interface LandingViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic) ViewController* vc;

@end

@implementation LandingViewController

- (void)termsAction {
    TermsViewController* termsVC = [TermsViewController new];
    [self presentViewController:termsVC animated:true completion:nil];
}

- (void)initTermsLabel {
    UILabel* termsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    termsLabel.numberOfLines = 0;
    termsLabel.textAlignment = NSTextAlignmentCenter;
    termsLabel.textColor = [UIColor lightGrayColor];
    termsLabel.font = [UIFont systemFontOfSize:12];
    NSString* textValue = NSLocalizedString(@"Please accept the terms and conditions by tapping above.", nil);
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:textValue];
    [text addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:[textValue rangeOfString:@"terms and conditions"]];
    termsLabel.attributedText = text;
    [self.view addSubview:termsLabel];
    [termsLabel setUserInteractionEnabled:true];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(termsAction)];
    [termsLabel addGestureRecognizer:tap];
    termsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(suh)-[view(==66)]" options:0 metrics:@{@"suh":@(self.view.frame.size.height / 1.618)} views:@{@"view":termsLabel}]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:termsLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:200]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:termsLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:66]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:termsLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:1]];
}

- (ViewController*)vc {
    if (!_vc) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
        _vc = [storyboard instantiateViewControllerWithIdentifier:@"mainVC"];
    }
    return _vc;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [TransitionAnimator new];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [TransitionAnimator new];
}

- (IBAction)agreeAction:(id)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"✔︎" forKey:@"agree_button_tapped"];
    self.vc.transitioningDelegate = self;
    [self presentViewController:self.vc animated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initTermsLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
