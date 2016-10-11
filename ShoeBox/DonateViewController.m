//
//  DonateViewController.m
//  tripcost
//
//  Created by andy on 13-7-17.
//  Copyright (c) 2013年 somolo. All rights reserved.
//

#import "DonateViewController.h"
#import "Reachability.h"
#import "InAppPurchaseManager.h"
#import "MBProgressHUD.h"
#import "AppHelper.h"

@interface DonateViewController ()
{
    InAppPurchaseManager *iap;//付费
    UIAlertView *alert;
}
@end

@implementation DonateViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(donateSuccess)
                                                 name:kIAPDonateSucceededNotification
                                               object:nil];

}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (IBAction)donateOne:(id)sender {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if(!r.isReachable)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Can't connect to iTunes, Please check network" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    [AppHelper sharedInstance].HUDView = self.view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Connect to iTunes ...";
    
    if (!iap) {
        iap = [[InAppPurchaseManager alloc] init];
    }
    
    [iap requestProductData:kInAppPurchaseDonate1ProductId];

}

- (IBAction)donateTwo:(id)sender {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if(!r.isReachable)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Can't connect to iTunes, Please check network" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    [AppHelper sharedInstance].HUDView = self.view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Connect to iTunes ...";
    
    if (!iap) {
        iap = [[InAppPurchaseManager alloc] init];
    }
    
    [iap requestProductData:kInAppPurchaseDonate2ProductId];

}
*/
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)donateSuccess
{
    alert = [[UIAlertView alloc]initWithTitle:nil message:@"Have a good day! Thanks for your donate" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert show];
    
    [self performSelector:@selector(closeAlert) withObject:nil afterDelay:2];
}

- (void)closeAlert
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
