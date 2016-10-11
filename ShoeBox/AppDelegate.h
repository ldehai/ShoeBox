//
//  AppDelegate.h
//  ShoeBox
//
//  Created by andy on 13-6-18.
//  Copyright (c) 2013年 AM Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TestFlight.h"

@class ViewController;
@class HomeiPadViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) HomeiPadViewController *ipadHomeView;

@property (strong, nonatomic) IBOutlet UISplitViewController *splitViewController;
@property (strong, nonatomic) IBOutlet UIViewController *detailViewController;
+ (AppDelegate *)sharedDelegate;
@end
