//
//  HomeiPadViewController.m
//  ShoeBox
//
//  Created by andy on 13-7-19.
//  Copyright (c) 2013年 AM Studio. All rights reserved.
//

#import "HomeiPadViewController.h"
#import "ViewController.h"
#import "AppHelper.h"
#import "ConfirmViewController.h"
#import "AddViewController.h"
#import "SettingViewController.h"
#import "IMPopoverController.h"
#import "TagViewController.h"

@interface HomeiPadViewController ()<ConfirmViewControllerDelegate,AddViewControllerDelegate>

@end

@implementation HomeiPadViewController
@synthesize navController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    [self.slideBar setFrame:CGRectMake(0, 0, 100, size.height)];
    [self.view addSubview:self.slideBar];

    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(saveImageSuccess)
												 name:kSaveImageSucceededNotification
											   object:nil];
    

    [self openHome:nil];
    
}

- (void)saveImageSuccess
{
    [self openHome:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSlideBar:nil];
    [self setBgImageView:nil];
    
    [self setHomeBtn:nil];
    [super viewDidUnload];
}
- (IBAction)openHome:(id)sender {
    CGRect rect = [[UIScreen mainScreen] bounds];
//    CGRect rect = self.view.frame;
    CGSize size = rect.size;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self.bgImageView.center = self.homeBtn.center;
        } completion:^(BOOL finished) {
    }];

//    self.bgImageView.center = self.homeBtn.center;
    ViewController *rightView = [[ViewController alloc]initWithNibName:nil bundle:nil];
    [rightView.view setFrame:CGRectMake(100, 0, size.width-100, size.height)];

    navController = [[UINavigationController alloc]initWithRootViewController:rightView];
    [navController.navigationBar setHidden:YES];
    navController.view.frame = rightView.view.frame;
    [self.view addSubview:navController.view];

}
- (IBAction)openTimeLine:(id)sender {
    [navController resignFirstResponder];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self.bgImageView.center = ((UIButton*)sender).center;
    } completion:^(BOOL finished) {
    }];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;

    ViewController *rightView = [[ViewController alloc]initWithNibName:nil bundle:nil];
    [rightView.view setFrame:CGRectMake(100, 0, size.width-100, size.height)];
    [rightView openTimeline:nil];
    
    navController = [[UINavigationController alloc]initWithRootViewController:rightView];
    [navController.navigationBar setHidden:YES];
    navController.view.frame = rightView.view.frame;
    [self.view addSubview:navController.view];

}

- (IBAction)openTag:(id)sender {
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self.bgImageView.center = ((UIButton*)sender).center;
    } completion:^(BOOL finished) {
    }];

    TagViewController *rightView = [[TagViewController alloc]initWithNibName:nil bundle:nil];
    [rightView.view setFrame:CGRectMake(100, 0, size.width-100, size.height)];
    navController = [[UINavigationController alloc]initWithRootViewController:rightView];
    [navController.navigationBar setHidden:YES];
    navController.view.frame = rightView.view.frame;
    [self.view addSubview:navController.view];

}

- (IBAction)openSetting:(id)sender {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        self.bgImageView.center = ((UIButton*)sender).center;
    } completion:^(BOOL finished) {
    }];

    SettingViewController *rightView = [[SettingViewController alloc]initWithNibName:nil bundle:nil];
    [rightView.view setFrame:CGRectMake(100, 0, size.width-100, size.height)];
    navController = [[UINavigationController alloc]initWithRootViewController:rightView];
    [navController.navigationBar setHidden:YES];
    navController.view.frame = rightView.view.frame;
    [self.view addSubview:navController.view];

    /*
    SettingViewController *set = [[SettingViewController alloc]initWithNibName:nil bundle:nil];
    [set.view setFrame:CGRectMake(100,100,400,600)];
  //  set.view.center = self.view.center;
    self.setView = set;
//    UIPopoverController *pop = [[UIPopoverController alloc]initWithContentViewController:set];
// 
//    [pop presentPopoverFromRect:CGRectMake(200, 200, 400, 600) inView:self.view permittedArrowDirections:0 animated:YES];
    
    ////    SettingViewController *set = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
////    set.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:set];
    nav.view.frame = set.view.frame;
    UIPopoverController *pop = [[UIPopoverController alloc]initWithContentViewController:nav];
    
    [pop presentPopoverFromRect:CGRectMake(100, 100, 400, 600) inView:self.view permittedArrowDirections:0 animated:YES];
    
//
//    IMPopoverController *pop = [[IMPopoverController alloc]initWithContentViewController:nav];
//    pop.popOverSize = set.view.frame.size;
//    
//    //居中显示
//     int x = (self.view.frame.size.width - set.view.frame.size.width)/2;
//     int y = (self.view.frame.size.height - set.view.frame.size.height)/2;
// //   int x = 35;
// //   int y = 65;
//    
//    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//    {
////        x = 455;
//    }
//    
//    [pop presentPopoverFromRect:CGRectMake(x, y, set.view.frame.size.width, set.view.frame.size.height) inView:self.view animated:YES];

    //add shadow
    set.view.layer.shadowOffset = CGSizeMake(3, 3);
    set.view.layer.shadowColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:80.0/255.0 alpha:1.0].CGColor;
    set.view.layer.shadowOpacity = 0.8;

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:set];
    [self.view addSubview:nav.view];
 //   [self.view addSubview:set.view];*/
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.setView.view superview] && self.setView.view != touch.view) {
        [self.setView.view removeFromSuperview];
    }
}

- (IBAction)createNewItem:(id)sender {
    [self addNewShoes];
}

- (void)addNewShoes
{
    if([AppHelper sharedInstance].shoes.count < 6 || [[AppHelper sharedInstance] readPurchaseInfo])
    {
        CGRect rect = [[UIScreen mainScreen] bounds];
        int statusbarheight = [UIApplication sharedApplication].statusBarFrame.size.height;
        //CGRect rect = self.view.frame;
        rect.origin.y -= statusbarheight;
        AddViewController *add = [[AddViewController alloc]initWithNibName:nil bundle:nil];
        [add.view setFrame:rect];
        add.delegate = self;
        //[self presentModalViewController:add animated:YES];
        self.addView = add;
        [self.view addSubview:add.view];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Upgrade to full version" message:@"Unlock new themes and manage more shoes" delegate:self cancelButtonTitle:@"Upgrade" otherButtonTitles:@"Cancel", nil];
        alert.delegate = self;
        [alert show];
        return;        
    }
    
}

- (void)confirm
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    if (self.confirmView) {
        [self.confirmView.view removeFromSuperview];
 //       [self.confirmView release];
    }
    ConfirmViewController *confirm = [[ConfirmViewController alloc]initWithNibName:nil bundle:nil];
    [confirm.view setFrame:rect];
    confirm.delegate = self;
    self.confirmView = confirm;
    [self.view addSubview:confirm.view];
    
    [UIView transitionFromView:self.addView.view  toView:self.confirmView.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:NULL];
}

- (void)retake
{
    if (self.addView) {
        [self.addView.view removeFromSuperview];
 //       [self.addView release];
    }
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    AddViewController *add = [[AddViewController alloc]initWithNibName:nil bundle:nil];
    [add.view setFrame:rect];
    add.delegate = self;
    self.addView = add;
    [self.view addSubview:add.view];

    [UIView transitionFromView:self.confirmView.view  toView:self.addView.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:NULL];
}

- (void)finish
{
    [self.addView.view setHidden:YES];
    [self.confirmView.view setHidden:YES];
}
@end
