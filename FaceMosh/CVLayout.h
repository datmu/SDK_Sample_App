//
//  CVLayout.h
//  FaceMosh
//
//  Created by DabKick Developer on 1/17/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVLayout : UICollectionViewFlowLayout

- (id)initWithNumberOfItems:(int)numberOfItems;

+ (CGSize)idealItemSize;
+ (CGFloat)sideMargin;
+ (CGFloat)topMargin;
+ (CGFloat)itemMargin;

@end
