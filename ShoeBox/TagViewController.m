//
//  TagViewController.m
//  ShoeBox
//
//  Created by andy on 13-7-22.
//  Copyright (c) 2013年 AM Studio. All rights reserved.
//

#import "TagViewController.h"
#import "AppHelper.h"
#import "UIButton+Custom.h"
#import "UpgradeViewController.h"

@interface TagViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *tagList;
}
@end

@implementation TagViewController

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
    tagList = [[AppHelper sharedInstance] loadTags];
    self.title = @"Add Tag";

    if (self.bOnlyShow) {
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
        
        [closeButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.leftBarButtonItem = closeButton;
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTags)];
        
        [editButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.rightBarButtonItem = editButton;

    }
    else
    {
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
        
        [closeButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.leftBarButtonItem = closeButton;
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(newtag)];
        
        [addButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        self.navigationItem.rightBarButtonItem = addButton;

    }

    self.tagTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-100) style:UITableViewStylePlain];
    self.tagTable.delegate = self;
    self.tagTable.dataSource = self;
    self.tagTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!self.bOnlyShow)
    {
        [self.tagTable setEditing:YES animated:NO];
        self.tagTable.allowsMultipleSelectionDuringEditing = YES;
    }
    
    [self.view addSubview:self.tagTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(AddTagSuccess:)
												 name:AddTagSuccessNotify
											   object:nil];
    
    //select current tag
    if (self.showSelectedTags) {
        NSString *tags = [AppHelper sharedInstance].sinfo.tags;
        NSArray *tagArray = [tags componentsSeparatedByString:@"|"];
        [tagList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *tag = (NSString*)obj;
            BOOL bFind = FALSE;
            for (NSString *t in tagArray) {
                if ([t isEqualToString:tag]) {
                    bFind = TRUE;
                    break;
                }
            }
            
            if (bFind) {
                NSIndexPath *index = [NSIndexPath indexPathForRow:idx inSection:0];
                [self.tagTable selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            
        }];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    CGRect rect = self.view.frame;
    [self.tagTable setFrame:rect];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)editTags
{
    [self.tagTable setEditing:YES animated:YES];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(finishEdit)];
    
    [editButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = editButton;

}

- (void)finishEdit
{
    [self.tagTable setEditing:NO animated:YES];
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTags)];
    
    [editButton setBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = editButton;

}

- (void)save
{
    NSMutableString *tags = [[NSMutableString alloc]init];
    
    NSArray *selItems = [self.tagTable indexPathsForSelectedRows];
    for (NSIndexPath *index in selItems) {
        [tags appendString:[tagList objectAtIndex:index.row]];
        [tags appendString:@"|"];
    }
    
    [self.delegate addTag:tags];
    
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)newtag
{
    if(tagList.count < 3 || [[AppHelper sharedInstance] readPurchaseInfo])
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Add Tag"
                                                       message:@"Type the name of new tag"
                                                      delegate:self
                                             cancelButtonTitle:@"Cancel"
                                             otherButtonTitles:@"Add", nil];
        
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.delegate = self;
        [alert show];
        
    }
    else
    {

        UpgradeViewController *upgrade = [[UpgradeViewController alloc]initWithNibName:nil bundle:nil];
  /*      UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:upgrade];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            navController.modalPresentationStyle = UIModalPresentationFormSheet;
        }
        */
        [self.navigationController pushViewController:upgrade animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AppReachPurchaseLimit" object:self]; // -> Analytics Event
    }

}

- (void)AddTagSuccess:(NSNotification *)notification
{
    NSString *newtag = (NSString*)[notification object];
    
    [tagList insertObject:newtag atIndex:0];
    
    [self.tagTable reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (![[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
            [[AppHelper sharedInstance] NewTag:[alertView textFieldAtIndex:0].text];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:AddTagSuccessNotify object:[alertView textFieldAtIndex:0].text];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tagList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"CellIdentifier";
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    cell.textLabel.text = [tagList objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0,44, self.tagTable.frame.size.width, 1)];
    line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3];
    [cell.contentView addSubview:line];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bOnlyShow)
    {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bOnlyShow) {
        [self.delegate filterByTag:[tagList objectAtIndex:indexPath.row]];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[AppHelper sharedInstance] deleteTag:[tagList objectAtIndex:indexPath.row]];
        [tagList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end