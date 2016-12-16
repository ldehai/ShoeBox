//
//  ViewController.m
//  ShoeBox
//
//  Created by andy on 13-6-18.
//  Copyright (c) 2013年 AM Studio. All rights reserved.
//

#import "ViewController.h"
#import "AppHelper.h"
#import "AddViewController.h"
#import "DetailViewController.h"
#import "SettingViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
//#import "TableViewCell.h"
//#import <Dropbox/Dropbox.h>
#import "LeftViewController.h"
#import "AQGridView.h"
#import "IssueViewController.h"
#import "TagViewController.h"
#import "WebViewController.h"
#import "UpgradeViewController.h"

@interface ViewController ()
{
    int currentType;//0:shoe,1:timelien,2:tag
    
    UIView *dimBackgroundView;
    LeftViewController *leftView;
    SettingViewController *setView;
    BOOL bShowList;
    UIView *popMenu;
    
    NSString *currentFilter;
    ADBannerView *_bannerView;

}
@end

@implementation ViewController
@synthesize webStoreBanner;

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"Avenir-Book" size:16];
        titleView.textColor = [UIColor blackColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;
    }
    titleView.text = title;
    [titleView sizeToFit];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"FAVO"];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.view.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];
    
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self addNavigateButtons];

    CGSize size = [UIScreen mainScreen].bounds.size;
    
    int statusheight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    int top = 0;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        top = statusheight;
    }
    
    self.gridView = [[AQGridView alloc] init];
    self.gridView.dataSource = self;
    self.gridView.delegate = self;
    self.gridView.backgroundColor = [UIColor clearColor];
    [self.gridView setFrame:CGRectMake(0, 10, size.width, size.height-top-10)];
    self.gridView.showsVerticalScrollIndicator = NO;
    //self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	//self.gridView.autoresizesSubviews = YES;

    [self.view addSubview:self.gridView];
    
    currentType = 0;
    
    //observer notification
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(saveImageSuccess)
												 name:kSaveImageSucceededNotification
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(openShoe)
												 name:kOpenShoe
											   object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(enterEditMode)
												 name:EnterEditModeNotify
											   object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(updateSelected)
												 name:UpdateSelectedNotify
											   object:nil];

    
    //resize all large pictures
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    int value = [pref integerForKey:@"resized"];
    if (value == 1) {
        currentFilter = @"all";
        [[AppHelper sharedInstance] loadshoeWithFilter:@"all"];
        if (!self.issuesArray) {
            self.issuesArray = [[NSMutableArray alloc]init];
        }
        for (ShoeInfo *info in [AppHelper sharedInstance].shoes) {
            IssueViewController *view = [[IssueViewController alloc]initWithShoe:info];
            [self.issuesArray addObject:view];
        }
    }
    else{
        [self performSelector:@selector(loadShoe) withObject:nil afterDelay:1.0]
        ;
    }
    
    [self.view bringSubviewToFront:self.add];
    
    [self.gridView reloadData];
    
    [self loadPopMenu];
    
//    if (![[AppHelper sharedInstance] readPurchaseInfo]) {
//        //init iad banner
//        if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
//            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//            {
//                _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
//            }
//            else
//            {
//                _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
//            }
//        } else {
//            _bannerView = [[ADBannerView alloc] init];
//        }
//        _bannerView.delegate = self;
//        
//        CGRect bannerFrame = _bannerView.frame;
//        if (_bannerView.bannerLoaded) {
//            bannerFrame.origin.y = size.height-bannerFrame.size.height;
//        } else {
//            bannerFrame.origin.y = size.height;
//        }
//
//        [self.view addSubview:_bannerView];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(removeAds)
//                                                     name:kIAPTransactionSucceededNotification
//                                                   object:nil];
//    }
    
  //  [self loadShoeStoreBanner];
}

