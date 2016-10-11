//
//  SettingViewController.m
//  myshoe
//
//  Created by andy on 13-4-25.
//  Copyright (c) 2013年 somolo. All rights reserved.
//

#import "SettingViewController.h"
#import "AppHelper.h"
#import "UpgradeViewController.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "ThemeViewController.h"
#import "UIDevice+IdentifierAddition.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "Base64.h"
#import "DonateViewController.h"

@interface SettingViewController ()<ThemeViewControllerDelegate,MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *appArray;
@end

@implementation SettingViewController


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
   // [self.navigationController.navigationBar setHidden:YES];
    self.title = @"Settings";

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    
    [closeButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = closeButton;

    self.dataArray = nil;
    
    if ([[AppHelper sharedInstance] readPurchaseInfo])
    {
        self.dataArray = [NSArray arrayWithObjects:@"Feed back",nil];
    }
    else
    {
        //self.dataArray = [NSArray arrayWithObjects:@"Tell Friends", @"Feed back",@"Reivew",@"Themes",@"Donate me", @"Unlock Full Version",nil];
        self.dataArray = [NSArray arrayWithObjects:@"Feed back",@"Unlock Full Version",nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateData)
                                                     name:kIAPTransactionSucceededNotification
                                                   object:nil];

    }
    
    self.appArray = [NSArray arrayWithObjects:
                     [NSArray arrayWithObjects:@"MapCost",@"mapcost.png",@"Tracking expense by location",
                      @"https://itunes.apple.com/us/app/mapcost/id689270210?ls=1&mt=8",nil],
                     
                     [NSArray arrayWithObjects:@"TripCost",@"tripcost.png",@"Split bills with friends",
                      @"https://itunes.apple.com/us/app/tripcost-split-bills-friends/id633501469?ls=1&mt=8",nil],
                     [NSArray arrayWithObjects:@"E.Timer",@"etimer.png",@"Excellent CountDown Timer",
                      @"https://itunes.apple.com/us/app/e.timer/id660765636?ls=1&mt=8",nil],nil];
}

- (void)close
{
    [SVProgressHUD dismiss];
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)updateData
{
    self.dataArray = [NSArray arrayWithObjects:@"Feed back",nil];
    [self.setTable reloadData];
    
    //支付成功后回到设置界面
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppPurchaseSuccess" object:self]; // -> Analytics Event

}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Setting";
    }
    else
        return @"App";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    }
    else
        return self.appArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 45;
    else
        return 64;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont *font = [UIFont fontWithName:@"Avenir Next Condensed" size:16.0];

    UITableViewCell *cell = nil;
    static NSString *SetCellIdentifier = @"setCell";
    static NSString *AppCellIdentifier = @"appCell";

    if (indexPath.section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SetCellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:AppCellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
        cell.textLabel.text = [[self.appArray objectAtIndex:indexPath.row] objectAtIndex:0];
        cell.detailTextLabel.text = [[self.appArray objectAtIndex:indexPath.row] objectAtIndex:2];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:[[self.appArray objectAtIndex:indexPath.row] objectAtIndex:1]];
    }

        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
                
            case 0:
                [self sendmail:@"ldehai@gmail.com"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AppFeedBackClick" object:self]; // -> Analytics Event
                break;
                
            case 1:
                [self upgrade];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AppPurchaseClick" object:self]; // -> Analytics Event
                
                break;
            default:
                break;
        }
    }
    else
    {
        NSString *strAppUrl = [[self.appArray objectAtIndex:indexPath.row] objectAtIndex:3];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strAppUrl]];
    }
}

- (void)givedonate
{
    DonateViewController *donate = [[DonateViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:donate animated:YES];
}

- (void)restore{

    [SVProgressHUD show];
    
    [[AppHelper sharedInstance] restore];
}

- (void)removeAds
{
    [SVProgressHUD show];
    
    [InAppPurchaseManager sharedInstance].type = 2;
    [[InAppPurchaseManager sharedInstance] requestProductData:kInAppPurchaseRemoveAdsProductId];
}

- (void)upgrade
{
    UpgradeViewController *upgrade = [[UpgradeViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:upgrade animated:YES];
}

- (void)giverate
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=640885172"]];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:1 forKey:@"haverate"];
    
}

- (void)sendmail:(NSString*)contact
{
    if ([MFMailComposeViewController canSendMail])
    {
        NSString *contact = @"ldehai+shoebox@gmail.com";
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        [mailViewController setToRecipients:[[NSArray alloc]initWithObjects:contact, nil]];
        mailViewController.mailComposeDelegate = self;
        if (contact) {
            NSString *deviceid = [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
            NSLog(@"uniqueIdentifier[%@]",deviceid);
            NSString *strBundleVersion = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
            
            NSString *language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
            NSString *deviceString = [NSString stringWithFormat:@" %@ | iOS %@ | %@",
                                      [[UIDevice currentDevice] model],[[UIDevice currentDevice] systemVersion],language];
            [mailViewController setMessageBody:deviceString isHTML:YES];
            [mailViewController setSubject:[NSString stringWithFormat:@"ShoeBox Feedback(v%@)",strBundleVersion]];
        }
        
        [self presentViewController:mailViewController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Mail Accounts" message:@"Please set up a Mail account in order to send email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        NSLog(@"Device is unable to send email in its current state.");
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)setCurrentTheme
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
