//
//  IssueViewController.m
//  Baker
//
//  ==========================================================================================
//
//  Copyright (c) 2010-2013, Davide Casali, Marco Colombo, Alessandro Morandi
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are
//  permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this list of
//  conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this list of
//  conditions and the following disclaimer in the documentation and/or other materials
//  provided with the distribution.
//  Neither the name of the Baker Framework nor the names of its contributors may be used to
//  endorse or promote products derived from this software without specific prior written
//  permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
//  SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
//  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import <QuartzCore/QuartzCore.h>

#import "IssueViewController.h"
#import "DetailViewController.h"
#import "AppHelper.h"


@interface CustomButton : UIButton
@end
@implementation CustomButton

static int selectedCount = 0;
- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame])){
        [self setupView];
    }
    
    return self;
}

- (void)awakeFromNib {
    [self setupView];
}

# pragma mark - main

- (void)setupView
{
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor colorWithRed:167.0/255.0 green:140.0/255.0 blue:98.0/255.0 alpha:0.25].CGColor;
  //  self.layer.shadowColor = [UIColor blackColor].CGColor;
  //  self.layer.shadowRadius = 1;
    [self clearHighlightView];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.layer.bounds;
    gradient.cornerRadius = 10;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithWhite:1.0f alpha:1.0f].CGColor,
                       (id)[UIColor colorWithWhite:1.0f alpha:0.0f].CGColor,
                       (id)[UIColor colorWithWhite:0.0f alpha:0.0f].CGColor,
                       (id)[UIColor colorWithWhite:0.0f alpha:0.4f].CGColor,
                       nil];
    float height = gradient.frame.size.height;
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0.0f],
                          [NSNumber numberWithFloat:0.2*30/height],
                          [NSNumber numberWithFloat:1.0-0.1*30/height],
                          [NSNumber numberWithFloat:1.0f],
                          nil];
    [self.layer addSublayer:gradient];}

- (void)highlightView
{
    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.layer.shadowOpacity = 0.25;
}

- (void)clearHighlightView {
    self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
    self.layer.shadowOpacity = 0.5;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        [self highlightView];
    } else {
        [self clearHighlightView];
    }
    [super setHighlighted:highlighted];
}
@end

@implementation IssueViewController

#pragma mark - Synthesis

@synthesize actionButton;
@synthesize archiveButton;
@synthesize loadingLabel;
@synthesize priceLabel;

@synthesize issueCover;
@synthesize titleFont;
@synthesize infoFont;
@synthesize titleLabel;
@synthesize infoLabel;

@synthesize currentStatus;

static int curStatus = 0;

#pragma mark - Init
- (id)initWithShoe:(ShoeInfo*)shoe
{
    if (self = [super init]) {
        shoeInfo = shoe;
    }
    
    return self;
}
#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGSize cellSize = [IssueViewController getIssueCellSize];

    self.view.frame = CGRectMake(0, 0, cellSize.width, cellSize.height);
    self.view.backgroundColor = [UIColor clearColor];
//    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.view.tag = 42;
//    self.view.layer.cornerRadius = 5;
//    self.view.layer.masksToBounds = YES;
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellSize.width, cellSize.height-10)];
    self.bgView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    //bgView.tag = 42;
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    [self.view addSubview:self.bgView];

    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@-s.png", shoeInfo.sid]];

    self.bigImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-30)];
    self.bigImage.contentMode = UIViewContentModeScaleAspectFill;
    self.bigImage.clipsToBounds = YES;
    [self.bigImage setImage:[UIImage imageWithContentsOfFile:pngPath]];
    [self.bgView addSubview:self.bigImage];
    
    self.issueCover = [UIButton buttonWithType:UIButtonTypeCustom];
    issueCover.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-60);
    
   // [issueCover setBackgroundImage:[UIImage imageWithContentsOfFile:pngPath] forState:UIControlStateNormal];
   // [issueCover setImage:[UIImage imageWithContentsOfFile:pngPath] forState:UIControlStateNormal];
  //  issueCover.backgroundColor = [UIColor colorWithHexString:ISSUES_COVER_BACKGROUND_COLOR];
    issueCover.adjustsImageWhenHighlighted = NO;
    issueCover.adjustsImageWhenDisabled = NO;
    issueCover.layer.cornerRadius = 10;
   // issueCover.layer.masksToBounds = YES;
  //  issueCover.layer.shadowOpacity = 0.5;
  //  issueCover.layer.shadowOffset = CGSizeMake(0, 2);
    issueCover.layer.shouldRasterize = YES;
    issueCover.layer.rasterizationScale = [UIScreen mainScreen].scale;

    [issueCover addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:issueCover];

    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height-30, cellSize.width, 1)];
    line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:line];

    if (shoeInfo.bFavorite) {
        [self setFavorite];
    }
    
    [self updateTags:shoeInfo.tags];

    // SETUP TITLE LABEL
    UIFont *tagFont = [UIFont fontWithName:@"Helvetica" size:11.0];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame = CGRectMake(0, cellSize.height-65, cellSize.width, 40);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 2;
    titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.font = tagFont;
    titleLabel.textColor = [UIColor blackColor];
    [titleLabel setText:shoeInfo.name];
    [self.view addSubview:titleLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    //长按事件
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handlelongpress:)];
    
    longpress.minimumPressDuration = 0.3; //0.6秒长按
    [self.view addGestureRecognizer:longpress];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(exitEditMode)
												 name:ExitEditModeNotify
											   object:nil];

}

