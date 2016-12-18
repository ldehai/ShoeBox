//
//  ViewController.h
//  ShoeBox
//
//  Created by andy on 13-6-18.
//  Copyright (c) 2013年 AM Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "AddViewController.h"
#import "ConfirmViewController.h"
#import <CoreData/NSManagedObjectModel.h>
#import "AQGridView.h"
#import "TagViewController.h"
#import <iAd/iAd.h>
#import "DetailViewController.h"

@interface ViewController : UIViewController<AddViewControllerDelegate,ConfirmViewControllerDelegate,UISearchBarDelegate,UIAlertViewDelegate,UITextFieldDelegate,AQGridViewDataSource,AQGridViewDelegate,TagViewControllerDelegate,ADBannerViewDelegate,DetailViewControllerDelegate>
{
    int rowheight;
    BOOL bEditMode;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    NSArray *dataArray;
    
//    ScrollDirection scrollDirection;
//    int lastContentOffset;
//    BOOL bottomToolBarisHidden;
//    BOOL searchBarisHidden;
    
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}
//@property (strong) UISwipeGestureRecognizer * swipeLeftRecognizer;
//@property (strong) UISwipeGestureRecognizer * swipeRightRecognizer;

@property (strong, nonatomic) NSMutableArray *issuesArray;
@property (strong, nonatomic) AQGridView *gridView;

//@property (retain, nonatomic) UIView *topToolBarView;
//@property (retain, nonatomic) UIView *bottomToolBarView;
@property (strong, nonatomic) UIViewController *containView;
@property (strong, nonatomic) AddViewController *addView;
@property (strong, nonatomic) ConfirmViewController *confirmView;
@property (strong, nonatomic) UIView* toolbar;
@property (strong, nonatomic) IBOutlet UIButton* home;
@property (strong, nonatomic) IBOutlet UIButton* timeline;
@property (strong, nonatomic) IBOutlet UIButton* add;
@property (strong, nonatomic) IBOutlet UIButton* setting;
@property (strong, nonatomic) IBOutlet UIButton *tag;
@property (strong, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (strong, nonatomic) UIView *bottomToolBar;
@property (strong, nonatomic) UIWebView *webStoreBanner;
- (IBAction)myfavorite:(id)sender;
- (IBAction)myarchived:(id)sender;
- (IBAction)mytag:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *topToolBar;
- (IBAction)openHome:(id)sender;
- (IBAction)openTimeline:(id)sender;
- (IBAction)addShoe:(id)sender;
- (IBAction)openTag:(id)sender;

- (void)addNewShoes;
- (IBAction)openMenu:(id)sender;
- (IBAction)openSetting:(id)sender;
@end
