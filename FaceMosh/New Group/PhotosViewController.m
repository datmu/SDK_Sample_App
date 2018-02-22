//
//  PhotosViewController.m
//  FaceMosh
//
//  Created by DabKick Developer on 2/8/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import "PhotosViewController.h"
#import "IDViewController.h"

@interface PhotosViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic) NSArray<UIViewController*>* viewControllers;
@property (nonatomic) UINavigationBar* navBar;
@end

@implementation PhotosViewController

- (NSArray<UIViewController*>*)viewControllers {
    if (!_viewControllers) {
        NSMutableArray* output = [NSMutableArray new];
        for (UIImage* image in self.images) {
            IDViewController* idVC = [[IDViewController alloc] initWithImage:image];
            [output addObject:idVC];
        }
        _viewControllers = output.copy;
    }
    return _viewControllers;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    int index = (int)[self.viewControllers indexOfObject:viewController];
    if (index == 0) return nil;
    return [self.viewControllers objectAtIndex:index - 1];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    int index = (int)[self.viewControllers indexOfObject:viewController];
    if (index >= [self.viewControllers count] - 1) return nil;
    return [self.viewControllers objectAtIndex:index + 1];
}

- (NSArray<UIImage*>*)images {
    if (!_images) {
        _images = @[];
    }
    return _images;
}

- (UIImageView*)transitionImage {
    if (!_transitionImage) {
        _transitionImage = [UIImageView new];
        _transitionImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_transitionImage];
    }
    return _transitionImage;
}

- (NSArray<UIViewController*>*)initialViewController {
    return @[[self.viewControllers firstObject]];
}

- (UIPageViewController*)pvc {
    if (!_pvc) {
        _pvc = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pvc.dataSource = self;
        _pvc.delegate = self;
        _pvc.view.frame = self.view.bounds;
        [_pvc setViewControllers:[self initialViewController] direction:UIPageViewControllerNavigationDirectionForward animated:true completion:nil];
    }
    return _pvc;
}


- (void)doneAction {
    id __weak weakSelf = self;
    IDViewController* currentVC = self.pvc.viewControllers.firstObject;
    if (currentVC.currentImage == self.transitionImage.image || self.viewControllers.count == 1)
        [self dismissViewControllerAnimated:true completion:nil];
    [self.pvc setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:true completion:^(BOOL finished) {
        [weakSelf dismissViewControllerAnimated:true completion:nil];
    }];
}

- (void)initNavBar {
    UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    navBar.barStyle = UIBarStyleBlack;
    navBar.tintColor = [UIColor litRedColor];
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:@""];
    navItem.rightBarButtonItem = item;
    [navBar setItems:@[navItem]];
    [self.view addSubview:navBar];
    navBar.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view(>=0)]|" options:0 metrics:nil views:@{@"view":navBar}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view(==52)]" options:0 metrics:nil views:@{@"view":navBar}]];
    navBar.alpha = 0;
    _navBar = navBar;
    [UIView animateWithDuration:0.2 animations:^{
        navBar.alpha = 1;
        self.transitionImage.alpha = 0;
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.pvc.view];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _transitionImage.alpha = 1;
    [UIView animateWithDuration:0.1 animations:^{
        _navBar.alpha = 0;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
