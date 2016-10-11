//
//  ShareViewController.m
//  Baker
//
//  Created by andy on 12/6/13.
//
//

#import "ShareViewController.h"

@interface ShareViewController ()
{
}
@end

@implementation ShareViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnMail:nil];
    [self setBtnTwitter:nil];
    [self setBtnFacebook:nil];
//    [self setBtnTumblr:nil];
//    [self setBtnGooglePlus:nil];
    [self setBtnPinterest:nil];
    [super viewDidUnload];
}

- (IBAction)shareIt:(id)sender
{
    [[self view] endEditing:YES];
    
    UIButton *btn = (UIButton*)sender;
    if (btn == self.btnMail)
    {
        [self.delegate shareIt:1];
    }
    else if (btn == self.btnTwitter)
    {
        [self.delegate shareIt:2];
    }
    else if (btn == self.btnFacebook)
    {
        [self.delegate shareIt:3];
    }
    else if (btn == self.btnPinterest)
    {
        [self.delegate shareIt:4];
    }
}

- (void)fadeOut {
    [UIView beginAnimations:@"fadeOutIndexView" context:nil]; {
        [UIView setAnimationDuration:0.0];
        
        self.view.alpha = 0.0;
    }
    [UIView commitAnimations];
}

- (void)fadeIn {
    [UIView beginAnimations:@"fadeInIndexView" context:nil]; {
        [UIView setAnimationDuration:0.2];
        
        self.view.alpha = 1.0;
    }
    [UIView commitAnimations];
}

- (void)willRotate {
    [self fadeOut];
}

- (void)rotateFromOrientation:(UIInterfaceOrientation)fromInterfaceOrientation toOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    [self fadeIn];
    
}

@end