- (void)loadShoeStoreBanner
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    self.webStoreBanner = [[UIWebView alloc]initWithFrame:CGRectMake(0, size.height-190, size.width, 140)];
   // webStoreBanner.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    webStoreBanner.delegate = self;
    
    webStoreBanner.backgroundColor = [UIColor clearColor];
    [webStoreBanner setOpaque:NO];
    webStoreBanner.scalesPageToFit = NO;
    //[self removeWebViewDoubleTapGestureRecognizer:webStoreBanner];
    
    [self.view addSubview:self.webStoreBanner];
    UIScrollView *indexScrollView=nil;
    for (UIView *subView in webStoreBanner.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            indexScrollView = (UIScrollView *)subView;
            break;
        }
    }
    indexScrollView.delegate = self;
    indexScrollView.showsHorizontalScrollIndicator = NO;
    indexScrollView.showsVerticalScrollIndicator = NO;
    
    
    NSURL *url = [NSURL URLWithString:@"http://ldehai.com/shoeboxads.html"];

	NSURLRequest *requrl = [NSURLRequest requestWithURL: url];

   // self.webStoreBanner.delegate = self;
   // [self.view addSubview:self.webStoreBanner];
	[self.webStoreBanner loadRequest: requrl];

}
- (void)updateSelected
{
    self.title = [NSString stringWithFormat:@"%i Selected",[IssueViewController selectedCount]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    
/*    [[AppHelper sharedInstance] loadshoes:FALSE];
    if (!self.issuesArray) {
        self.issuesArray = [[NSMutableArray alloc]init];
    }
    for (ShoeInfo *info in [AppHelper sharedInstance].shoes) {
        IssueViewController *view = [[IssueViewController alloc]initWithShoe:info];
        [self.issuesArray addObject:view];
    }

    [self.gridView reloadData];*/
}

- (void)reloadData:(DetailViewController *)detailView
{
    [[AppHelper sharedInstance] loadshoeWithFilter:currentFilter];
    
    if (!self.issuesArray) {
        self.issuesArray = [[NSMutableArray alloc]init];
    }
    [self.issuesArray removeAllObjects];
    for (ShoeInfo *info in [AppHelper sharedInstance].shoes) {
        IssueViewController *view = [[IssueViewController alloc]initWithShoe:info];
        [self.issuesArray addObject:view];
    }
    
    [self.gridView reloadData];
    
    [IssueViewController clearSelectCount];

}
- (void)loadPopMenu
{
    int statusheight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    int top = statusheight;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        top = 0;
    }
    
    int popWidth = 120;
    int btnHeight = 45;
    int popHeight= (btnHeight+1)*5-1;
    
    UIFont *font = [UIFont fontWithName:@"Avenir-Book" size:16.0];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popWidth = 170;
        btnHeight = 55;
        popHeight= (btnHeight+1)*5-1;
        
        font = [UIFont fontWithName:@"Avenir-Book" size:20.0];
    }
    popMenu = [[UIView alloc]initWithFrame:CGRectMake(0, -popHeight, popWidth, popHeight)];
    popMenu.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    popMenu.layer.shadowOffset = CGSizeMake(3, 2);
    popMenu.layer.shadowColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:80.0/255.0 alpha:1.0].CGColor;
    popMenu.layer.shadowOpacity = 0.8;

    [self.view addSubview:popMenu];

    UIButton *storebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [storebtn setTitle:@"ShoeStore " forState:UIControlStateNormal];
    storebtn.titleLabel.font = font;
    [storebtn setTitleColor:[UIColor colorWithRed:249.0/255.0 green:156.0/255.0 blue:0.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    storebtn.backgroundColor = [UIColor clearColor];
    [storebtn setFrame:CGRectMake(0, 0, popWidth, btnHeight)];
    [storebtn addTarget:self action:@selector(showstore) forControlEvents:UIControlEventTouchUpInside];
//    [popMenu addSubview:storebtn];

    UIButton *allbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allbtn setTitle:@"My Shoe " forState:UIControlStateNormal];
    allbtn.titleLabel.font = font;
    [allbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    allbtn.backgroundColor = [UIColor clearColor];
    [allbtn setFrame:CGRectMake(0, 0, popWidth, btnHeight)];
    [allbtn addTarget:self action:@selector(showAll) forControlEvents:UIControlEventTouchUpInside];
    [popMenu addSubview:allbtn];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0,btnHeight, popWidth, 1)];
    line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [popMenu addSubview:line];
    
    UIButton *favbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [favbtn setTitle:@"Favorite" forState:UIControlStateNormal];
    favbtn.titleLabel.font = font;
    [favbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [favbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [favbtn setImage:[UIImage imageNamed:@"LeftSideMenu_Favorite"] forState:UIControlStateNormal];
    favbtn.backgroundColor = [UIColor clearColor];
    [favbtn setFrame:CGRectMake(0, btnHeight+1, popWidth, btnHeight)];
    [favbtn addTarget:self action:@selector(showFavorite) forControlEvents:UIControlEventTouchUpInside];
    [popMenu addSubview:favbtn];
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0,btnHeight*2+1, popWidth, 1)];
    line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [popMenu addSubview:line];
    
    UIButton *archivebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [archivebtn setTitle:@"Archive " forState:UIControlStateNormal];
    archivebtn.titleLabel.font = font;
    [archivebtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [archivebtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [archivebtn setImage:[UIImage imageNamed:@"LeftSideMenu_Archive"] forState:UIControlStateNormal];
    archivebtn.backgroundColor = [UIColor clearColor];
    [archivebtn setFrame:CGRectMake(0, (btnHeight+1)*2, popWidth, btnHeight)];
    [archivebtn addTarget:self action:@selector(showArchived) forControlEvents:UIControlEventTouchUpInside];
    [popMenu addSubview:archivebtn];
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0,btnHeight*3+2, popWidth, 1)];
    line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [popMenu addSubview:line];
    
    UIButton *tagbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tagbtn setTitle:@"Tag     " forState:UIControlStateNormal];
    tagbtn.titleLabel.font = font;
    [tagbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [tagbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [tagbtn setImage:[UIImage imageNamed:@"LeftSideMenu_Tag"] forState:UIControlStateNormal];
    [tagbtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    tagbtn.backgroundColor = [UIColor clearColor];
    [tagbtn setFrame:CGRectMake(0, (btnHeight+1)*3, popWidth, btnHeight)];
    [tagbtn addTarget:self action:@selector(showTag) forControlEvents:UIControlEventTouchUpInside];
    [popMenu addSubview:tagbtn];
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0,btnHeight*4+3, popWidth, 1)];
    line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [popMenu addSubview:line];
    
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0,btnHeight*5+3, popWidth, 1)];
    line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [popMenu addSubview:line];
    
    UIButton *setbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setbtn setTitle:@"Setting " forState:UIControlStateNormal];
    setbtn.titleLabel.font = font;
    [setbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [setbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [setbtn setImage:[UIImage imageNamed:@"LeftSideMenu_Settings"] forState:UIControlStateNormal];
    [setbtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    setbtn.backgroundColor = [UIColor clearColor];
    [setbtn setFrame:CGRectMake(0, (btnHeight+1)*4, popWidth, btnHeight)];
    [setbtn addTarget:self action:@selector(openSetting:) forControlEvents:UIControlEventTouchUpInside];
    [popMenu addSubview:setbtn];
    popMenu.alpha = 0.0;
}

- (void)showstore
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppOpenStore" object:self]; // -> Analytics Event
    
    WebViewController *webStore = [[WebViewController alloc]initWithUrl:@"http://www.amazon.com/b/ref=as_acph_ap_fallshath_910_on?node=6319710011&tag=seasdream-20&camp=218229&creative=414409&linkCode=ur1&adid=1VRJSGTM2J8SN3PJGGE2&&ref-refURL=http%3A%2F%2Frcm-na.amazon-adsystem.com%2Fe%2Fcm%3Ft%3Dseasdream-20%26o%3D1%26p%3D48%26l%3Dur1%26category%3Dshoesfall%26banner%3D0Y2PBCDK69N0XCPSY182%26f%3Difr"];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:webStore];
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//    {
//        navController.modalPresentationStyle = UIModalPresentationFormSheet;
//    }
    
    [self presentViewController:navController animated:YES completion:nil];

    
}
- (IBAction)openMenu:(id)sender{
    
    if(!dimBackgroundView)
    {
        dimBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        //dimBackgroundView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
        dimBackgroundView.backgroundColor = [UIColor clearColor];
    }
    
    int statusheight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    int top = statusheight;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        top = 0;
    }
    
    
    if (!bShowList) {
        [self.view addSubview:dimBackgroundView];
        [self.view bringSubviewToFront:popMenu];
        CGRect frame = popMenu.frame;
        frame.origin.y = top;
        [UIView animateWithDuration:0.2
                         animations:^{
                             dimBackgroundView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
                             [popMenu setFrame:frame];
                             popMenu.alpha = 1.0;
                         }];
    }
    else{
        CGRect frame = popMenu.frame;
        frame.origin.y = -frame.size.height;
        [UIView animateWithDuration:0.2
                         animations:^{
                             dimBackgroundView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
                             [popMenu setFrame:frame];
                             popMenu.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [dimBackgroundView removeFromSuperview];
                         }];
    }
    
    bShowList = !bShowList;
}

