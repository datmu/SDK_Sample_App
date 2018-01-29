//
//  CVLayout.m
//  FaceMosh
//
//  Created by DabKick Developer on 1/17/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import "CVLayout.h"

@interface CVLayout()

@property (nonatomic) NSNumber* numberOfItems;

@end

@implementation CVLayout

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (NSNumber*)numberOfItems {
    if (!_numberOfItems) _numberOfItems = @1;
    return _numberOfItems;
}

- (id)initWithNumberOfItems:(int)numberOfItems {
    self = [super init];
    if (self) {
        _numberOfItems = @(numberOfItems);
    }
    return self;
}

- (CGFloat)itemWidth {
    return [[UIApplication sharedApplication] keyWindow].frame.size.width;
}

+ (CGFloat)itemMargin {
    return 5.0f;
}

+ (CGSize)idealItemSize {
    CGFloat width = [[UIApplication sharedApplication] keyWindow].frame.size.width;
    CGFloat height = [[UIApplication sharedApplication] keyWindow].frame.size.height;
    CGFloat itemHeight = (height - width) / 2.0 - ([self itemMargin] * 2);
    CGFloat itemWidth = itemHeight;
    return CGSizeMake(itemWidth, itemHeight);
}

+ (CGFloat)topMargin {
    return [self itemMargin];
}

+ (CGFloat)sideMargin {
    CGFloat width = [[UIApplication sharedApplication] keyWindow].frame.size.width;
    CGSize itemSize = [CVLayout idealItemSize];
    return (width - itemSize.width) / 2.0;
}

int currentIndex = 0;

- (int)magneticIndex:(int)index forVelocity:(CGPoint)velocity {
    int maxIncrement = 2;
    if (fabs(velocity.x) < 1.0) {
        maxIncrement = 1;
    } else if (fabs(velocity.x) > 3.0) {
        maxIncrement = 3;
    }
    if (index > currentIndex) {
        currentIndex = MIN(currentIndex + maxIncrement, index);
    } else if (index < currentIndex) {
        currentIndex = MAX(currentIndex - maxIncrement, index);
    }
    return currentIndex;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity {
    CGFloat currentOffset = self.collectionView.contentOffset.x;
    CGFloat itemWidth = [CVLayout idealItemSize].width;
    CGFloat itemNudge = itemWidth / 2.0;
    CGFloat proposedOffset = proposedContentOffset.x;
    int proposedIndex = (proposedOffset + itemNudge) / itemWidth;
    int currIndex = (currentOffset + itemNudge) / itemWidth;
    CGFloat maxIncrement = 1;
    if (fabs(velocity.x) > 1.0) {
        maxIncrement = (int)floorf(fabs(velocity.x));
    }
    
    int index = proposedIndex;
    if (index > currIndex) {
        index = MIN(currIndex + maxIncrement, self.numberOfItems.floatValue);
    } else {
        if (proposedIndex != currIndex)
            index = MAX(currIndex - maxIncrement, 0);
    }
    
    CGPoint output = CGPointMake(index * [CVLayout idealItemSize].width, proposedContentOffset.y);
    currentIndex = index;
    return output;
}

@end
