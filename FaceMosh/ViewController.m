//
//  ViewController.m
//  FaceMosh
//
//  Created by DabKick Developer on 1/17/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import "ViewController.h"

#define DEFAULT_RATIO 4 / 3.0

@interface ViewController () <UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, OverlayPickerDelegate, DabKickLiveSessionSdkDelegate>

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *watchNowButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (nonatomic) UIImagePickerController* aController;
@property (nonatomic) UIImageView* imageViewer;
@property (nonatomic) UIButton* plusButton;
@property (nonatomic) OverlayPicker* aPicker;
@property (nonatomic) UIImageView* translationView;
@property (nonatomic) UIView* pickerContrainer;
@property (nonatomic) CGFloat rotationAmount;
@property (nonatomic) DabKickWatchTogetherButton *mainWatchButton;
@property (nonatomic) UIImage* stageImage;
@property (nonatomic) CGRect originalFrame;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoButtonOutlet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centeringOutlet;
@property (nonatomic) UIView* blurView;
@property (nonatomic) UIBarButtonItem* doneItem;
@property (nonatomic) UIBarButtonItem* cancelItem;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) UIActivityViewController* sController;
@property (nonatomic) UIImage* anImage;
@property (nonatomic) CATransform3D currentTransform;
@property (nonatomic) UIButton* galleryButton;

// GESTURE RECOGNIZERS

@property (nonatomic) UIPanGestureRecognizer* panGesture;
@property (nonatomic) UIPinchGestureRecognizer* pinchGesture;
@property (nonatomic) UIRotationGestureRecognizer* rotationGesture;

@end

@implementation ViewController

@synthesize overlayView;

- (void)configureSaveButton {
    [self.saveButton setTitle:NSLocalizedString(@"Save Photo", nil) forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor litRedColor] forState:UIControlStateNormal];
    self.saveButton.layer.borderWidth = 2.0f;
    self.saveButton.layer.borderColor = [UIColor litRedColor].CGColor;
    [self.saveButton setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.95]];
    self.saveButton.layer.cornerRadius = 15.0f;
}

- (UIActivityViewController*)sController {
    id item = (self.anImage ? self.anImage : nil);
    _sController = [[UIActivityViewController alloc] initWithActivityItems:@[item] applicationActivities:nil];
    return _sController;
}

- (IBAction)shareAction:(id)sender {
    self.anImage = self.imageViewer.image;
    [self presentViewController:self.sController animated:true completion:nil];
}

- (void)categoryNamesForDabKickLiveSession:(DabKickLiveSessionSdk * _Nonnull)liveSessionInstance offset:(NSUInteger)offset contentType:(DabKickContentType)contentType loader:(id <DabKickStringLoading> _Nonnull)loader {
    NSArray<DabKickContent>* sample = (NSArray<DabKickContent>*)@[@"Mustache Pics"];
    [loader send:sample];
}

- (void)dabKickLiveSession:(DabKickLiveSessionSdk * _Nonnull)liveSessionInstance contentForCategory:(NSString * _Nonnull)title offset:(NSUInteger)offset contentType:(DabKickContentType)contentType loader:(id <DabKickContentLoading> _Nonnull)loader {
    NSArray<UIImage*>* images = [[ImageStore sharedStore] getImages].copy;
    if ([title isEqualToString:@"Mustache Pics"]) {
        if (images.count) {
            NSMutableArray<id <DabKickContent> > *contentArray = [[NSMutableArray alloc] initWithCapacity:images.count];
            
            for (UIImage* image in images) {
                DabKickImageContent *imageContent = [[DabKickImageContent alloc] init];
                imageContent.image = image;
                [contentArray addObject:imageContent];
            }
            
            [loader send:contentArray];
        }
    }
    
}

- (void)initShareButton {
    self.shareButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    self.shareButton.layer.borderColor = [UIColor litRedColor].CGColor;
    self.shareButton.layer.borderWidth = 2.0f;
    self.shareButton.layer.cornerRadius = 23.5f;
    self.shareButton.alpha = 0;
    UIImage* image = [[UIImage imageNamed:@"share_btn_v70"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.shareButton.tintColor = [UIColor litRedColor];
    [self.shareButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)initCancelButton {
    [self.cancelButton setTitleColor:[UIColor litRedColor] forState:UIControlStateNormal];
    self.cancelButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    self.cancelButton.layer.cornerRadius = 23.5;
    self.cancelButton.layer.borderColor = [UIColor litRedColor].CGColor;
    self.cancelButton.layer.borderWidth = 2.0f;
    self.cancelButton.alpha = 0;
}

- (void)configureDefaultView {
    [self.aController.view addSubview:self.blurView];
    [self.aController.cameraOverlayView addSubview:self.translationView];
    [self.view bringSubviewToFront:self.translationView];
}

- (IBAction)cancelAction:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.watchNowButton.alpha = 0;
        self.cancelButton.alpha = 0;
        self.shareButton.alpha = 0;
        self.saveButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self.imageViewer removeFromSuperview];
        [self configureDefaultView];
    }];
}

