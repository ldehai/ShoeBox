//
//  ThemeViewController.h
//  myshoe
//
//  Created by andy on 13-4-27.
//  Copyright (c) 2013年 somolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThemeViewControllerDelegate <NSObject>

- (void)setCurrentTheme;

@end
@interface ThemeViewController : UIViewController

@property (strong, nonatomic) id <ThemeViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *table;
- (IBAction)goback:(id)sender;
@end