- (void)showAll
{
    self.title = @"FAVO";
    currentFilter = @"all";
 
    [[AppHelper sharedInstance] loadshoeWithFilter:@"all"];
    
    if (!self.issuesArray) {
        self.issuesArray = [[NSMutableArray alloc]init];
    }
    [self.issuesArray removeAllObjects];
    for (ShoeInfo *info in [AppHelper sharedInstance].shoes) {
        IssueViewController *view = [[IssueViewController alloc]initWithShoe:info];
        [self.issuesArray addObject:view];
    }
    
    [self.gridView reloadData];
    
    [self openMenu:nil];
}

- (void)showFavorite
{
    self.title = @"Favorite";
    currentFilter = @"Favorite";
    [[AppHelper sharedInstance] loadshoeWithFilter:@"favorite"];
    
    if (!self.issuesArray) {
        self.issuesArray = [[NSMutableArray alloc]init];
    }
    
    [self.issuesArray removeAllObjects];
    for (ShoeInfo *info in [AppHelper sharedInstance].shoes) {
        IssueViewController *view = [[IssueViewController alloc]initWithShoe:info];
        [self.issuesArray addObject:view];
    }
    
    [self.gridView reloadData];
    [self openMenu:nil];
}

- (void)showArchived
{
    self.title = @"Archived";
    currentFilter = @"archived";

    [[AppHelper sharedInstance] loadshoeWithFilter:@"archived"];
    
    if (!self.issuesArray) {
        self.issuesArray = [[NSMutableArray alloc]init];
    }
    [self.issuesArray removeAllObjects];
    for (ShoeInfo *info in [AppHelper sharedInstance].shoes) {
        IssueViewController *view = [[IssueViewController alloc]initWithShoe:info];
        [self.issuesArray addObject:view];
    }
    
    [self.gridView reloadData];
    [self openMenu:nil];
}

