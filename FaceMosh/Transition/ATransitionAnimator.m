//
//  ATransitionAnimator.m
//  FaceMosh
//
//  Created by DabKick Developer on 2/8/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import "ATransitionAnimator.h"

@implementation ATransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.31;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    UIView *fromView;
    UIView *toView;
    
    fromView = fromViewController.view;
    toView = toViewController.view;
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    if (isPresenting) {
        UIImageView* transitionImage = ((PhotosViewController*)toViewController).transitionImage;
        transitionImage.image = [((GalleryViewController*)fromViewController) transitionImage];
        fromView.frame = fromFrame;
        toView.frame = [((GalleryViewController*)fromViewController) transitionStartFrame];
        transitionImage.frame = toView.bounds;
    } else {
        fromView.frame = fromFrame;
        toView.frame = toFrame;
    }
    
    if (isPresenting)
        [containerView addSubview:toView];
    else
        [containerView insertSubview:toView belowSubview:fromView];
    
     NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            toView.frame = toFrame;
            UIImageView* transitionImage = ((PhotosViewController*)toViewController).transitionImage;
            transitionImage.frame = toView.bounds;
        } else {
            fromView.frame = [((GalleryViewController*)toViewController) transitionStartFrame];
            UIImageView* transitionImage = ((PhotosViewController*)fromViewController).transitionImage;
            transitionImage.frame = fromView.bounds;
        }
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        if (wasCancelled)
            [toView removeFromSuperview];
        [transitionContext completeTransition:!wasCancelled];
    }];
     
}

@end
