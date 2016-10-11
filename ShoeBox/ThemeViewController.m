//
//  ThemeViewController.m
//  myshoe
//
//  Created by andy on 13-4-27.
//  Copyright (c) 2013年 somolo. All rights reserved.
//

#import "ThemeViewController.h"
#import "AppHelper.h"
#import "UpgradeViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface ThemeViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ThemeViewController
@synthesize delegate;

int NumberOfRow = 3;

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
    self.dataArray = [NSArray arrayWithObjects:@"b1.jpg", @"b2.jpg", @"b3.jpg",@"b4.jpg", nil];
    
    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        NumberOfRow = 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count/2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // CGSize size = [[UIScreen mainScreen] bounds].size;
    CGSize size = self.view.frame.size;
    
    int width = size.width/NumberOfRow-20;
    int height = width*size.height/size.width;
    
    return height + 20;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *shoeCellIdentifier = @"shoeCellIdentifier";
    
    int count = 0;
    int x = 0;
    int y = 15;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        y = 25;
    }
   // CGSize size = [[UIScreen mainScreen] bounds].size;
    CGSize size = self.view.frame.size;
    int middle = 20;
    int width = size.width/NumberOfRow-20;
    int height = width*size.height/size.width;
    int leftedge = 10;

    UITableViewCellStyle style =  UITableViewCellStyleDefault;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shoeCellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:style reuseIdentifier:shoeCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
        
    for (int i=0; i< NumberOfRow; i++)
    {
        x = leftedge + count * width + count *middle;
        UIButton *btnBook = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        btnBook.tag = 10 +i;
   //     btnBook setBackgroundImage:UIImage imageNamed:self.dataArray objectAtIndex: forState:<#(UIControlState)#>
        [btnBook addTarget:self action:@selector(buttonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnBook];
        
        int pos = 10;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            pos = 30;
        }
        UIButton *btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(x+ width-50, y+ height- 50, 40, 40)];
        btnDelete.tag = 10000 + i;
        
        //设置图片
//        [btnDelete setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
//        [btnDelete addTarget:self action:@selector(removeButtonTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:btnDelete];
        
        count++;
    }
    
    int sindex = (indexPath.row)*NumberOfRow;
   
    int themeid = [[AppHelper sharedInstance] getCurrentTheme];
    BOOL bPurchased =  [[AppHelper sharedInstance] readPurchaseInfo];
    count = 0;
    for (int j=0; j< NumberOfRow; j++)
    {
        UIButton *btn = (UIButton*)[cell.contentView viewWithTag:j+10];
      //  [btn setHidden:YES];
     //   [btn setUserInteractionEnabled:NO];
        
        UIButton *btnIndicator = (UIButton*)[cell.contentView viewWithTag:j+10000];
    //    [btnIndicator setHidden:YES];
        
        if (sindex < self.dataArray.count )
        {
            x = leftedge + count * width + count *middle;
            [btn setFrame:CGRectMake(x, y, width, height)];
            
            [btn setBackgroundImage:[UIImage imageNamed:[self.dataArray objectAtIndex:sindex]] forState:UIControlStateNormal];
            
            if (sindex == themeid)
                [btnIndicator setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
            else if(!bPurchased)
                [btnIndicator setBackgroundImage:[UIImage imageNamed:@"lock.png"] forState:UIControlStateNormal];
        }
        
        count = count + 1;
        sindex = sindex + 1;
    }
    //设置字体
    

    
    return cell;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    switch (indexPath.row) {
//        case 0:
//            [self sendmail:nil];
//            break;
//
//        case 1:
//            [self sendmail:@"ldehai@gmail.com"];
//            break;
//        case 2:
//            //            ThemeViewController *theme = [[ThemeViewController alloc]initWithNibName:nil bundle:nil];
//            //            [[AppController sharedDelegate].navController pushViewController:theme animated:YES];
//            break;
//        case 3:
//            
//            if ([[AppHelper sharedInstance] readPurchaseInfo]) {
//                return;
//            }
//            UpgradeViewController *upgrade = [[UpgradeViewController alloc]initWithNibName:nil bundle:nil];
//            [[AppController sharedDelegate].navController pushViewController:upgrade animated:YES];
//            
//            break;
//            
//        default:
//            break;
//    }
}

- (void) buttonTapped: (UIControl *) button withEvent: (UIEvent *) event
{
    int themeid = [[AppHelper sharedInstance] getCurrentTheme];
    BOOL bPurchased =  [[AppHelper sharedInstance] readPurchaseInfo];

    NSIndexPath * indexPath = [self.table indexPathForRowAtPoint: [[[event touchesForView: button] anyObject] locationInView: self.table]];
    if ( indexPath == nil )
        return;
    
    int sindex = (indexPath.row)*NumberOfRow + button.tag-10;
    if (sindex == themeid) {
        return;
    }
    
    if (!bPurchased) {
//        UpgradeViewController *upgrade = [[UpgradeViewController alloc]initWithNibName:nil bundle:nil];
//        [[AppController sharedDelegate].navController pushViewController:upgrade animated:YES];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Upgrade to full version" message:@"Unlock new themes and manage more shoes" delegate:self cancelButtonTitle:@"Upgrade" otherButtonTitles:@"Cancel", nil];
        [alert show];
        return;
    }

    [[AppHelper sharedInstance] setCurrentTheme:sindex];
    
    [self.table reloadData];
    
 //   [[AppController sharedDelegate].navController popViewControllerAnimated:YES];
 //   [[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInR transitionWithDuration:0.1 scene:[HelloWorldLayer scene]]];

    [self.delegate setCurrentTheme];
 //   [[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInR transitionWithDuration:0.25 scene:[HelloWorldLayer scene] ]];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [AppHelper sharedInstance].HUDView = self.view;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Connect to iTunes ...";
        
        [[AppHelper sharedInstance] upgrade];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTable:nil];
    [super viewDidUnload];
}
- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