- (void)showTag
{
    TagViewController *tagView = [[TagViewController alloc] initWithNibName:nil bundle:nil];
    tagView.delegate = self;
    tagView.bOnlyShow = TRUE;

    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tagView];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:nav animated:YES completion:nil];
    [self openMenu:nil];
}

- (void)filterByTag:(NSString *)tag
{
    self.title = tag;
    currentFilter = tag;

    [[AppHelper sharedInstance] loadshoeWithFilter:tag];
    
    
    if (!self.issuesArray) {
        self.issuesArray = [[NSMutableArray alloc]init];
    }
    [self.issuesArray removeAllObjects];
    for (ShoeInfo *info in [AppHelper sharedInstance].shoes) {
        IssueViewController *view = [[IssueViewController alloc]initWithShoe:info];
        [self.issuesArray addObject:view];
    }
    
    [self.gridView reloadData];
}

- (void)enterEditMode
{
    bEditMode = TRUE;
    
    [self updateSelected];
    
    [self.add setHidden:YES];
    
    ShoeInfo *sInfo = [[AppHelper sharedInstance].shoes objectAtIndex:0];
    
    UIBarButtonItem *cancleButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction:)] ;
    cancleButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = cancleButton;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIBarButtonItem *archiveBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ItemActions_Archive"] style:UIBarButtonItemStylePlain target:self action:@selector(archiveItems)];
        if (sInfo.bArchived) {
            archiveBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ItemActions_ReAdd"] style:UIBarButtonItemStylePlain target:self action:@selector(unarchiveItems)];
        }
        [archiveBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        UIBarButtonItem *favBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ItemActions_Favorite"] style:UIBarButtonItemStylePlain target:self action:@selector(favItems)];
        [favBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        UIBarButtonItem *delBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ItemActions_DeleteTrashCan"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteItems)];
        [delBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        UIBarButtonItem *tagBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ItemActions_Tag"] style:UIBarButtonItemStylePlain target:self action:@selector(tagItems)];
        [tagBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        NSMutableArray *buttonItems = [NSMutableArray arrayWithObjects:archiveBtn,favBtn,delBtn,tagBtn, Nil];
        
        self.navigationItem.leftBarButtonItems = buttonItems;
    }
    else
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        int edgewith = 20;
        int btnWidth = 30;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            edgewith = 100;
        }
        int betweenwidth = (size.width-edgewith*2-btnWidth)/3;
        int statusheight = 0;
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        {
            statusheight = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        
        self.bottomToolBar = [[UIView alloc]initWithFrame:CGRectMake(0,size.height-statusheight-40, size.width, 40)];
        UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shadow"]];
        [img setFrame:CGRectMake(0,0, size.width, 2)];
        [self.bottomToolBar addSubview:img];
        
        UIButton *archiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [archiveButton setFrame:CGRectMake(edgewith, 5, 30, 30)];
        if (sInfo.bArchived) {
            [archiveButton setImage:[UIImage imageNamed:@"ItemActions_ReAdd"] forState:UIControlStateNormal];
            [archiveButton addTarget:self action:@selector(unarchiveItems) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [archiveButton setImage:[UIImage imageNamed:@"ItemActions_Archive"] forState:UIControlStateNormal];
            [archiveButton addTarget:self action:@selector(archiveItems) forControlEvents:UIControlEventTouchUpInside];
        }

        [self.bottomToolBar addSubview:archiveButton];
        
        UIButton *favButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[favButton setTitle:@"Del" forState:UIControlStateNormal];
        [favButton setImage:[UIImage imageNamed:@"ItemActions_Favorite"] forState:UIControlStateNormal];
        [favButton setFrame:CGRectMake(edgewith+betweenwidth, 5, 30, 30)];
        [favButton addTarget:self action:@selector(favItems) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomToolBar addSubview:favButton];
        
        UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[delButton setTitle:@"Del" forState:UIControlStateNormal];
        [delButton setImage:[UIImage imageNamed:@"ItemActions_DeleteTrashCan"] forState:UIControlStateNormal];
        [delButton setFrame:CGRectMake(edgewith+betweenwidth*2, 5, 30, 30)];
        [delButton addTarget:self action:@selector(deleteItems) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomToolBar addSubview:delButton];
        
        UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // [tagButton setTitle:@"Del" forState:UIControlStateNormal];
        [tagButton setImage:[UIImage imageNamed:@"ItemActions_Tag"] forState:UIControlStateNormal];
        [tagButton setFrame:CGRectMake(edgewith+betweenwidth*3, 5, 30, 30)];
        [tagButton addTarget:self action:@selector(tagItems) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomToolBar addSubview:tagButton];
        
        self.bottomToolBar.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.bottomToolBar];
    }
    
}

- (void)archiveItems
{
//    [self.gridView beginUpdates];
    for (int i = 0; i< self.issuesArray.count; i++) {
        IssueViewController *issue = [self.issuesArray objectAtIndex:i];
        if (issue.bSelected) {
            [[AppHelper sharedInstance] archiveShoeWithTag:i];
//            NSIndexSet* set = [NSIndexSet indexSetWithIndex:i];
//            [self.gridView deleteItemsAtIndices:set withAnimation:AQGridViewItemAnimationFade];
            
//            [self.issuesArray removeObject:issue];
//            i--;
        }
    }
    
//    [self.gridView endUpdates];
    [self reloadData:nil];
    [self cancelAction:nil];
}

- (void)unarchiveItems
{
//    [self.gridView beginUpdates];
    for (int i = 0; i< self.issuesArray.count; i++) {
        IssueViewController *issue = [self.issuesArray objectAtIndex:i];
        if (issue.bSelected) {
            [[AppHelper sharedInstance] unarchiveShoeWithTag:i];
//            NSIndexSet* set = [NSIndexSet indexSetWithIndex:i];
//            [self.gridView deleteItemsAtIndices:set withAnimation:AQGridViewItemAnimationFade];
            
//            [self.issuesArray removeObject:issue];
//            i--;
        }
    }
    [self reloadData:nil];
//    [self.gridView reloadData];
//    [self.gridView endUpdates];
    [self cancelAction:nil];
}
- (void)favItems
{
    for (int i = 0; i< self.issuesArray.count; i++) {
        IssueViewController *issue = [self.issuesArray objectAtIndex:i];
        if (issue.bSelected) {
            [[AppHelper sharedInstance] favoriteShoeWithTag:i];
            
            [issue setFavorite];
        }
    }
    
    [self cancelAction:nil];
}

- (void)tagItems
{
    TagViewController *tagView = [[TagViewController alloc] initWithNibName:nil bundle:nil];
    tagView.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tagView];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:nav animated:YES completion:nil];

