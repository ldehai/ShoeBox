//
//  DetailViewController.m
//  myshoe
//
//  Created by andy on 13-4-16.
//  Copyright (c) 2013年 somolo. All rights reserved.
//

#import "DetailViewController.h"
#import "AppHelper.h"
#import "NoteInfo.h"
#import <Social/Social.h>
//#import "TableViewCell.h"
#import "IssueViewController.h"
#import "TagViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "ShareViewController.h"

@interface DetailViewController ()<MFMailComposeViewControllerDelegate>
{
    ScrollDirection scrollDirection;
    int lastContentOffset;
    BOOL bShowShare;
}
@property (strong, nonatomic) UIPopoverController *activityPopover;
@property (strong, nonatomic) UIBarButtonItem *shareButton;
@end

@implementation DetailViewController

#define NORMAL_CELL_HEIGHT 40

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


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
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"Detail"];
    
    self.view.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1.0];

    if (!self.relatedIssueArray) {
        self.relatedIssueArray = [[NSMutableArray alloc]init];
    }

    for (ShoeInfo *info in [AppHelper sharedInstance].shoes) {
        IssueViewController *view = [[IssueViewController alloc]initWithShoe:info];
        [self.relatedIssueArray addObject:view];
    }
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goHome)];
    
    [addButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
  //  self.navigationItem.leftBarButtonItem = addButton;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    // [tagButton setTitle:@"Del" forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"share-services"] forState:UIControlStateNormal];
    [shareButton setFrame:CGRectMake(0, 0, 30, 30)];
    [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    self.shareButton = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
   // self.shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
    
    //[self.shareButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //[self.shareButton setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = self.shareButton;

    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShown:)
												 name:UIKeyboardWillShowNotification
											   object:nil];

    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGRect sectionFrame = CGRectMake(0.0, 0.0, size.width,  size.width*0.65);
    sectionView = [[UIView alloc] initWithFrame:sectionFrame];
    sectionView.backgroundColor = [UIColor clearColor];
    
    CGRect bigImageRect = CGRectMake(0.0, 10, size.width/2+20,  size.width/2+20);
    self.bigImage = [[UIImageView alloc]initWithFrame:bigImageRect];
    self.bigImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.bigImage setImage:[UIImage imageWithContentsOfFile:[AppHelper sharedInstance].sinfo.boxpng]];
    
    //self.smallImage = [[UIImageView alloc]initWithFrame:CGRectMake(size.width*2/3, size.width*2/3, size.width/3,  size.width/3)];
    self.smallImage = [[UIImageView alloc]initWithFrame:CGRectMake(size.width/2-20,10,size.width/2+20,size.width/2+20)];
    self.smallImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.smallImage setImage:[UIImage imageWithContentsOfFile:[AppHelper sharedInstance].sinfo.shoepng]];
    [sectionView addSubview:self.bigImage];
    [sectionView addSubview:self.smallImage];
    [self updateTags:[AppHelper sharedInstance].sinfo.tags];
    
    int statusheight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    int top = 0;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        top = statusheight;
    }
    
/*    self.gridView = [[AQGridView alloc] init];
    self.gridView.dataSource = self;
    self.gridView.delegate = self;
    self.gridView.backgroundColor = [UIColor clearColor];
    [self.gridView setFrame:CGRectMake(0, 10, size.width, size.height-top-10)];
    self.gridView.showsVerticalScrollIndicator = NO;
    self.gridView.gridHeaderView = sectionView;
    
    [self.view addSubview:self.gridView];
    */
    
    self.notetable = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, size.width-20, size.height) style:UITableViewStylePlain];
    self.notetable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.notetable.dataSource = self;
    self.notetable.delegate = self;
    self.notetable.backgroundColor = [UIColor clearColor];
    self.notetable.backgroundView.backgroundColor = [UIColor clearColor];
    self.notetable.tableHeaderView = sectionView;
    [self.view addSubview:self.notetable];
    
    self.doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    self.doubleTapRecognizer.numberOfTapsRequired = 2;
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.tapRecognizer requireGestureRecognizerToFail:self.doubleTapRecognizer];
  //  [sectionView addGestureRecognizer:self.tapRecognizer];
    
    self.swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightSwipe:)];
    self.swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:self.swipeRightRecognizer];

    boxisBig = YES;
    
    [self.gridView reloadData];
    
    [self loadMenuBar];
    

}

