//
//  ATransitionDelegate.m
//  FaceMosh
//
//  Created by DabKick Developer on 2/8/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import "ATransitionDelegate.h"

@implementation ATransitionDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[ATransitionAnimator alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[ATransitionAnimator alloc] init];
}

@end