//    [self presentViewController:tagView animated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppAddTagClick" object:self]; // -> Analytics Event

}

- (void)addTag:(NSString *)tags
{
    [self.gridView beginUpdates];
    for (int i = 0; i< self.issuesArray.count; i++) {
        IssueViewController *issue = [self.issuesArray objectAtIndex:i];
        if (issue.bSelected) {
            [[AppHelper sharedInstance] addTag:tags toShoe:i];
            [issue updateTags:tags];
        }
    }
    
    [self.gridView endUpdates];
    [self cancelAction:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppAddTagSuccess" object:tags]; // -> Analytics Event
}

- (void)deleteItems
{
//    [self.gridView beginUpdates];
    for (int i = 0; i< self.issuesArray.count; i++) {
        IssueViewController *issue = [self.issuesArray objectAtIndex:i];
        if (issue.bSelected) {
            [[AppHelper sharedInstance] deleteShoeWithTag:i];
//            NSIndexSet* set = [NSIndexSet indexSetWithIndex:i];
//            [self.gridView deleteItemsAtIndices:set withAnimation:AQGridViewItemAnimationFade];
            
            [self.issuesArray removeObject:issue];
            i--;
        }
    }

//    [self.gridView endUpdates];
    [self.gridView reloadData];
    [self cancelAction:nil];

}
- (void)addNavigateButtons
{
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(openMenu:)];
    
    [menuButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addNewShoes)];
    
    [addButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = menuButton;
    self.navigationItem.rightBarButtonItem = addButton;
    
//    UIBarButtonItem *gridViewButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbar_grid"] style:UIBarButtonItemStylePlain target:self action:@selector(openHome:)];
//    
//    [gridViewButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    UIBarButtonItem *listViewButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbar_listview"] style:UIBarButtonItemStylePlain target:self action:@selector(openTimeline:)];
//    
//    [listViewButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//
//    NSMutableArray *buttonItems = [NSMutableArray arrayWithObjects:listViewButton,gridViewButton,nil];
//    self.navigationItem.rightBarButtonItems = buttonItems;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if (dimBackgroundView == touch.view) {
            [self openMenu:nil];
    }
}