- (void)loadMenuBar
{
   // self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedItem.width = 20.0f;
        
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"toolbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(goback:)];
        [backBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

        UIBarButtonItem *archiveBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ItemActions_Archive"] style:UIBarButtonItemStylePlain target:self action:@selector(archiveItem)];
        if ([AppHelper sharedInstance].sinfo.bArchived) {
            archiveBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ItemActions_ReAdd"] style:UIBarButtonItemStylePlain target:self action:@selector(unarchiveItem)];
        }
        [archiveBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        UIImage *image = [UIImage imageNamed:@"ItemActions_Favorite"];
        
        UIButton *favbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [favbutton setImage:[UIImage imageNamed:@"ItemActions_Favorite"] forState:UIControlStateNormal];
        [favbutton setFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [favbutton addTarget:self action:@selector(favItem) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *favBtn = [[UIBarButtonItem alloc] initWithCustomView:favbutton];
       // UIBarButtonItem *favBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ItemActions_Favorite"] style:UIBarButtonItemStylePlain target:self action:@selector(favItem)];
       // favBtn.tintColor = [UIColor clearColor];
        if ([AppHelper sharedInstance].sinfo.bFavorite)
        {
            [favbutton setImage:[UIImage imageNamed:@"ItemActions_Favorite_Yellow"] forState:UIControlStateNormal];
            favBtn = [[UIBarButtonItem alloc] initWithCustomView:favbutton];
        }
        self.favBtn = favbutton;
       // UIBarButtonItem *delBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ItemActions_DeleteTrashCan"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteItems)];
        
        UIBarButtonItem *tagBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ItemActions_Tag"] style:UIBarButtonItemStylePlain target:self action:@selector(tagItem)];
        [tagBtn setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        NSMutableArray *buttonItems = [NSMutableArray arrayWithObjects:backBtn,fixedItem,archiveBtn,fixedItem,favBtn,fixedItem,tagBtn, Nil];
        
        self.navigationItem.leftBarButtonItems = buttonItems;
    }
    else
    {
        [self.navigationController.navigationBar setHidden:YES];
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.backBarButtonItem = nil;

        [self setTitle:@""];
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        int edgewith = 20;
        int btnWidth = 30;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            edgewith = 100;
        }
        int betweenwidth = (size.width-edgewith*2-btnWidth)/4;
        int statusheight = 0;
        
        if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
        {
            statusheight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        
        UIView *bottomToolBar = [[UIView alloc]initWithFrame:CGRectMake(0,size.height-statusheight-40, size.width, 40)];
        UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shadow"]];
        [img setFrame:CGRectMake(0,0, size.width, 2)];
        [bottomToolBar addSubview:img];

        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[archiveButton setTitle:@"Del" forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"toolbar_back"] forState:UIControlStateNormal];
        [backButton setFrame:CGRectMake(edgewith, 5, 30, 30)];
        [backButton addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
        [bottomToolBar addSubview:backButton];
        
        UIButton *archiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[archiveButton setTitle:@"Del" forState:UIControlStateNormal];
        [archiveButton setImage:[UIImage imageNamed:@"ItemActions_Archive"] forState:UIControlStateNormal];
        [archiveButton setFrame:CGRectMake(edgewith+betweenwidth, 5, 30, 30)];
        [archiveButton addTarget:self action:@selector(archiveItem) forControlEvents:UIControlEventTouchUpInside];
        if ([AppHelper sharedInstance].sinfo.bArchived) {
            [archiveButton setImage:[UIImage imageNamed:@"ItemActions_ReAdd"] forState:UIControlStateNormal];
            [archiveButton addTarget:self action:@selector(unarchiveItem) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [bottomToolBar addSubview:archiveButton];
        
        UIButton *favButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[favButton setTitle:@"Del" forState:UIControlStateNormal];
        [favButton setImage:[UIImage imageNamed:@"ItemActions_Favorite"] forState:UIControlStateNormal];
        [favButton setFrame:CGRectMake(edgewith+betweenwidth*2, 5, 30, 30)];
        [favButton addTarget:self action:@selector(favItem) forControlEvents:UIControlEventTouchUpInside];
        if ([AppHelper sharedInstance].sinfo.bFavorite)
        {
            [favButton setImage:[UIImage imageNamed:@"ItemActions_Favorite_Yellow"] forState:UIControlStateNormal];
            [favButton addTarget:self action:@selector(favItem) forControlEvents:UIControlEventTouchUpInside];
        }
        self.favBtn = favButton;
        [bottomToolBar addSubview:favButton];
        
//        UIButton *delButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        //[delButton setTitle:@"Del" forState:UIControlStateNormal];
//        [delButton setImage:[UIImage imageNamed:@"ItemActions_DeleteTrashCan"] forState:UIControlStateNormal];
//        [delButton setFrame:CGRectMake(edgewith+betweenwidth*2, 5, 30, 30)];
//        [delButton addTarget:self action:@selector(deleteItem) forControlEvents:UIControlEventTouchUpInside];
//        [bottomToolBar addSubview:delButton];
        
        UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // [tagButton setTitle:@"Del" forState:UIControlStateNormal];
        [tagButton setImage:[UIImage imageNamed:@"ItemActions_Tag"] forState:UIControlStateNormal];
        [tagButton setFrame:CGRectMake(edgewith+betweenwidth*3, 5, 30, 30)];
        [tagButton addTarget:self action:@selector(tagItem) forControlEvents:UIControlEventTouchUpInside];
        [bottomToolBar addSubview:tagButton];
        
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // [tagButton setTitle:@"Del" forState:UIControlStateNormal];
        [shareButton setImage:[UIImage imageNamed:@"share-services"] forState:UIControlStateNormal];
        [shareButton setFrame:CGRectMake(edgewith+betweenwidth*4, 5, 30, 30)];
        [shareButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
        [bottomToolBar addSubview:shareButton];
        
        bottomToolBar.backgroundColor = [UIColor clearColor];
        [self.view addSubview:bottomToolBar];
    }
}

- (void)updateTags:(NSString*)tags
{
    NSArray *viewsToRemove = [sectionView subviews];
    for (UIView *v in viewsToRemove) {
        if (v.tag == 40) {
            [v removeFromSuperview];
        }
    }
    
    UIView *tagView = [[UIView alloc]initWithFrame:CGRectMake(0, sectionView.frame.size.height-15, self.view.frame.size.width, 20)];
    tagView.backgroundColor = [UIColor clearColor];
    tagView.tag = 40;
    [sectionView addSubview:tagView];
    
    NSArray *tagArray = [tags componentsSeparatedByString:@"|"];
    
    UIFont *tagFont = [UIFont fontWithName:@"Helvetica" size:11.0];
    int tagwidth = 2;
    int tagHeight = 0;
    for (NSString *item in tagArray) {
        if ([item isEqualToString:@""]) {
            continue;
        }
        CGSize tagSize = [item sizeWithFont:tagFont constrainedToSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail];
        
        //check if reach to line end, so change to next line
        if (tagwidth + tagSize.width > self.view.frame.size.width) {
            //  tagwidth = 0;
            //  tagHeight += tagSize.height + 2;
            
            break;
        }
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(tagwidth, tagHeight, tagSize.width, tagSize.height)];
        lb.backgroundColor = [UIColor grayColor];
        lb.textColor = [UIColor whiteColor];
        lb.layer.cornerRadius = 3.0;
        lb.text = item;
        lb.font = tagFont;
        [tagView addSubview:lb];
        
        tagwidth += tagSize.width+2;
    }
}

- (void)goHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)handleRightSwipe:(UISwipeGestureRecognizer *)swipeRecognizer {

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)archiveItem
{
    [[AppHelper sharedInstance] archiveCurrentShoe];
    [self.delegate reloadData:self];
    [self goback:nil];
}

- (void)unarchiveItem
{
    [[AppHelper sharedInstance] unarchiveCurrentShoe];
    [self.delegate reloadData:self];
    [self goback:nil];
}
- (void)favItem
{
    if ([AppHelper sharedInstance].sinfo.bFavorite)
    {
        [self.favNavBtn setImage:[UIImage imageNamed:@"ItemActions_Favorite"]];
        [self.favBtn setImage:[UIImage imageNamed:@"ItemActions_Favorite"] forState:UIControlStateNormal];
        [[AppHelper sharedInstance] unfavoriteCurrentShoe];
    }
    else
    {
        [self.favNavBtn setImage:[UIImage imageNamed:@"ItemActions_Favorite_Yellow"]];
        [self.favBtn setImage:[UIImage imageNamed:@"ItemActions_Favorite_Yellow"] forState:UIControlStateNormal];
        [[AppHelper sharedInstance] favoriteCurrentShoe];
    }
    
    [self.delegate reloadData:self];
}

- (void)unfavItem
{
    [self.favBtn setImage:[UIImage imageNamed:@"ItemActions_Favorite"] forState:UIControlStateNormal];

    [[AppHelper sharedInstance] unfavoriteCurrentShoe];
    [self.delegate reloadData:self];
}
- (void)tagItem
{
    TagViewController *tagView = [[TagViewController alloc] initWithNibName:nil bundle:nil];
    tagView.delegate = self;
    tagView.showSelectedTags = YES;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:tagView];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:nav animated:YES completion:nil];
    
    //    [self presentViewController:tagView animated:YES completion:nil];
    
}

- (void)addTag:(NSString *)tags
{
    [[AppHelper sharedInstance] addTag2CurrentShoe:tags];
    [self.delegate reloadData:self];
    
    [self updateTags:tags];
}

- (IBAction)writeNote:(id)sender
{
    [self.noteview.view removeFromSuperview];
    
    NoteInfo *ninfo = (NoteInfo*)sender;
    self.noteview = [[NoteViewController alloc]initWithNibName:@"NoteViewController" bundle:nil];
    if ([ninfo isKindOfClass:[NoteInfo class]]) {
        self.noteview.note = ninfo;
    }
    self.noteview.delegate = self;
    
//    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGSize size = self.view.frame.size;
    CGRect frame = self.noteview.view.frame;
    frame.origin.y = size.height;
    frame.size.width = size.width;
    self.noteview.view.frame = frame;
    
    [self.view addSubview:self.noteview.view];
}

- (void) keyboardWillShown:(NSNotification *)nsNotification {
    NSDictionary *userInfo = [nsNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSLog(@"Height: %f Width: %f", kbSize.height, kbSize.width);
    CGRect keyboardRect = [aValue CGRectValue];
    // Portrait:    Height: 264.000000  Width: 768.000000
    // Landscape:   Height: 1024.000000 Width: 352.000000
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
//    CGRect frame = self.noteview.view.frame;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        CGRect frame = self.noteview.view.frame;
        if (keyboardRect.origin.y != size.height) {
            if ([SLComposeViewController instanceMethodForSelector:@selector(isAvailableForServiceType)] == nil)
            {
                frame.origin.y = keyboardRect.origin.y-frame.size.height+40;
            }
            else
            {
                frame.origin.y = keyboardRect.origin.y-frame.size.height;
            }
        }
        self.noteview.view.frame = frame;
        
    } completion:^(BOOL finished) {
    }];
}

- (void)share:(id)sender{
    
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        NSURL *URL = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"file://%@", [AppHelper sharedInstance].sinfo.shoepng]];
        
        if (!URL) {
            return;
        }
        UIDocumentInteractionController *controller = [UIDocumentInteractionController interactionControllerWithURL:URL];
        controller.annotation = @{ @"TumblrCaption" : @"Send From ShoeBox App.", @"TumblrTags" : @[ @"foo", @"bar" ] };
        controller.delegate = self;
        self.interactionController = controller;
        
        CGSize size = [[UIScreen mainScreen] bounds].size;
        [controller presentOpenInMenuFromRect:CGRectMake(0, 0,size.width , size.height) inView:self.view animated:YES];
    }
    else
    {
        UIImage *image = [UIImage imageWithContentsOfFile:[AppHelper sharedInstance].sinfo.shoepng];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            //iPhone, present activity view controller as is.
            [self presentViewController:activityViewController animated:YES completion:nil];
        }
        else
        {
            //iPad, present the view controller inside a popover.
            if (![self.activityPopover isPopoverVisible]) {
                self.activityPopover = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
                [self.activityPopover presentPopoverFromBarButtonItem:self.shareButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            }
            else
            {
                //Dismiss if the button is tapped while popover is visible.
                [self.activityPopover dismissPopoverAnimated:YES];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppShareClick" object:self]; // -> Analytics Event
/*    [self.detailViewPopover dismissPopoverAnimated:YES];
    
    ShareViewController *share = [[ShareViewController alloc]initWithNibName:nil bundle:nil];
	self.detailViewPopover = [[UIPopoverController alloc] initWithContentViewController:share];
	self.detailViewPopover.popoverContentSize = CGSizeMake(150, 50);
	self.detailViewPopover.delegate = self;
    self.detailViewPopover.backgroundColor = [UIColor clearColor];
    
    [self.detailViewPopover presentPopoverFromBarButtonItem:self.shareButton permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];*/

}


- (void)shareIt:(int)index
{
    switch (index) {
        case 1:
            [self performSelector:@selector(emailit) withObject:nil afterDelay:.1];
            break;
        case 2:
            [self performSelector:@selector(tweet) withObject:nil afterDelay:.1];
            break;
        case 3:
            [self performSelector:@selector(facebookPost) withObject:nil afterDelay:.1];
            break;
        case 4:
            [self performSelector:@selector(pinit) withObject:nil afterDelay:.1];
            break;
            
        default:
            break;
    }
}

- (void)emailit
{
    if ([MFMailComposeViewController canSendMail]==YES)
    {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        
        if ([AppHelper sharedInstance].sinfo.name)
            [controller setSubject:[NSString stringWithFormat:@"hi,look at my new shoe: %@",[AppHelper sharedInstance].sinfo.name]];
        
        //Create a string with HTML formatting for the email body
        NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@"<html><body><a href=https://itunes.apple.com/cn/app/shoebox-find-your-shoes-quickly/id640885172?l=en&mt=8>Send From ShoeBox App, View in App Store</a></body></html>"];
        [controller setMessageBody:emailBody isHTML:YES];
        
        NSData *myData = [NSData dataWithContentsOfFile:[AppHelper sharedInstance].sinfo.shoepng];
        NSString *fileName = [AppHelper sharedInstance].sinfo.name;
        [controller addAttachmentData:myData mimeType:@"image/png" fileName:fileName];

        [self presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        NSString *deviceType = [UIDevice currentDevice].model;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                                        message:[NSString stringWithFormat:NSLocalizedString(@"Your %@ must have an email account set up", @""), deviceType]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Ok", @"")
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)tweet
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [tweetSheet dismissViewControllerAnimated:YES completion:Nil];
        };
        tweetSheet.completionHandler =myBlock;
        
        [tweetSheet setInitialText:[NSString stringWithFormat:@"hi,look at my new shoe %@",[AppHelper sharedInstance].sinfo.name]];
        [tweetSheet addImage:[UIImage imageWithContentsOfFile:[AppHelper sharedInstance].sinfo.shoepng]];
        
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
        }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"No Twitter Accounts"
                                  message:@"There are no Twitter accounts configured.You can add or create a Twitter account in Settings."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)facebookPost
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [tweetSheet dismissViewControllerAnimated:YES completion:Nil];
        };
        tweetSheet.completionHandler =myBlock;
        
        [tweetSheet setInitialText:[NSString stringWithFormat:@"hi,look at my new shoe %@",[AppHelper sharedInstance].sinfo.name]];
        [tweetSheet addImage:[UIImage imageWithContentsOfFile:[AppHelper sharedInstance].sinfo.shoepng]];

        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"No Facebook Account"
                                  message:@"There are no Facebook accounts configured. You can add or create a Facebook account in Settings."
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}
/*
- (void)pinit
{
    NSURL *imageURL     = nil;//[NSURL URLWithString:book.coverUrl];
    NSURL *sourceURL    = [NSURL URLWithString:@"http://www.barnesjewish.org/newsstand"];
    
    
    [pinterest createPinWithImageURL:imageURL
                           sourceURL:sourceURL
                         description:[NSString stringWithFormat:@"Check this article on %@",book.title]];
}

*/
/*
- (IBAction)share:(id)sender
{
    //Create an activity view controller with the profile as its activity item. APLProfile conforms to the UIActivityItemSource protocol.
    UIImage *img = [UIImage imageWithContentsOfFile:[AppHelper sharedInstance].sinfo.shoepng];
    NSString *str = [[NSString alloc] initWithFormat:@"file://%@", [AppHelper sharedInstance].sinfo.shoepng];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[img] applicationActivities:nil];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //iPhone, present activity view controller as is.
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    else
    {
        //iPad, present the view controller inside a popover.
        if (![self.activityPopover isPopoverVisible]) {
            self.activityPopover = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
            [self.activityPopover presentPopoverFromBarButtonItem:self.shareButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else
        {
            //Dismiss if the button is tapped while popover is visible.
            [self.activityPopover dismissPopoverAnimated:YES];
        }
    }
}
*/
- (void)handleTap:(UITapGestureRecognizer *)tapRecognizer {
    NSLog(@"Tap!");
    [self swapShoeBox];
}

