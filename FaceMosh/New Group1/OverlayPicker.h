//
//  OverlayPicker.h
//  FaceMosh
//
//  Created by DabKick Developer on 1/17/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVLayout.h"
#import "FMPCollectionViewCell.h"

@protocol OverlayPickerDelegate

- (void)didPickItem:(UIImage*)item;

@optional

- (void)didAutoSelectItem:(UIImage*)item;

@end

@interface OverlayPicker : UIView

@property (nonatomic, weak) id delegate;
- (UIImage*)currentImage;

@end
