//
//  TermsViewController.m
//  dabkick
//
//  Created by Developer-3 DabKick on 2/25/14.
//
//

#import "TermsViewController.h"
//#import "AppDelegate.h"
//#import "DabBlackTopBar.h"

@interface TermsViewController ()

@end

@implementation TermsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)createThisView
{
    /*
    DabBlackTopBar* topBarView = [[DabBlackTopBar alloc] initWithTitle:@"Terms of Service"
                                                                  size:CGSizeMake(320, 44)
                                                            cancelText:NSLocalizedString(@"localization.0.128", nil)
                                                           cancelBlock:^(DabBlackTopBar* topBar, UIButton* button) {
                                                               [self dismissViewControllerAnimated:YES completion:nil];
                                                           }];
    [self.view addSubview:topBarView];
*/
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(loadTermsPage) userInfo:nil repeats:NO];
}

- (void)doneAction {
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)loadTermsPage
{
    UIWebView *termsView = [[UIWebView alloc] init];
    UINavigationBar* navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    navBar.tintColor = [UIColor litRedColor];
    navBar.barStyle = UIBarStyleBlack;
    UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:NSLocalizedString(@"Terms & Conditions", nil)];
    navItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    navBar.items = @[navItem];
    [self.view addSubview:navBar];
    [termsView setFrame:CGRectOffset([UIApplication sharedApplication].keyWindow.frame, 0, 44)];
    termsView.delegate = self;
    termsView.scalesPageToFit = YES;
    [termsView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.dabkick.com/terms.html"]]];
    [self.view addSubview:termsView];
//    [termsView release];
}

/////////////////
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
//////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
//    [myAppDelegate showActivityIndicator:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [myAppDelegate hideActivityIndicator];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self createThisView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