- (void)configureWatchNowButton {
    [self.watchNowButton setTitle:NSLocalizedString(@"Watch Together", nil) forState:UIControlStateNormal];
    [self.watchNowButton setTitleColor:[UIColor litRedColor] forState:UIControlStateNormal];
    self.watchNowButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95];
    self.watchNowButton.layer.borderWidth = 2.0f;
    self.watchNowButton.layer.borderColor = [UIColor litRedColor].CGColor;
    self.watchNowButton.layer.cornerRadius = 15.0f;
    self.watchNowButton.alpha = 0;
}

- (IBAction)watchNowAction:(id)sender {
    [self.mainWatchButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)doneAction {
    [self.pickerContrainer removeFromSuperview];
}

- (UIBarButtonItem*)doneItem {
    if (!_doneItem) {
        _doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    }
    return _doneItem;
}

- (UIBarButtonItem*)cancelItem {
    if (!_cancelItem) {
        _cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    }
    return _cancelItem;
}

- (IBAction)photoButtonAction:(UIButton *)sender {
    [self snapPhoto];
}

- (void)initPhotoButton {
    self.photoButton.backgroundColor = [UIColor clearColor];
    [self.photoButton setTitleColor:[UIColor litRedColor] forState:UIControlStateNormal];
    self.photoButton.layer.cornerRadius = self.photoButton.bounds.size.width / 2.0;
    self.photoButton.layer.borderWidth = 4.0;
    self.photoButton.layer.borderColor = [UIColor litRedColor].CGColor;
    CGFloat viewHeight = self.view.frame.size.height;
    CGFloat offset = viewHeight * 0.82;
    self.photoButtonOutlet.constant = viewHeight - offset - self.photoButton.bounds.size.height;
    [self.view bringSubviewToFront:self.photoButton];
}

- (void)galleryAction {
    GalleryViewController* gvc = [GalleryViewController new];
    [self presentViewController:gvc animated:true completion:nil];
}

- (void)initGalleryButton {
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 146, 46)];
    button.layer.borderWidth = 2.0f;
    button.layer.borderColor = [UIColor litRedColor].CGColor;
    button.layer.cornerRadius = 23.5f;
    [button setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.95]];
    [button setTitle:NSLocalizedString(@"Gallery", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor litRedColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    self.galleryButton = button;
    [button.titleLabel setFont:[UIFont systemFontOfSize:15 weight:UIFontWeightSemibold]];
    [button addTarget:self action:@selector(galleryAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initWatchTogetherButton {
    DabKickWatchTogetherButton *dabKickWatchTogetherButton = [[DabKickLiveSessionSdk defaultInstance] getWatchTogetherButton];
    [dabKickWatchTogetherButton sizeToFit];
    [self.view addSubview:dabKickWatchTogetherButton];
    dabKickWatchTogetherButton.center = self.view.center;
    dabKickWatchTogetherButton.alpha = 0;
    [DabKickLiveSessionSdk defaultInstance].delegate = self;
    _mainWatchButton = dabKickWatchTogetherButton;
}

/**
 * Return images to start a live session with
 */
- (NSArray<id<DabKickContent>> *)startDabKickLiveSessionWithContent:(DabKickLiveSessionSdk *)liveSessionInstance {
    NSArray* stageArray = @[];
    if (self.imageViewer.image)
        _stageImage = self.imageViewer.image;
    if (_stageImage)
        stageArray = @[_stageImage];
    NSArray <UIImage *> *imagesToStage = stageArray;
    
    NSMutableArray<id <DabKickContent> > *contentArray = [[NSMutableArray alloc] initWithCapacity:imagesToStage.count];

    for (UIImage* image in imagesToStage) {
        DabKickImageContent *imageContent = [[DabKickImageContent alloc] init];
        imageContent.image = image;
        [contentArray addObject:imageContent];
    }
    
    return contentArray;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (CGFloat)rotationAmount {
    if (!_rotationAmount)
        _rotationAmount = 0;
    return _rotationAmount;
}

- (BOOL)shouldTranslateViewFromPosition:(CGPoint)currentPosition toPosition:(CGPoint)position {
    CGFloat x = fabs(currentPosition.x - position.x);
    CGFloat y = fabs(currentPosition.y - position.y);
    CGFloat z = sqrt((x * x) + (y * y));
    return z <= 35.0;
}

// ---------------- GESTURE ACTIONS ----------------

- (void)handlePanGesture:(UIGestureRecognizer *)panGesture {
    if ([panGesture isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer* gesture = (UIPanGestureRecognizer*)panGesture;
        if (panGesture.view) {
            if (self.translationView.image) {
                CGPoint location = [gesture locationInView:panGesture.view];
                if (CGRectContainsPoint(self.translationView.frame, location)) {
                    CGPoint position = CGPointMake(location.x, location.y);
                    CGPoint currentPosition = self.translationView.layer.position;
                    if ([self shouldTranslateViewFromPosition:currentPosition toPosition:position])
                        self.translationView.layer.position = position;
                }
            }
        }
    }
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchGesture {
    if ([pinchGesture isKindOfClass:[UIPinchGestureRecognizer class]]) {
        UIPinchGestureRecognizer* gesture = (UIPinchGestureRecognizer*)pinchGesture;
        if (pinchGesture.view) {
            if (self.translationView.image) {
                CATransform3D currentRotation = CATransform3DMakeRotation(self.rotationAmount, 0, 0, 1);
                CATransform3D updatedTransform = CATransform3DMakeScale(gesture.scale, gesture.scale, 0);
                _currentTransform = CATransform3DConcat(currentRotation, updatedTransform);
                self.translationView.layer.transform = self.currentTransform;
//                _currentTransform = self.translationView.transform;
            }
        }
    }
}

- (void)handleRotationGesture:(UIRotationGestureRecognizer *)rotationGesture {
    if ([rotationGesture isKindOfClass:[UIRotationGestureRecognizer class]]) {
        UIRotationGestureRecognizer* gesture = (UIRotationGestureRecognizer*)rotationGesture;
        if (rotationGesture.view) {
            if (self.translationView.image) {
                self.rotationAmount = gesture.rotation;
                _currentTransform = CATransform3DMakeRotation(gesture.rotation, 0, 0, 1);
                self.translationView.layer.transform = self.currentTransform;
//                _currentTransform = self.translationView.transform;
            }
        }
    }
}

// --------------- END GESTURE ACTIONS ---------------

- (UIImage*)captureScreenshot {

    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(window.bounds.size);
    }
    
    [self.view drawRect:self.view.bounds];
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:true];
    [self.aController.cameraOverlayView drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:true];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)snapPicture {
    UIView* aView = self.view;
    UIGraphicsBeginImageContextWithOptions(aView.bounds.size, aView.opaque, 0);
    [aView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

- (void)initGestureRecognizers {
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    _rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGesture:)];
    
    _panGesture.delegate = self;
    _pinchGesture.delegate = self;
    _rotationGesture.delegate = self;
    
    [self.view setUserInteractionEnabled:true];
    [self.view addGestureRecognizer:self.panGesture];
    [self.view addGestureRecognizer:self.pinchGesture];
    [self.view addGestureRecognizer:self.rotationGesture];
    
}

- (UIImageView*)translationView {
    if (!_translationView) {
        CGFloat sizeConstant = 100;
        _translationView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - sizeConstant / 2.0, CGRectGetMidY(self.view.frame) - sizeConstant / 2.0 + 66.0, sizeConstant, sizeConstant)];
        [self.aController.cameraOverlayView addSubview:_translationView];
        _translationView.backgroundColor = [UIColor clearColor];
        _translationView.contentMode = UIViewContentModeScaleAspectFit;
        [self initGestureRecognizers];
    }
    return _translationView;
}

- (void)placeImageOnScreen:(UIImage*)item {
    /*
    self.translationView.image = item;
    CGFloat margin = 15;
    self.translationView.frame = CGRectMake(margin, [self topMargin] + margin, 100, 100);
     */
}

- (void)replaceCurrentItemWithItem:(UIImage*)item {
    
    self.translationView.image = item;
//    [self.view bringSubviewToFront:self.blurView];
    
}

- (void)didAutoSelectItem:(UIImage *)item {
    [self replaceCurrentItemWithItem:item];
}

- (void)handlePhoto {
    [self.aController takePicture];
//    [self.translationView removeFromSuperview];
}

- (void)didPickItem:(UIImage *)item {
    if (item == self.translationView.image) {
        [self handlePhoto];
    }
    [self didAutoSelectItem:item];
}

- (OverlayPicker*)aPicker {
    if (!_aPicker) {
        _aPicker = [OverlayPicker new];
        _aPicker.delegate = self;
    }
    return _aPicker;
}

- (void)cancelAction {
    [self.pickerContrainer removeFromSuperview];
}

- (void)showOverlayPicker:(UIView*)container {
    UIView* blurView = [UIView new]; //[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    blurView.backgroundColor = [UIColor clearColor];
    blurView.frame =  CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100);
    blurView.alpha = 1.0;
    CGRect cvFrame = [blurView bounds];
    self.aPicker.frame = cvFrame;
    [blurView addSubview:self.aPicker];
    [self.view addSubview:blurView];
    self.pickerContrainer = blurView;
    _blurView = blurView;
    [self.view bringSubviewToFront:blurView];
}

- (UIImageView*)imageViewer {
    if (!_imageViewer) {
        _imageViewer = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self setupImageView];
    }
    return _imageViewer;
}

- (CGFloat)topMargin {
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat size = frameWidth;
    CGFloat topMargin = (self.view.frame.size.height - size) / 2.0;
    return topMargin;
}

- (void)setupImageView {
    /*
    CGFloat height = self.view.frame.size.height;
    CGFloat scale = DEFAULT_RATIO;
    CGFloat width = self.originalFrame.size.width * scale;
    CGFloat xOffset = - (width - self.view.frame.size.width) / 2.0;
     */
    self.imageViewer.frame = self.view.bounds;
    self.imageViewer.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.imageViewer];
}

