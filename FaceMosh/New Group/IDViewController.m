//
//  IDViewController.m
//  FaceMosh
//
//  Created by DabKick Developer on 2/8/18.
//  Copyright © 2018 DabKick Developer. All rights reserved.
//

#import "IDViewController.h"

@interface IDViewController ()
@property (nonatomic) UIImageView* imageView;
@end

@implementation IDViewController

- (UIImage*)currentImage {
    return self.imageView.image;
}

- (UIImageView*)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.translatesAutoresizingMaskIntoConstraints = false;
        [self.view addSubview:_imageView];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[view(>=0)]-(0)-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:@{@"view":_imageView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(0)-[view(>=0)]-(0)-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:@{@"view":_imageView}]];
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithImage:(UIImage*)image {
    self = [super init];
    if (self) {
        self.imageView.image = image;
    }
    return self;
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
