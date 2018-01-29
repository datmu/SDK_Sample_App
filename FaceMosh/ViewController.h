//
//  ViewController.h
//  FaceMosh
//
//  Created by DabKick Developer on 1/17/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Colorz.h"
#import "OverlayPicker.h"
#import <DabKickLiveSessionSdk/DabKickLiveSessionSdk.h>
#import <QuartzCore/QuartzCore.h>
#import "GalleryViewController.h"
#import "ImageStore.h"

@interface ViewController : UIViewController <DabKickLiveSessionSdkDelegate>

@property (nonatomic, strong) UIButton* pictureButton;
@property (nonatomic, strong) UIView *overlayView;

@end