- (void)loadShoe
{
//    [[AppHelper sharedInstance] resizeImages];
    [[AppHelper sharedInstance] loadshoes:FALSE];
    
    if (!self.issuesArray) {
        self.issuesArray = [[NSMutableArray alloc]init];
    }
    [self.issuesArray removeAllObjects];
    for (ShoeInfo *info in [AppHelper sharedInstance].shoes) {
        IssueViewController *view = [[IssueViewController alloc]initWithShoe:info];
        [self.issuesArray addObject:view];
    }
    
    [self.gridView reloadData];
    [SVProgressHUD dismiss];
}

- (void)addNewShoes
{
    if([AppHelper sharedInstance].shoes.count < 12 || [[AppHelper sharedInstance] readPurchaseInfo])
    {

        CGRect rect = [[UIScreen mainScreen] bounds];
        
        if (!self.containView) {
            UIViewController *subView = [[UIViewController alloc]init];
            [subView.view setFrame:rect];
            self.containView = subView;
            self.containView.view.backgroundColor = [UIColor clearColor];
        }
        
        [self.confirmView.view removeFromSuperview];
        ConfirmViewController *confirmView = [[ConfirmViewController alloc]initWithNibName:nil bundle:nil];
        self.confirmView = confirmView;
        [self.confirmView.view setFrame:rect];
        self.confirmView.delegate = self;
        [self.containView.view addSubview:self.confirmView.view];
        
        [self.addView.view removeFromSuperview];
        AddViewController *add = [[AddViewController alloc]initWithNibName:nil bundle:nil];
        self.addView = add;
        [self.addView.view setFrame:rect];
        self.addView.delegate = self;
        [self.containView.view addSubview:self.addView.view];
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [self presentViewController:self.containView animated:NO completion:nil];
        
        
    }
    else
    {
/*        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Upgrade to full version" message:@"Unlock new themes and manage more shoes" delegate:self cancelButtonTitle:@"Upgrade" otherButtonTitles:@"Cancel", nil];
        alert.delegate = self;
        [alert show];
        return;*/
        UpgradeViewController *upgrade = [[UpgradeViewController alloc]initWithNibName:nil bundle:nil];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:upgrade];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            navController.modalPresentationStyle = UIModalPresentationFormSheet;
        }
        
        [self presentViewController:navController animated:YES completion:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppReachPurchaseLimit" object:self]; // -> Analytics Event
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [[AppHelper sharedInstance] upgrade];
    }
}

