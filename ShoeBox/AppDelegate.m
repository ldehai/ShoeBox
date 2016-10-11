//
//  AppDelegate.m
//  ShoeBox
//
//  Created by andy on 13-6-18.
//  Copyright (c) 2013年 AM Studio. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "HomeiPadViewController.h"
#import "RDVTabBarController.h"
#import "AppHelper.h"

@implementation AppDelegate

+ (AppDelegate *)sharedDelegate {
	return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    }
//    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
//    [TestFlight takeOff:@"a2f8dfe6-a1ac-4066-97b3-d8010ae64870"];
    
//    DBAccountManager *accountManager =
//    [[DBAccountManager alloc] initWithAppKey:@"k2da8qqexiouj0n" secret:@"dqzhedga3jwegp5"];
//    [DBAccountManager setSharedManager:accountManager];
//
//    DBAccount *account = [accountManager.linkedAccounts objectAtIndex:0];
//    if (account) {
//        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
//    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    
//    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        self.ipadHomeView = [[HomeiPadViewController alloc]initWithNibName:nil bundle:nil];
//        self.window.rootViewController = self.ipadHomeView;
//    }
//    else
    {
        self.viewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    [BakerAnalyticsEvents sharedInstance]; // Initialization
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppStart" object:self]; // -> Analytics Event

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
//    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
//    if (account) {
//        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
//       // NotesFolderListController *folderController =
//       // [[NotesFolderListController alloc] initWithFilesystem:filesystem root:[DBPath root]];
//       // [self.window.rootViewController pushViewController:folderController animated:YES];
//    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
