//
//  TransitionAnimator.m
//  FaceMosh
//
//  Created by DabKick Developer on 2/14/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import "TransitionAnimator.h"

@implementation TransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    UIView *fromView = fromViewController.view;
    UIView *toView = toViewController.view;
    
    toView.alpha = 0;
    [containerView insertSubview:toView belowSubview:fromView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.alpha = 0;
        toView.alpha = 1;
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        if (wasCancelled)
            [toView removeFromSuperview];
        [transitionContext completeTransition:!wasCancelled];
    }];
}
@end