bool buttonsMoved = false;

- (void)initNavBar {
    UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    navBar.barStyle = UIBarStyleBlack;
    navBar.tintColor = [UIColor litRedColor];
    UINavigationItem *navItem = [UINavigationItem new];
    navItem.rightBarButtonItem = self.doneItem;
    navBar.items = @[navItem];
    [self.view addSubview:navBar];
}

- (void)moveButtons {
    if (buttonsMoved) return;
    [self.plusButton setAlpha:0];
    [UIView animateWithDuration:0.2 animations:^{
        self.plusButton.alpha = 1;
        CGFloat x = self.view.frame.size.width * 0.66;
        x -= self.plusButton.frame.size.width / 2.0;
        self.plusButton.frame = CGRectMake(x, self.plusButton.frame.origin.y, [self buttonSize], [self buttonSize]);
        x = self.view.frame.size.width * 0.33;
        x = self.view.frame.size.width / 2.0 - x;
        self.centeringOutlet.constant = -x;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self displayWatchTogetherButton];
        buttonsMoved = true;
    }];
}

- (void)configureImageView {
    [self.blurView removeFromSuperview];
    [self.view bringSubviewToFront:self.watchNowButton];
    [self.view bringSubviewToFront:self.cancelButton];
    [self.view bringSubviewToFront:self.shareButton];
    [self.view bringSubviewToFront:self.saveButton];
    [UIView animateWithDuration:0.2 animations:^{
        self.watchNowButton.alpha = 1;
        self.cancelButton.alpha = 1;
        self.shareButton.alpha = 1;
        self.saveButton.alpha = 1;
    }];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString* imageKey = @"UIImagePickerControllerOriginalImage";
    UIImage* image = [info valueForKey:imageKey];
    if (image) {
        image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationLeftMirrored];
        self.imageViewer.image = image;
        
        if (!self.imageViewer.superview)
            [self.view addSubview:self.imageViewer];
        
        // [self.view bringSubviewToFront:self.translationView];
        // self.translationView.layer.transform = _currentTransform;
        /*
        UIImage* newImage = [self snapPicture];
        self.imageViewer.image = newImage;
        [self configureImageView];
         */
        self.imageViewer.image = [self captureScreenshot];
        [self configureImageView];
    }
}

