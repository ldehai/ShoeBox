//
//  ConfirmViewController.m
//  myshoe
//
//  Created by andy on 13-4-16.
//  Copyright (c) 2013年 somolo. All rights reserved.
//

#import "ConfirmViewController.h"
#import "AppHelper.h"
#import "UIImage+fixOrientation.h"

@interface ConfirmViewController ()

@end

@implementation ConfirmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  /*  [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShown:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
*/
    
    if([[AppHelper sharedInstance] capturedImages].count != 0)
    {
        UIImage *image = [[[AppHelper sharedInstance] capturedImages] objectAtIndex:0];
        image = [image fixOrientation];
        [[[AppHelper sharedInstance] capturedImages] replaceObjectAtIndex:0 withObject:image];
        [self.bigImage setImage:image];
        
        image = [[[AppHelper sharedInstance] capturedImages] objectAtIndex:1];
        image = [image fixOrientation];
        [[[AppHelper sharedInstance] capturedImages] replaceObjectAtIndex:1 withObject:image];

        [self.smallImage setImage:image];
    }
    
 //   CGSize size = [[UIScreen mainScreen] bounds].size;
 //   [self.retake setFrame:CGRectMake(10, size.height-60, 50, 35)];
 //   [self.btnsave setFrame:CGRectMake(size.width-60, size.height-60, 50, 35)];
}

- (void)viewWillAppear:(BOOL)animated
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    [self.note setFrame:CGRectMake(20, 60, size.width-40, 35)];
    [self.bigImage setFrame:CGRectMake(0, 80, size.width/2, size.width)];
    [self.smallImage setFrame:CGRectMake(size.width/2, 80, size.width/2, size.width)];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void) keyboardWillShown:(NSNotification *)nsNotification {
    NSDictionary *userInfo = [nsNotification userInfo];
    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSLog(@"Height: %f Width: %f", kbSize.height, kbSize.width);
    // Portrait:    Height: 264.000000  Width: 768.000000
    // Landscape:   Height: 1024.000000 Width: 352.000000
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    moveheight = self.note.frame.origin.y-(size.height-kbSize.height-70);
    
    int height = 280;
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        height = 320;
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        CGRect frame = self.note.frame;
        frame.origin.y = size.height-kbSize.height-90;
        self.note.frame = frame;
       // self.note.frame = CGRectOffset(self.note.bounds, 0, -moveheight);
        
    } completion:^(BOOL finished) {
    }];
}
*/
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.note resignFirstResponder];
    
/*    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {
        CGRect frame = self.note.frame;
        frame.origin.y = size.height-120;
        self.note.frame = frame;
 //       self.note.frame = CGRectOffset(self.note.bounds, 0, moveheight);
        
    } completion:^(BOOL finished) {
    }];
    */
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (IBAction)takephoto:(id)sender {
    [self.delegate retake];
}

- (IBAction)save:(id)sender {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.labelText = @"Saving...";
    
    [[AppHelper sharedInstance] saveCaptureImagesbackground:self.note.text];
 
    [self.delegate finish];
}
@end
