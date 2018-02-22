//
//  GalleryViewController.m
//  FaceMosh
//
//  Created by DabKick Developer on 1/28/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import "GalleryViewController.h"
#import "Colorz.h"

@interface GalleryViewController () <UICollectionViewDelegate, UICollectionViewDataSource, DabKickLiveSessionSdkDelegate>

@property (nonatomic) UIView* actionContainer;
@property (nonatomic) UICollectionView* imageGallery;
@property (nonatomic) UIBarButtonItem* item;
@property (nonatomic) UIBarButtonItem* detailItem;
@property (nonatomic) DabKickWatchTogetherButton *mainWatchButton;
@property (nonatomic, strong) ATransitionDelegate *customTransitionDelegate;
@property (nonatomic, strong) UILabel* detailLabel;

@end

@implementation GalleryViewController

- (ATransitionDelegate *)customTransitionDelegate
{
    if (_customTransitionDelegate == nil)
        _customTransitionDelegate = [[ATransitionDelegate alloc] init];
    
    return _customTransitionDelegate;
}

- (DabKickWatchTogetherButton*)mainWatchButton {
    if (!_mainWatchButton) {
        DabKickWatchTogetherButton *dabKickWatchTogetherButton = [[DabKickLiveSessionSdk defaultInstance] getWatchTogetherButton];
        [dabKickWatchTogetherButton sizeToFit];
        [self.view addSubview:dabKickWatchTogetherButton];
        dabKickWatchTogetherButton.center = self.view.center;
        dabKickWatchTogetherButton.alpha = 0;
        [DabKickLiveSessionSdk defaultInstance].delegate = self;
        _mainWatchButton = dabKickWatchTogetherButton;
    }
    return _mainWatchButton;
}

- (void)watchAction {
    [self.mainWatchButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)doneAction {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (CGFloat)topMargin {
    return 55.0;
}

- (UIBarButtonItem*)item {
    if (!_item) {
        _item = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Delete", nil) style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction)];
        _item.enabled = false;
        [self hideDeleteButton];
    }
    return _item;
}

- (void)initNavBar {
    UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [self topMargin])];
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    [navBar setBarStyle:UIBarStyleBlack];
    [navBar setTintColor:[UIColor litRedColor]];
    UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"Image Gallery", nil)];
    navItem.leftBarButtonItem = doneItem;
    navItem.rightBarButtonItems = @[self.item, self.detailItem];
    navBar.items = @[navItem];
    [self.view addSubview:navBar];
}

- (UIBarButtonItem*)detailItem {
    if (!_detailItem) {
        _detailItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Show", nil) style:UIBarButtonItemStylePlain target:self action:@selector(viewAction)];
        _detailItem.enabled = false;
        [self hideDeleteButton];
    }
    return _detailItem;
}

- (CGRect)cvFrame {
    return CGRectMake(0, [self topMargin], self.view.frame.size.width, self.view.bounds.size.height - [self topMargin]);
}

- (UICollectionView*)imageGallery {
    if (!_imageGallery) {
        UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        _imageGallery = [[UICollectionView alloc] initWithFrame:[self cvFrame] collectionViewLayout:layout];
        [_imageGallery registerClass:[ImageGalleryCVC class] forCellWithReuseIdentifier:@"imageGalleryReuseID"];
        _imageGallery.delegate = self;
        _imageGallery.dataSource = self;
        _imageGallery.allowsMultipleSelection = TRUE;
    }
    return _imageGallery;
}

- (CGSize)collectionView:(UICollectionView*)cv layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat size = self.view.frame.size.width / 3.0;
    CGFloat scale = self.view.frame.size.height / self.view.frame.size.width;
    return CGSizeMake(size, size * scale);
}

- (UICollectionViewCell *)collectionView:(UICollectionView*)cv cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UIImage* image = [[ImageStore sharedStore] imageAtIndexPath:indexPath];
    ImageGalleryCVC* item = [cv dequeueReusableCellWithReuseIdentifier:@"imageGalleryReuseID" forIndexPath:indexPath];
    item.imageView.image = image;
    return item;
}

- (void)handleSelection {
    if ([self.imageGallery indexPathsForSelectedItems].count) {
        self.item.enabled = true;
        self.detailItem.enabled = true;
        [self showDeleteButton];
    } else {
        self.item.enabled = false;
        self.detailItem.enabled = false;
        [self hideDeleteButton];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self handleSelection];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self handleSelection];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[ImageStore sharedStore] numberOfImages];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self.view addSubview:self.imageGallery];
    [self initIndicatorLabel];
    // Do any additional setup after loading the view.
    [self handleLabelAlpha];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadCV {
    [self.imageGallery reloadData];
}

- (void)viewAction {
    PhotosViewController* photosVC = [[PhotosViewController alloc] init];
    NSArray<NSIndexPath*>* indices = [self.imageGallery indexPathsForSelectedItems];
    photosVC.images = [[ImageStore sharedStore] imagesAtIndexPaths:indices];
    photosVC.transitioningDelegate = self.customTransitionDelegate;
    photosVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:photosVC animated:true completion:nil];
}

- (void)deleteAction {
    GalleryViewController* __weak weakSelf = self;
    ImageStore* store = [ImageStore sharedStore];
    [self.imageGallery performBatchUpdates:^{
        NSArray<NSIndexPath*>* indices = [weakSelf.imageGallery indexPathsForSelectedItems];
        [store deleteItemsAtIndexPaths:indices];
        [weakSelf.imageGallery deleteItemsAtIndexPaths:indices];
    } completion:^(BOOL finished) {
        [store saveImagesToDiskWithCompletion:nil];
        [weakSelf hideDeleteButton];
        [weakSelf.detailItem setEnabled:NO];
        [weakSelf.item setEnabled:NO];
        [weakSelf handleLabelAlpha];
    }];
}

