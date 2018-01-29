//
//  OverlayPicker.m
//  FaceMosh
//
//  Created by DabKick Developer on 1/17/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import "OverlayPicker.h"

#define DEFAULT_MARGIN 25.0

@interface OverlayPicker() <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic) UICollectionView* cv;
@property (nonatomic) CVLayout* layout;

@property (nonatomic) NSArray* overlayArray;
@property (nonatomic) NSArray* tempColors;

@property (nonatomic) CGRect indicatorFrame;

@end

@implementation OverlayPicker

int currIndex = 0;

- (UIImage*)currentImage {
    return self.overlayArray[currIndex];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)removeObservers {
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat xOffset = scrollView.contentOffset.x;
    xOffset += [CVLayout idealItemSize].width / 3.0;
    int index = xOffset / [CVLayout idealItemSize].width;
    currIndex = index;
    UIImage* item = [self.overlayArray objectAtIndex:index];
    if ([self.delegate respondsToSelector:@selector(didAutoSelectItem:)]) {
        [self.delegate didAutoSelectItem:item];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)becomeObserver {
    if ([self.cv isKindOfClass:[UIScrollView class]]) {
        UIScrollView* sv = (UIScrollView*)self.cv;
        sv.delegate = self;
        sv.showsHorizontalScrollIndicator = NO;
    }
}

- (void)dealloc {
    [self removeObservers];
}

- (void)layoutSubviews {
    [self addSubview:self.cv];
    [self initSelectionIndicator];
    [self becomeObserver];
}

- (NSArray*)overlayArray {
    if (!_overlayArray) {
        _overlayArray = @[[UIImage imageNamed:@"Asset 1"],
                          [UIImage imageNamed:@"Asset 2"],
                          [UIImage imageNamed:@"Asset 3"],
                          [UIImage imageNamed:@"Asset 4"],
                          [UIImage imageNamed:@"Asset 5"],
                          [UIImage imageNamed:@"Asset 6"],
                          [UIImage imageNamed:@"Asset 7"],
                          [UIImage imageNamed:@"Asset 8"],
                          [UIImage imageNamed:@"Asset 9"],];
    }
    return _overlayArray;
}

- (CVLayout*)layout {
    if (!_layout) {
        _layout = [[CVLayout alloc] initWithNumberOfItems:(int)self.overlayArray.count];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [_layout setSectionInset:UIEdgeInsetsMake([CVLayout topMargin], [CVLayout sideMargin], [CVLayout topMargin], [CVLayout sideMargin])];
    }
    return _layout;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return [CVLayout idealItemSize];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.overlayArray count];
}

- (void)initSelectionIndicator {
    CGFloat width = [CVLayout idealItemSize].width - [CVLayout itemMargin] * 2.0;
    CGFloat selectorMargin = 5.0f;
    CGRect frame = CGRectMake(self.frame.size.width / 2.0 - width / 2.0 + selectorMargin, (self.frame.size.height - width) / 2.0 + selectorMargin,
                              width - selectorMargin * 2, width - selectorMargin * 2);
    UIView* indicator = [[UIView alloc] initWithFrame:frame];
    indicator.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
    indicator.layer.borderWidth = 4.0f;
    indicator.layer.cornerRadius = indicator.frame.size.width / 2.0;
    indicator.layer.borderColor = [UIColor darkGrayColor].CGColor;
    [self.layer addSublayer:indicator.layer];
    _indicatorFrame = indicator.frame;
}

- (void)configureItem:(FMPCollectionViewCell*)item atIndexPath:(NSIndexPath*)indexPath {
    [item setBackgroundColor:[UIColor clearColor]];
    CGFloat margin = DEFAULT_MARGIN;
    CGRect itemFrame = CGRectMake(margin, margin, [CVLayout idealItemSize].width - margin * 2, [CVLayout idealItemSize].height - margin * 2);
    item.imageView.frame = itemFrame;
    item.imageView.image = self.overlayArray[indexPath.row];
    item.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [item addSubview:item.imageView];
    UIColor* bgColor = [UIColor colorWithWhite:1 alpha:0.34];
    CGSize size = _indicatorFrame.size;
    UIView* circle = item.imageContainer;
    item.imageContainer.frame = CGRectMake(0, 0, size.width, size.height);
    circle.layer.position = item.imageView.layer.position;
    [item insertSubview:circle belowSubview:item.imageView];
    circle.backgroundColor = bgColor;
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect:circle.bounds];
    CAShapeLayer* mask = [CAShapeLayer new];
    mask.path = ovalPath.CGPath;
    circle.layer.mask = mask;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMPCollectionViewCell* item = [collectionView dequeueReusableCellWithReuseIdentifier:@"someID" forIndexPath:indexPath];
    [self configureItem:item atIndexPath:indexPath];
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    currIndex = indexPath.row;
    [self.delegate didPickItem:self.overlayArray[indexPath.row]];
}

- (UICollectionView*)cv {
    if (!_cv) {
        _cv = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.layout];
        _cv.dataSource = self;
        _cv.delegate = self;
        [_cv setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.]];
        [_cv registerClass:[FMPCollectionViewCell class] forCellWithReuseIdentifier:@"someID"];
        [_cv setShowsVerticalScrollIndicator:false];
    }
    return _cv;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
