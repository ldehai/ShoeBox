//
//  AddViewController.h
//  ShoeBox
//
//  Created by andy on 13-6-19.
//  Copyright (c) 2013年 AM Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddViewControllerDelegate <NSObject>

- (void) confirm;
- (void) finish;

@end

@interface AddViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) id<AddViewControllerDelegate> delegate;
@property (nonatomic,strong) UIImagePickerController *uip;
@property (nonatomic,strong) UIImageView *bottomimage;
@property (nonatomic,strong) UIImageView *rectimage;
@property (nonatomic,strong) UIButton *boxbtn;
@property (nonatomic,strong) UIButton *shoebtn;
@property (nonatomic,strong) UIButton *capture;
@property (nonatomic,strong) UIButton *cancelbtn;
@property (nonatomic,strong) UILabel *lbcount;
@property (nonatomic,assign) int type;
@property (nonatomic, strong) NSTimer *tickTimer;
@property (strong) UISwipeGestureRecognizer * swipeRightRecognizer;

- (void)takephoto;
@end