- (UIImagePickerController*)aController {
    if (!_aController) {
        _aController = [UIImagePickerController new];
        _aController.delegate = (id)self;
        _aController.allowsEditing = YES;
        _aController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _aController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        _aController.editing = NO;
        _aController.showsCameraControls = NO;
    }
    return _aController;
}

- (void)snapPhoto {
    [self.aController takePicture];
}

- (CGFloat)buttonSize {
    return 77.0;
}

- (UIButton*)plusButton {
    if (!_plusButton) {
        CGFloat width = [self buttonSize];
        _plusButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0, self.pictureButton.frame.origin.y, width, width)];
        _plusButton.backgroundColor = [UIColor litRedColor];
        UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:_plusButton.bounds];
        CAShapeLayer* layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        _plusButton.layer.mask = layer;
        _plusButton.alpha = 0;
        [_plusButton setTitle:@"✚" forState:UIControlStateNormal];
        [_plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [_plusButton addTarget:self action:@selector(showOverlayPicker) forControlEvents:UIControlEventTouchUpInside];
    }
    return _plusButton;
}

- (void)watchTogether {
    _stageImage = [self snapPicture];
}

- (void)displayWatchTogetherButton {
    UIButton* watchTogetherButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 60, self.view.frame.size.width - 40, 44)];
    watchTogetherButton.backgroundColor = [UIColor blackColor];
    [watchTogetherButton setTitle:NSLocalizedString(@"Watch Together", nil) forState:UIControlStateNormal];
    [watchTogetherButton setTitleColor:[UIColor litRedColor] forState:UIControlStateNormal];
    [watchTogetherButton addTarget:self action:@selector(watchTogether) forControlEvents:UIControlEventTouchUpInside];
    watchTogetherButton.layer.cornerRadius = 10;
    watchTogetherButton.layer.borderColor = [[UIColor litRedColor] CGColor];
    watchTogetherButton.layer.borderWidth = 2;
    [self.view addSubview:watchTogetherButton];
}

