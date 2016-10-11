//
//  ConfirmViewController.h
//  myshoe
//
//  Created by andy on 13-4-16.
//  Copyright (c) 2013年 somolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfirmViewControllerDelegate <NSObject>

- (void) retake;
- (void) finish;

@end

@interface ConfirmViewController : UIViewController<UITextFieldDelegate>
{
    int moveheight;
}
@property (nonatomic,strong) id<ConfirmViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *bigImage;
@property (strong, nonatomic) IBOutlet UIImageView *smallImage;
@property (strong, nonatomic) IBOutlet UITextField *note;
@property (strong, nonatomic) IBOutlet UIButton *retake;
@property (strong, nonatomic) IBOutlet UIButton *btnsave;

- (IBAction)takephoto:(id)sender;
- (IBAction)save:(id)sender;
@end