- (void)swapShoeBox
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    boxisBig = !boxisBig;
    
    if (boxisBig) {
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {
            CGRect bigImageRect = CGRectMake(0.0, 0.0, size.width,  size.width);

            [self.bigImage setFrame:bigImageRect];
            [self.smallImage setFrame:CGRectMake(size.width*2/3, size.width*2/3, size.width/3,  size.width/3)];
            [sectionView bringSubviewToFront:self.smallImage];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    else{
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {
            [self.bigImage setFrame:CGRectMake(size.width*2/3, size.width*2/3, size.width/3,  size.width/3)];
            CGRect bigImageRect = CGRectMake(0.0, 0.0, size.width,  size.width);
            [self.smallImage setFrame:bigImageRect];
            [sectionView bringSubviewToFront:self.bigImage];
            
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)doubletapRecognizer {
    NSLog(@"Double Tap!");
}

-(void)cancel
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        CGRect frame = self.noteview.view.frame;
        frame.origin.y = size.height;
        self.noteview.view.frame = frame;
        
    } completion:^(BOOL finished) {
    }];
}

-(void)saveNote:(NSString *)content
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        CGRect frame = self.noteview.view.frame;
        frame.origin.y = size.height;
        self.noteview.view.frame = frame;
        
    } completion:^(BOOL finished) {
    }];
    
    //内容为空，直接返回
    if ([content isEqualToString:@""]) {
        return;
    }
    [[AppHelper sharedInstance] addtimelineWithComment:content];
    [self.notetable reloadData];
}