- (UIButton*)pictureButton {
    if (!_pictureButton) {
        CGFloat width = 77.0;
        _pictureButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2.0 - width / 2.0, self.view.frame.size.height * 0.82, width, width)];
        [_pictureButton setBackgroundColor:[UIColor litRedColor]];
        [_pictureButton addTarget:self action:@selector(snapPhoto) forControlEvents:UIControlEventTouchUpInside];
        UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:_pictureButton.bounds];
        CAShapeLayer* layer = [CAShapeLayer new];
        layer.path = path.CGPath;
         _pictureButton.layer.mask = layer;
        [_pictureButton setTitle:@"Photo" forState:UIControlStateNormal];
        [_pictureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _pictureButton;
}

- (void)initCamera {
    overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.aController.view addSubview:overlayView];
    self.aController.cameraOverlayView = overlayView;
    self.originalFrame = self.aController.cameraOverlayView.frame;
    [self.view addSubview:self.aController.view];
    CGFloat ratio = DEFAULT_RATIO;
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 71.0);
    self.aController.cameraViewTransform = translate;
    CGAffineTransform scale = CGAffineTransformScale(translate, ratio, ratio);
    self.aController.cameraViewTransform = scale;
    self.aController.cameraOverlayView.clipsToBounds = NO;
    self.aController.edgesForExtendedLayout = UIRectEdgeNone;
    self.aController.extendedLayoutIncludesOpaqueBars = true;
}

- (void)initTranslationView {
    self.translationView.image = [self.aPicker currentImage];
}

- (void)showError {
    UIAlertController* note = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Uh oh!", nil) message:NSLocalizedString(@"The image was not saved", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [note dismissViewControllerAnimated:true completion:nil];
    }];
    [note addAction:action];
    [self presentViewController:note animated:true completion:nil];
}

- (void)showSuccessAlert {
    UIAlertController* note = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Success", nil) message:NSLocalizedString(@"The image has been saved", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [note dismissViewControllerAnimated:true completion:nil];
    }];
    [note addAction:action];
    [self presentViewController:note animated:true completion:nil];
}

- (IBAction)saveAction:(id)sender {
    ViewController* __weak weakSelf = self;
    if (self.imageViewer.image) {
        [[ImageStore sharedStore] saveImage:self.imageViewer.image completion:^(BOOL success) {
            if (success) {
                [weakSelf showSuccessAlert];
            } else {
                [weakSelf showError];
            }
        }];
    } else {
        [self showError];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCamera];
    [self initPhotoButton];
    [self showOverlayPicker:overlayView];
    [self configureWatchNowButton];
    [self initWatchTogetherButton];
    [self initCancelButton];
    [self initShareButton];
    [self initTranslationView];
    [self configureSaveButton];
    [self initGalleryButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