- (void)saveImageSuccess
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.containView dismissViewControllerAnimated:YES completion:nil];
    self.containView = nil;
    
    IssueViewController *view = [[IssueViewController alloc]initWithShoe:[[AppHelper sharedInstance].shoes objectAtIndex:0]];
    
//    [self.gridView beginUpdates];
    [self.issuesArray insertObject:view atIndex:0];
    
//    NSIndexSet* set = [NSIndexSet indexSetWithIndex:0];
//    [self.gridView insertItemsAtIndices:set withAnimation:AQGridViewItemAnimationLeft];
//    [self.gridView endUpdates];
    [self.gridView reloadData];
    
    ShoeInfo *sinfo = [[AppHelper sharedInstance].shoes objectAtIndex:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppAddShoeSuccess" object:sinfo.name]; // -> Analytics Event

}

- (void)openShoe
{
    DetailViewController *detail = [[DetailViewController alloc]initWithNibName:nil bundle:nil];
    detail.delegate = self;
    [self.navigationController pushViewController:detail animated:YES];
}
- (void)confirm
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    
    if (self.confirmView) {
        [self.confirmView.view removeFromSuperview];
        ConfirmViewController *confirm = [[ConfirmViewController alloc]initWithNibName:nil bundle:nil];
        self.confirmView = confirm;
        [self.confirmView.view setFrame:rect];
        self.confirmView.delegate = self;
        [self.containView.view addSubview:self.confirmView.view];
    }
    
    [UIView transitionFromView:self.addView.view  toView:self.confirmView.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:NULL];
}

- (void)retake
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    if (self.addView) {
        [self.addView.view removeFromSuperview];
        AddViewController *add= [[AddViewController alloc]initWithNibName:nil bundle:nil];
        self.addView = add;
        [self.addView.view setFrame:rect];
        self.addView.delegate = self;
        [self.containView.view addSubview:self.addView.view];

    }
    [UIView transitionFromView:self.confirmView.view  toView:self.addView.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:NULL];
}

- (void)finish
{
    [self.gridView reloadData];
    
    self.containView.view.alpha = 0.0;
    [self.containView dismissViewControllerAnimated:NO completion:nil];
    self.containView = nil;
}

