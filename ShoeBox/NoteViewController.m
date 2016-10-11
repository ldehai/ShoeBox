//
//  NoteViewController.m
//  myshoe
//
//  Created by andy on 13-4-26.
//  Copyright (c) 2013年 somolo. All rights reserved.
//

#import "NoteViewController.h"
#import "NoteInfo.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AppHelper.h"

@interface NoteViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation NoteViewController
@synthesize delegate,notetext,note;

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
    

    
    if (note) {
        notetext.text = note.content;
    }
    [notetext becomeFirstResponder];
    
    [self setbuttons];
}

- (void)setbuttons
{
    //ios5 不能使用social库
    if ([SLComposeViewController instanceMethodForSelector:@selector(isAvailableForServiceType)] == nil)
    {
        self.btnfacebook.hidden = YES;
        self.btntwitter.hidden = YES;
        self.btnsinaweibo.hidden = YES;
        self.lbshare.hidden = YES;
        return;
    }
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
//        NSLog(@"Facebook service is available");
//        self.btnfacebook.enabled = YES;
//        self.btnfacebook.alpha = 1.0f;
//    } else {
//        NSLog(@"Facebook service is NOT available");
//        self.btnfacebook.enabled = NO;
//        self.btnfacebook.alpha = 0.5f;
//    }
//    
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
//        NSLog(@"Twitter service is available");
//        self.btntwitter.enabled = YES;
//        self.btntwitter.alpha = 1.0f;
//    } else {
//        NSLog(@"Twitter service is NOT available");
//        self.btntwitter.enabled = NO;
//        self.btntwitter.alpha = 0.5f;
//    }
//    
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
//        NSLog(@"Weibo service is available");
//        self.btnsinaweibo.enabled = YES;
//        self.btnsinaweibo.alpha = 1.0f;
//    } else {
//        NSLog(@"Weibo service is NOT available");
//        self.btnsinaweibo.enabled = NO;
//        self.btnsinaweibo.alpha = 0.5f;
//    }
}

- (void)loadView:(BOOL)animated
{
    [notetext becomeFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNotetext:nil];
    [self setBtnfacebook:nil];
    [self setBtntwitter:nil];
    [self setBtntumblr:nil];
    [self setBtngplus:nil];
    [self setBtnsinaweibo:nil];
    [self setLbshare:nil];
    [self setBtnmail:nil];
    [super viewDidUnload];
}
- (IBAction)btncancel:(id)sender {
    [notetext resignFirstResponder];
    [self.delegate cancel];
}

- (IBAction)btnsave:(id)sender {
    [notetext resignFirstResponder];
    if (note)
    {
        note.content = notetext.text;
        [self.delegate updateTimeline:note];
    }
    else
        [self.delegate saveNote:notetext.text];
}

- (IBAction)sharebtnclick:(id)sender
{
    if ([SLComposeViewController instanceMethodForSelector:@selector(isAvailableForServiceType)] == nil)
    {
        return;
    }
    
    UIButton *btn = (UIButton*)sender;
    if (btn == self.btnfacebook) {
        NSLog(@"facebook btn click");
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
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
                [notetext becomeFirstResponder];
            };
            tweetSheet.completionHandler =myBlock;

            [tweetSheet setInitialText:[NSString stringWithFormat:@"%@  Send from ShoeBox:",notetext.text]];
            NSURL *downurl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/shoebox-find-your-shoes-quickly/id640885172?ls=1&mt=8"];
            [tweetSheet addURL:downurl];
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
    else if(btn == self.btntwitter)
    {
        NSLog(@"twitter btn click");
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
                [notetext becomeFirstResponder];
            };
            tweetSheet.completionHandler =myBlock;

            [tweetSheet setInitialText:[NSString stringWithFormat:@"%@   Send from ShoeBox:",notetext.text]];
            NSURL *downurl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/shoebox-find-your-shoes-quickly/id640885172?ls=1&mt=8"];
            [tweetSheet addURL:downurl];
            
            [self presentViewController:tweetSheet animated:YES completion:nil];
            
            [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                [notetext becomeFirstResponder];
                
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
    else if(btn == self.btnsinaweibo)
    {
        NSLog(@"sina weibo btn click");
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
            
            SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
                if (result == SLComposeViewControllerResultCancelled) {
                    
                    NSLog(@"Cancelled");
                    
                } else
                    
                {
                    NSLog(@"Done");
                }
                
                [tweetSheet dismissViewControllerAnimated:YES completion:Nil];
                [notetext becomeFirstResponder];
            };
            tweetSheet.completionHandler =myBlock;
            
            [tweetSheet setInitialText:[NSString stringWithFormat:@"%@   Send from ShoeBox:",notetext.text]];
            
            NSString *imagepath = [AppHelper sharedInstance].sinfo.shoepng;
            [tweetSheet addImage:[UIImage imageWithContentsOfFile:imagepath]];
            NSURL *downurl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/shoebox-find-your-shoes-quickly/id640885172?ls=1&mt=8"];
            [tweetSheet addURL:downurl];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"No Weibo Accounts"
                                      message:@"There are no Weibo accounts configured.You can add or create a Weibo account in Settings."
                                      delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }

    }
    else if(btn == self.btnmail)
    {
        if (![MFMailComposeViewController canSendMail])
            return;
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[NSString stringWithFormat:@"my shoes"]];
        
        NSString *strAttachment = [AppHelper sharedInstance].sinfo.shoepng;
        NSData *myData = [NSData dataWithContentsOfFile:strAttachment];
        NSString *fileName = @"My Shoe";
        [mailViewController addAttachmentData:myData mimeType:@"image/png" fileName:fileName];
        
        NSString *strMessage = [NSString stringWithFormat:@"%@<p>Send From ShoeBox <a href=https://itunes.apple.com/us/app/shoebox-find-your-shoes-quickly/id640885172?ls=1&mt=8>View in App Store</a>",notetext.text];
        
        [mailViewController setMessageBody:strMessage isHTML:YES];

        mailViewController.navigationBar.tintColor = [UIColor colorWithRed:140/255.0 green:192/255.0 blue:160/255.0 alpha:1.0];
        [self presentViewController:mailViewController animated:YES completion:nil];

    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    [controller dismissModalViewControllerAnimated:YES];
}

@end
