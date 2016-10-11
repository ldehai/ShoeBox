//
//  ShareViewController.h
//  Baker
//
//  Created by andy on 12/6/13.
//
//

#import <UIKit/UIKit.h>

@protocol ShareViewControllerDelegate <NSObject>

- (void)shareIt:(int)index;

@end

@interface ShareViewController : UIViewController

@property (retain, nonatomic) id<ShareViewControllerDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *btnMail;
@property (retain, nonatomic) IBOutlet UIButton *btnTwitter;
@property (retain, nonatomic) IBOutlet UIButton *btnFacebook;
//@property (retain, nonatomic) IBOutlet UIButton *btnTumblr;
//@property (retain, nonatomic) IBOutlet UIButton *btnGooglePlus;
@property (retain, nonatomic) IBOutlet UIButton *btnPinterest;
- (IBAction)shareIt:(id)sender;
- (void)willRotate;
- (void)rotateFromOrientation:(UIInterfaceOrientation)fromInterfaceOrientation toOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (void)fadeOut;
- (void)fadeIn;
@end
