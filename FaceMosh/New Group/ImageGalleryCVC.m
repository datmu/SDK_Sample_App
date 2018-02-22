//
//  ImageGalleryCVC.m
//  FaceMosh
//
//  Created by DabKick Developer on 1/28/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import "ImageGalleryCVC.h"
#import "Colorz.h"

@implementation ImageGalleryCVC

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(3, 3, frame.size.width - 6, frame.size.height - 6) cornerRadius:5];
        CAShapeLayer* mask = [CAShapeLayer new];
        mask.path = path.CGPath;
        self.layer.mask = mask;
    }
    return self;
}

- (BOOL)selected {
    if (!self.selected) {
        self.selected = false;
    }
    return self.selected;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [UIView animateWithDuration:0.2 animations:^{
        if (selected)
            [self.contentView setBackgroundColor:[UIColor litRedColor]];
        else
            [self.contentView setBackgroundColor:[UIColor clearColor]];
    }];
}

- (UIImageView*)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        [self.contentView addSubview:_imageView];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(8)-[view(>=0)]-(8)-|" options:0 metrics:nil views:@{@"view": _imageView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(8)-[view(>=0)]-(8)-|" options:0 metrics:nil views:@{@"view": _imageView}]];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = true;
    }
    return _imageView;
}

@end
