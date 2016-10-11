//
//  HomeiPadViewController.h
//  ShoeBox
//
//  Created by andy on 13-7-19.
//  Copyright (c) 2013年 AM Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddViewController;
@class ConfirmViewController;
@class SettingViewController;
@interface HomeiPadViewController : UIViewController

@property (strong, nonatomic) UIView *containView;
@property (strong, nonatomic) AddViewController *addView;
@property (strong, nonatomic) ConfirmViewController *confirmView;
@property (strong, nonatomic) SettingViewController *setView;
@property (strong, nonatomic) UINavigationController *navController;

@property (strong, nonatomic) IBOutlet UIView *slideBar;
- (IBAction)openHome:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *homeBtn;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
- (IBAction)openTimeLine:(id)sender;
- (IBAction)openTag:(id)sender;
- (IBAction)openSetting:(id)sender;
- (IBAction)createNewItem:(id)sender;
@end
