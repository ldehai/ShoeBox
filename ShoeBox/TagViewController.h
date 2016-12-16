//
//  TagViewController.h
//  ShoeBox
//
//  Created by andy on 13-7-22.
//  Copyright (c) 2013年 AM Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagViewControllerDelegate <NSObject>

-(void)addTag:(NSString*)tags;
-(void)filterByTag:(NSString*)tag;

@end

@interface TagViewController : UIViewController

@property (strong, nonatomic) id <TagViewControllerDelegate> delegate;
//@property (strong, nonatomic) UITableView *tagTable;
@property (weak, nonatomic) IBOutlet UITableView *tagTable;
@property (assign, nonatomic) BOOL bOnlyShow;
@property (assign, nonatomic) BOOL showSelectedTags;
@end
