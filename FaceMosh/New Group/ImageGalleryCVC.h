//
//  ImageGalleryCVC.h
//  FaceMosh
//
//  Created by DabKick Developer on 1/28/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageGalleryCVC : UICollectionViewCell

@property (nonatomic) UIImageView* imageView;

- (void)setSelected:(BOOL)selected;
- (BOOL)selected;

@end