- (IBAction)cancelAction:(id)sender
{
    bEditMode = FALSE;
//    self.title = @"FAVO";
    //[self.add setHidden:NO];
    self.bottomToolBar.hidden = YES;
    [self addNavigateButtons];
    
    [IssueViewController setStatus:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:ExitEditModeNotify object:self];
    
//    self.title = @"FAVO";
    [self setTitleByFilter];
    
    [IssueViewController clearSelectCount];
}

- (void)setTitleByFilter{
    NSString *title = @"";
    if ([currentFilter isEqualToString:@"all"]) {
        title = @"FAVO";
    }
    else if ([currentFilter isEqualToString:@"archived"])
    {
        title = @"Archived";
    }
    else if ([currentFilter isEqualToString:@"favorite"])
    {
        title = @"Favorite";
    }
    else if (![currentFilter isEqualToString:@""])
    {
        title = @"FAVO";
    }
    
    [self setTitle:title];
}

//删除完毕，恢复正常状态
- (IBAction)commitEdit:(id)sender
{
    bEditMode = FALSE;
    
    [self.topToolBar setHidden:NO];
    //[self.add setHidden:NO];
    [self.gridView reloadData];
}

- (IBAction)addShoe:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppAddShoeClick" object:self]; // -> Analytics Event
    
    [self addNewShoes];
}

- (IBAction)openSetting:(id)sender {
    SettingViewController *set = [[SettingViewController alloc]initWithNibName:nil bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:set];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        navController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navController animated:YES completion:nil];
    
    [self openMenu:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppSettingClick" object:self]; // -> Analytics Event
}

- (NSUInteger)numberOfItemsInGridView:(AQGridView *)aGridView
{
    return self.issuesArray.count;
}

- (AQGridViewCell *)gridView:(AQGridView *)aGridView cellForItemAtIndex:(NSUInteger)index
{
    CGSize cellSize = [IssueViewController getIssueCellSize];
    CGRect cellFrame = CGRectMake(0, 0, cellSize.width, cellSize.height);
    
    static NSString *cellIdentifier = @"cellIdentifier";
    AQGridViewCell *cell = (AQGridViewCell *)[self.gridView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		cell = [[AQGridViewCell alloc] initWithFrame:cellFrame reuseIdentifier:cellIdentifier];
		cell.selectionStyle = AQGridViewCellSelectionStyleNone;
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
	}
    
    UIView *removableIssueView = [cell.contentView viewWithTag:42];
    if (removableIssueView) {
        [removableIssueView removeFromSuperview];
    }
    
    IssueViewController *controller = [self.issuesArray objectAtIndex:index];
    [cell.contentView addSubview:controller.view];
    
    return cell;
}

- (void)gridView:(AQGridView *)myGridView didSelectItemAtIndex:(NSUInteger)index
{
    [myGridView deselectItemAtIndex:index animated:NO];
}

- (CGSize)portraitGridCellSizeForGridView:(AQGridView *)aGridView
{
    return [IssueViewController getIssueCellSize];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (IBAction)myfavorite:(id)sender {
}

- (IBAction)myarchived:(id)sender {
}

- (IBAction)mytag:(id)sender {
}
#pragma mark -
#pragma mark iAds Methods

- (void)layoutAnimated:(BOOL)animated
{
    // As of iOS 6.0, the banner will automatically resize itself based on its width.
    // To support iOS 5.0 however, we continue to set the currentContentSizeIdentifier appropriately.
    CGRect contentFrame = self.view.bounds;
    _bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    
    CGRect bannerFrame = _bannerView.frame;
    if (_bannerView.bannerLoaded) {
        bannerFrame.origin.y = contentFrame.size.height-bannerFrame.size.height;
    } else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        _bannerView.frame = bannerFrame;
    }];
    
   // [self.view bringSubviewToFront:self.add];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    
    [self layoutAnimated:NO];
}

- (void)viewDidLayoutSubviews
{
    [self layoutAnimated:[UIView areAnimationsEnabled]];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self layoutAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self layoutAnimated:YES];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    
}


@end