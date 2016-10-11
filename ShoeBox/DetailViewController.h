//
//  DetailViewController.h
//  myshoe
//
//  Created by andy on 13-4-16.
//  Copyright (c) 2013年 somolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteViewController.h"
#import "AQGridView.h"
#import "TagViewController.h"

@class DetailViewController;
@protocol DetailViewControllerDelegate <NSObject>

- (void )reloadData:(DetailViewController *)detailView;

@end
@interface DetailViewController : UIViewController<NoteViewDelegate,UIDocumentInteractionControllerDelegate,AQGridViewDataSource,AQGridViewDelegate,TagViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *sectionView;
    BOOL boxisBig;

}

@property (strong, nonatomic) id<DetailViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *relatedIssueArray;

@property (strong, nonatomic) UIImageView *bigImage;
@property (strong, nonatomic) UIImageView *smallImage;

@property (strong, nonatomic) AQGridView *gridView;
@property (nonatomic,strong) UITableView *notetable;
@property (nonatomic,strong) NoteViewController *noteview;
@property (strong, nonatomic) IBOutlet UIButton *shartBtn;
@property (nonatomic, strong) UIDocumentInteractionController *interactionController;
@property (strong) UITapGestureRecognizer * tapRecognizer;
@property (strong) UITapGestureRecognizer * doubleTapRecognizer;
@property (strong) UISwipeGestureRecognizer * swipeRightRecognizer;
@property (strong,nonatomic) UIPopoverController *detailViewPopover;
@property (strong,nonatomic) UIButton *favBtn;
@property (strong,nonatomic) UIBarButtonItem *favNavBtn;
- (IBAction)goback:(id)sender;
- (IBAction)writeNote:(id)sender;
- (IBAction)share:(id)sender;
@end
