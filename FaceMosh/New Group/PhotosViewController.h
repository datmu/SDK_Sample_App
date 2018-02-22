//
//  PhotosViewController.h
//  FaceMosh
//
//  Created by DabKick Developer on 2/8/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Colorz.h"

@interface PhotosViewController : UIViewController 
@property (nonatomic) NSArray<UIImage*>* images;
@property (nonatomic) UIImageView* transitionImage;
@property (nonatomic) UIPageViewController* pvc;
@end
