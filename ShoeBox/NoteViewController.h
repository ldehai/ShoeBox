//
//  NoteViewController.h
//  myshoe
//
//  Created by andy on 13-4-26.
//  Copyright (c) 2013年 somolo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteInfo.h"

@protocol NoteViewDelegate <NSObject>

- (void)saveNote:(NSString*)content;
- (void)updateTimeline:(NoteInfo*)nInfo;
- (void)cancel;

@end

@interface NoteViewController : UIViewController

@property (strong, nonatomic) id <NoteViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextView *notetext;
@property (strong, nonatomic) NoteInfo *note;
- (IBAction)btncancel:(id)sender;
- (IBAction)btnsave:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnfacebook;
@property (strong, nonatomic) IBOutlet UIButton *btntwitter;
@property (strong, nonatomic) IBOutlet UIButton *btntumblr;
@property (strong, nonatomic) IBOutlet UIButton *btngplus;
@property (strong, nonatomic) IBOutlet UIButton *btnsinaweibo;
@property (strong, nonatomic) IBOutlet UIButton *btnmail;
@property (strong, nonatomic) IBOutlet UILabel *lbshare;
- (IBAction)sharebtnclick:(id)sender;
@end
