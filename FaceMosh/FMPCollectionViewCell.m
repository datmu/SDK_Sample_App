//
//  FMPCollectionViewCell.m
//  FaceMosh
//
//  Created by DabKick Developer on 1/18/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import "FMPCollectionViewCell.h"

@implementation FMPCollectionViewCell

- (UIView*)imageContainer {
    if (!_imageContainer) {
        _imageContainer = [[UIView alloc] init];
    }
    return _imageContainer;
}

- (UIImageView*)imageView {
    if (!_imageView)
        _imageView = [[UIImageView alloc] init];
    return _imageView;
}

@end
