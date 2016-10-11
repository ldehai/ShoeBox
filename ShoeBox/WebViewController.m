//
//  WebViewController.m
//  Baker
//
//  Created by andy on 12/1/13.
//
//

#import "WebViewController.h"
#import "SVProgressHUD.h"
#import "AppHelper.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithUrl:(NSString*)strUrl
{
    self = [super init];
    if (self) {
        url = strUrl;
    }
    return self;
}

- (id)initWithImage:(NSString*)strImagePath
{
    self = [super init];
    if (self) {
        url = strImagePath;
        bShowImage = TRUE;
    }
    return self;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, self.view.frame.size.width*2/5, 44)];
        titleView.backgroundColor = [UIColor clearColor];
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            titleView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        else
            titleView.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
            titleView.textColor = [UIColor blackColor]; // Change to desired color
        else
            titleView.textColor = [UIColor whiteColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}
*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self setTitle:@"Shoe Store"];
    self.title = @"Shoe Store";
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeMe)];
    
    [closeButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = closeButton;

}

- (void)closeMe
{
    [SVProgressHUD dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    } else {
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }

    [self loadURL:url];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)loadURL:(NSString*)strUrl
{
    if ([strUrl isEqualToString:@""]) {
        return;
    }
    [self.myweb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [SVProgressHUD show];
    
    NSString *urlstr = [[request URL] absoluteString];
    NSLog(@"%@",urlstr);
    
  //  urlstr = [NSString stringWithFormat:@"%@%@&vender=aventlabs",urlstr,@""];
  //  [self.myweb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstr]]];
    
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    // screenBounds.origin.y -= 60;
    
    int pageWidth  = screenBounds.size.width;
    int pageHeight = screenBounds.size.height;
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        pageWidth  = screenBounds.size.height;
        pageHeight = screenBounds.size.width;
    }
    int navheight = self.navigationController.navigationBar.frame.size.height;
    
    int ypos = navheight;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        ypos = -20;
    else
        ypos = -10;
    
    [imageView setFrame:CGRectMake(0, ypos, pageWidth, pageHeight-ypos-110)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyweb:nil];
    [super viewDidUnload];
}
@end