- (void)handleTap:(UIGestureRecognizer*)gestureRecognizer
{
    if (curStatus == 1)
    {
        [self deselected];
        return;
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded)
    {
        [[AppHelper sharedInstance] loadShoe:shoeInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kOpenShoe object:self];

    }
}
- (void)exitEditMode
{
    curStatus = 0;
    
    [self deselected];
}
/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if (self.topView == touch.view) {
        [self deselected];
    }
}*/

//长按屏幕,切换到编辑模式
-(void) handlelongpress:(UIGestureRecognizer*)gestureRecognizer
{
    if (curStatus == 1)
    {
        return;
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
    {
        curStatus = 1;
        
        [self selected];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EnterEditModeNotify object:self];
    }
    
}

- (void)selected
{
    self.bSelected = TRUE;
    
    self.topView = [[UIView alloc]initWithFrame:self.bgView.frame];
    self.topView.backgroundColor = [UIColor grayColor];
    self.topView.alpha = 0.7;
    self.topView.layer.cornerRadius = 5;
    self.topView.layer.masksToBounds = YES;
    [self.view addSubview:self.topView];
    
    selectedCount++;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateSelectedNotify object:self];

}

- (void)deselected
{
    if (!self.bSelected) {
        return;
    }
    self.bSelected = FALSE;
    
    [self.topView removeFromSuperview];
    
    selectedCount--;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UpdateSelectedNotify object:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)actionButtonPressed:(UIButton *)sender
{
    if (curStatus == 1) {
        [self selected];
    }
    else
    {
        [[AppHelper sharedInstance] loadShoe:shoeInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kOpenShoe object:self];
    }
}

- (void)updateTags:(NSString*)tags
{
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        if (v.tag == 40) {
            [v removeFromSuperview];
        }
    }
    
    UIView *tagView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-27, self.view.frame.size.width, 20)];
    tagView.backgroundColor = [UIColor clearColor];
    tagView.tag = 40;
    [self.view addSubview:tagView];
    
    NSArray *tagArray = [tags componentsSeparatedByString:@"|"];
    
    UIFont *tagFont = [UIFont fontWithName:@"Helvetica" size:12.0];
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

- (void)setFavorite
{
    self.favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.favBtn.frame = CGRectMake(self.view.frame.size.width-36, self.view.frame.size.height-96, 36, 36);
    self.favBtn.backgroundColor = [UIColor clearColor];
    [self.favBtn setImage:[UIImage imageNamed:@"favorite-star"] forState:UIControlStateNormal];
    [self.view addSubview:self.favBtn];
}

+ (int)getIssueCellHeight
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 200;
    } else {
        return 140;
    }
}
+ (CGSize)getIssueCellSize
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return CGSizeMake((screenRect.size.width-60)/ 3 , (screenRect.size.width-60) *1.5/ 3+20);
    } else {
        //return CGSizeMake((screenRect.size.width - 20)/2, (screenRect.size.width - 20) *1.5/2+60);
        return CGSizeMake((screenRect.size.width - 20)/2, (screenRect.size.width - 20)/2);
    }
}

+ (void)setStatus:(int)status
{
    curStatus = status;
}

+ (int)selectedCount
{
    return selectedCount;
}

@end