- (void)updateTimeline:(NoteInfo *)nInfo
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        CGRect frame = self.noteview.view.frame;
        frame.origin.y = size.height;
        self.noteview.view.frame = frame;
        
    } completion:^(BOOL finished) {
    }];
    
    [[AppHelper sharedInstance] updateTimeline:nInfo];
    
    NSIndexPath *indexpath = [self.notetable indexPathForSelectedRow];
    [[AppHelper sharedInstance].shoenotes replaceObjectAtIndex:indexpath.row withObject:nInfo];
    [self.notetable reloadData];
    
}
/*
- (NSUInteger)numberOfItemsInGridView:(AQGridView *)aGridView
{
    return self.relatedIssueArray.count;
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
    
    IssueViewController *controller = [self.relatedIssueArray objectAtIndex:index];
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
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [AppHelper sharedInstance].shoenotes.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

//每行风格和内容
- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:14];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:14];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NoteInfo *ninfo = [[AppHelper sharedInstance].shoenotes objectAtIndex:indexPath.row];
    cell.textLabel.text = ninfo.signtime;
    cell.detailTextLabel.text = ninfo.content;
    
    if (indexPath.row%2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:1.0];
        cell.contentView.alpha = 0.9;
    }
    else
    {
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.contentView.alpha = 1.0;
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (self.PanIndexPath) {
//        [self resetPanCell];
//        return;
//    }
    
    NoteInfo *ninfo = [[AppHelper sharedInstance].shoenotes objectAtIndex:indexPath.row];
    
    [self writeNote:ninfo];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    int count = [AppHelper sharedInstance].shoenotes.count;
    int offset = count > 3?count-3:0;
    [self.notetable setContentOffset:CGPointMake(0,offset*NORMAL_CELL_HEIGHT) animated:YES];
}


- (void)viewDidUnload {
    [self setShartBtn:nil];
    [super viewDidUnload];
}
@end
