//
//  AddViewController.m
//  ShoeBox
//
//  Created by andy on 13-6-19.
//  Copyright (c) 2013年 AM Studio. All rights reserved.
//

#import "AddViewController.h"
#import "AppHelper.h"
#import "UIImage+fixOrientation.h"
#import "ConfirmViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

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
    
  //  [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // Do any additional setup after loading the view from its nib.
    //[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    int statusbarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagePicker.showsCameraControls = NO;
        imagePicker.toolbarHidden = YES;
        imagePicker.navigationBarHidden = YES;
        imagePicker.wantsFullScreenLayout = NO;
        imagePicker.delegate = self;
        self.uip = imagePicker;
//        [self.view addSubview:imagePicker.view];
    }
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    self.rectimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rect"]];
    [self.rectimage setFrame:CGRectMake(0, (size.height-size.width)/2, size.width, size.width)];
   // self.rectimage.center = self.view.center;
    
    self.bottomimage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottombar"]];
    [self.bottomimage setFrame:CGRectMake(0, size.height-55, size.width, 55)];

    self.boxbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.boxbtn setImage:[UIImage imageNamed:@"boxnormal"] forState:UIControlStateNormal];
    [self.boxbtn setFrame:CGRectMake(size.width/2-50, size.height/2-25, 50, 40)];
    
    self.shoebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shoebtn setImage:[UIImage imageNamed:@"shoenormal.png"] forState:UIControlStateNormal];
    [self.shoebtn setFrame:CGRectMake(size.width/2, size.height/2-25, 50, 40)];
    
    self.capture = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.capture setImage:[UIImage imageNamed:@"camera2.png"] forState:UIControlStateNormal];
    [self.capture.titleLabel setFont:[UIFont fontWithName:@"Vollkorn-Regular" size:14]];
    [self.capture addTarget:self action:@selector(captureButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.capture.frame = CGRectMake(size.width/2-20, size.height - 40.0, 40.0, 30.0);

    
    self.cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelbtn setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [self.cancelbtn.titleLabel setFont:[UIFont fontWithName:@"Vollkorn-Regular" size:14]];
    [self.cancelbtn setBackgroundColor:[UIColor clearColor]];
    [self.cancelbtn addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancelbtn.frame = CGRectMake(size.width - 50, size.height - 40.0, 30.0, 30.0);
    
    //视图整体上移一个状态栏高度
    self.view.frame = CGRectOffset(self.view.bounds, 0, -statusbarHeight);

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[AppHelper sharedInstance] generateSID];
    [[AppHelper sharedInstance] removeAllCapturedImages];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
//    int stutasbarheight = [[UIApplication sharedApplication] statusBarFrame].size.height;

    self.type = 0;
    
    if (self.tickTimer != nil)
        [self.tickTimer invalidate];
    self.tickTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                      target:self
                                                    selector:@selector(flashbox)
                                                    userInfo:nil
                                                     repeats:YES];

    if (![self.uip.view superview])
        [self.view addSubview:self.uip.view];
//    if (![self.rectimage superview]) {
//        [self.view addSubview:self.rectimage];
//    }
    if (![self.boxbtn superview]) {
        [self.view addSubview:self.boxbtn];
    }
    if (![self.shoebtn superview]) {
        [self.view addSubview:self.shoebtn];
    }
    if (![self.bottomimage superview]) {
        [self.view addSubview:self.bottomimage];
    }
    if (![self.capture superview]) {
        [self.view addSubview:self.capture];
    }
    if (![self.cancelbtn superview]) {
        [self.view addSubview:self.cancelbtn];
    }

}
- (void)flashbox
{
    static int stat = 0;
    if (self.type == 0)
    {
        [self.shoebtn setImage:[UIImage imageNamed:@"shoenormal.png"] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {
            if (stat == 1)
                [self.boxbtn setImage:[UIImage imageNamed:@"boxnormal.png"] forState:UIControlStateNormal];
            else
                [self.boxbtn setImage:[UIImage imageNamed:@"boxfocus.png"] forState:UIControlStateNormal];
            stat = !stat;
            
        } completion:^(BOOL finished) {
        }];
    }
    else
    {
        [self.boxbtn setImage:[UIImage imageNamed:@"boxnormal.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^(void) {
            
            if (stat == 1)
                [self.shoebtn setImage:[UIImage imageNamed:@"shoenormal.png"] forState:UIControlStateNormal];
            else
                [self.shoebtn setImage:[UIImage imageNamed:@"shoefocus.png"] forState:UIControlStateNormal];
            stat = !stat;
            
            
        } completion:^(BOOL finished) {
        }];
        
    }
}

- (void)captureButtonClicked:(UIButton*)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [self takephoto];
    }
    else
    {
        [self clear];
        [self.delegate confirm];
    }
}

- (void)cancelButtonClicked:(UIButton*)sender
{
    [self clear];
    [self.delegate finish];    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    CGSize size = [[UIScreen mainScreen] bounds].size;
//    float scale = [[UIScreen mainScreen] scale];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    image = [image fixOrientation];
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    CGSize scaledsize = CGSizeMake(size.width,size.height);
    if (image.size.width > image.size.height) {
        scaledsize = CGSizeMake(size.height,size.width);
    }
    image = [image scaleToSize:scaledsize];

    [[AppHelper sharedInstance] addCapturedImage:image];

    //裁剪
/*    int statusbarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGRect cropRect = CGRectMake(0, ((size.height-size.width)/2+statusbarHeight)*scale, size.width*scale, size.width*scale);

    UIImage *imageCrop = [image crop:cropRect];

    [[AppHelper sharedInstance] addCapturedImage:imageCrop];*/
    
    if (self.type == 0) {
        [self.boxbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.shoebtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    if (self.type == 1) {
        [self clear];
        
        [self.delegate confirm];
    }
    
    self.type = self.type + 1;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.uip.view removeFromSuperview];
    
    [[AppHelper sharedInstance] removeAllCapturedImages];
    
    [self clear];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)clear
{
    [self.tickTimer invalidate];
    [self.uip.view removeFromSuperview];
    [self.bottomimage removeFromSuperview];
    [self.boxbtn removeFromSuperview];
    [self.shoebtn removeFromSuperview];
    [self.capture removeFromSuperview];
    [self.cancelbtn removeFromSuperview];
}

-(void)processImage:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}


- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    NSLog(@"SAVE IMAGE COMPLETE");
    
    if(error != nil) {
        NSLog(@"ERROR SAVING:%@",[error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"test" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"ok", nil];
        [alert show];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"test" message:@"test" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"ok", nil];
        [alert show];
    }
}

- (void) takephoto
{
    [self.uip takePicture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
