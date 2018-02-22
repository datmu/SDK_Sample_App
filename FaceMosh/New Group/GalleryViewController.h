//
//  GalleryViewController.h
//  FaceMosh
//
//  Created by DabKick Developer on 1/28/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DabKickLiveSessionSdk/DabKickLiveSessionSdk.h>
#import "ImageStore.h"
#import "ImageGalleryCVC.h"
#import "PhotosViewController.h"
#import "ATransitionDelegate.h"
#import "ATransitionAnimator.h"

@interface GalleryViewController : UIViewController

- (CGRect)transitionStartFrame;
- (UIImage*)transitionImage;

@end