- (UIView*)actionContainer {
    if (!_actionContainer) {
        _actionContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 55)];
        [_actionContainer setBackgroundColor:[UIColor blackColor]];
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, self.view.frame.size.width - 30, 45)];
        button.layer.borderWidth = 2.0f;
        button.layer.borderColor = [UIColor litRedColor].CGColor;
        button.layer.cornerRadius = 10.0f;
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:NSLocalizedString(@"WATCH TOGETHER", nil) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
        [button setTitleColor:[UIColor litRedColor] forState:UIControlStateNormal];
        [_actionContainer addSubview:button];
        [button addTarget:self action:@selector(watchAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_actionContainer];
    }
    return _actionContainer;
}

- (void)initIndicatorLabel {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(55, 160, self.view.frame.size.width - 110, 300)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];
    label.text = NSLocalizedString(@"There are no photos saved to your gallery right now.", nil);
    _detailLabel = label;
    label.alpha = 0;
    [self.view addSubview:label];
}

- (void)handleLabelAlpha {
    GalleryViewController* __weak weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        int numberOfImages = [ImageStore sharedStore].numberOfImages;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (numberOfImages == 0)
                weakSelf.detailLabel.alpha = 1;
            else
                weakSelf.detailLabel.alpha = 0;
        });
    });
}

- (CGRect)transitionStartFrame   {
    NSArray<NSIndexPath*>* indices = [[self.imageGallery indexPathsForSelectedItems] sortedArrayUsingSelector:@selector(compare:)];
    UICollectionViewLayoutAttributes *attributes = [self.imageGallery layoutAttributesForItemAtIndexPath:indices[0]];
    CGRect output = CGRectMake(attributes.frame.origin.x + 8, attributes.frame.origin.y + 8,
                               attributes.frame.size.width - 16, attributes.frame.size.height - 16);
    return CGRectOffset(output, 0, self.imageGallery.frame.origin.y - self.imageGallery.contentOffset.y);
}

- (CGSize)collectionView:(UICollectionView*)cv layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 100);
}

- (void)hideDeleteButton {
    [UIView animateWithDuration:0.2 animations:^{
        self.actionContainer.frame = CGRectMake(0, self.view.frame.size.height, self.actionContainer.bounds.size.width, self.actionContainer.bounds.size.height);
    }];
}

- (void)showDeleteButton {
    [self.view bringSubviewToFront:self.actionContainer];
    [UIView animateWithDuration:0.2 animations:^{
        self.actionContainer.frame = CGRectMake(0, self.view.frame.size.height - self.actionContainer.bounds.size.height, self.actionContainer.bounds.size.width, self.actionContainer.bounds.size.height);
    }];
}

#pragma mark - DK Delegate

- (void)categoryNamesForDabKickLiveSession:(DabKickLiveSessionSdk * _Nonnull)liveSessionInstance offset:(NSUInteger)offset contentType:(DabKickContentType)contentType loader:(id <DabKickStringLoading> _Nonnull)loader {
    NSArray<UIImage*>* images = [[ImageStore sharedStore] getImages].copy;
    if (offset < images.count) {
        NSArray<DabKickContent>* sample = (NSArray<DabKickContent>*)@[@"Mustache Pics"];
        [loader send:sample];
    }
}

- (UIImage*)transitionImage {
    return [[ImageStore sharedStore] imagesAtIndexPaths:[self.imageGallery indexPathsForSelectedItems]][0];
}

- (void)dabKickLiveSession:(DabKickLiveSessionSdk * _Nonnull)liveSessionInstance contentForCategory:(NSString * _Nonnull)title offset:(NSUInteger)offset contentType:(DabKickContentType)contentType loader:(id <DabKickContentLoading> _Nonnull)loader {
    NSArray<UIImage*>* images = [[ImageStore sharedStore] getImages].copy;
    if (images.count) {
        if (offset < images.count) {
            NSMutableArray<id <DabKickContent> > *contentArray = [[NSMutableArray alloc] initWithCapacity:images.count];
            
            for (UIImage* image in images) {
                DabKickImageContent *imageContent = [[DabKickImageContent alloc] init];
                imageContent.image = image;
                [contentArray addObject:imageContent];
            }
            
            [loader send:contentArray];
        }
    } else {
        [loader send:nil];
    }
    
}

- (NSArray<id<DabKickContent>> *)startDabKickLiveSessionWithContent:(DabKickLiveSessionSdk *)liveSessionInstance {
    NSMutableArray* output = [NSMutableArray new];
    for (NSIndexPath* path in [self.imageGallery indexPathsForSelectedItems]) {
        if (path.row < [ImageStore sharedStore].numberOfImages) {
            UIImage* image = [[ImageStore sharedStore] imageAtIndexPath:path];
            [output addObject:image];
        }
    }
    if (output.count) {
        NSArray <UIImage *> *imagesToStage = [output copy];
        NSMutableArray<id <DabKickContent> > *contentArray = [[NSMutableArray alloc] initWithCapacity:imagesToStage.count];
        
        for (UIImage* image in imagesToStage) {
            DabKickImageContent *imageContent = [[DabKickImageContent alloc] init];
            imageContent.image = image;
            [contentArray addObject:imageContent];
        }
        
        return contentArray;
    }
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
