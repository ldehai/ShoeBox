//
//  AppHelper.h
//  myshoe
//
//  Created by andy on 13-4-17.
//  Copyright (c) 2013年 somolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoeInfo.h"
#import "InAppPurchaseManager.h"
#import "NoteInfo.h"
#import "SVProgressHUD.h"

// IOS VERSION COMPARISON MACROS
#define SYSTEM_VERSION_EQUAL_TO(version)                  ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(version)              ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version)  ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(version)                 ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version)     ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedDescending)

#define kSaveImageSucceededNotification @"kSaveImageSucceededNotification"
#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"
#define kIAPTransactionFailedNotification @"kIAPTransactionFailedNotification"
#define kIAPTransactionSucceededNotification @"kIAPTransactionSucceededNotification"
#define kOpenShoe @"kOpenShoe"
#define EnterEditModeNotify @"EnterEditModeNotify"
#define ExitEditModeNotify @"ExitEditModeNotify"
#define AddTagSuccessNotify @"AddTagSuccessNotify"
#define UpdateSelectedNotify @"UpdateSelectedNotify"

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface AppHelper : NSObject

@property (nonatomic,strong) NSString *sid;
@property (nonatomic,strong) NSMutableArray *capturedImages;
@property (nonatomic,strong) NSMutableArray *shoes;
@property (nonatomic,strong) NSMutableArray *shoenotes;
@property (nonatomic,strong) NSMutableArray *totalTimeline;
@property (nonatomic,strong) NSMutableArray *taglist;
@property (nonatomic,strong) ShoeInfo *sinfo;
@property (nonatomic,strong) InAppPurchaseManager *iap;
@property (nonatomic,strong) UIView *HUDView;

+ (AppHelper*)sharedInstance;
- (NSString*)generateSID;

- (void)addCapturedImage:(UIImage*)image;
- (void)removeAllCapturedImages;
- (void)saveCaptureImagesWithComment:(NSString*)comment;
- (void)saveCaptureImagesbackground:(NSString *)comment;
- (void)loadshoes:(BOOL)bOnlyArchived;
- (void)loadshoeWithFilter:(NSString*)filter;
- (void)resizeImages;
- (void)loadtimeline;
- (void)loadshoeNote;
- (void)deleteShoeNote:(NSString*)shoeid;
- (void)deleteNote:(NoteInfo*)nInfo;
- (void)updateTimeline:(NoteInfo*)nInfo;
- (BOOL)loadShoe:(ShoeInfo*)shoe;
- (BOOL)loadShoeWithTag:(int)tag;
//- (void)loadshoeNoteWithTag:(int)tag;
- (BOOL)loadShoeWithNoteTag:(int)tag;
- (void)loadShoeWithSearch:(NSString*)searchkey;
- (NSMutableArray*)loadTags;
- (void)NewTag:(NSString*)tagname;
- (void)addTag:(NSString*)tags toShoe:(int)number;
- (void)addTag2CurrentShoe:(NSString*)tags;
- (void)addtimelineWithComment:(NSString*)note;
- (void)deleteShoeWithTag:(int)tag;
- (void)deleteCurrentShoe;
- (void)deleteTag:(NSString*)tagName;
- (void)archiveShoeWithTag:(int)tag;
- (void)archiveCurrentShoe;
- (void)unarchiveShoeWithTag:(int)tag;
- (void)unarchiveCurrentShoe;
- (void)favoriteShoeWithTag:(int)tag;
- (void)favoriteCurrentShoe;
- (void)unfavoriteCurrentShoe;
- (void)add2Database:(NSString*)shoeid withComment:(NSString*)comment;
- (void)upgrade;
- (void)restore;
- (BOOL)readPurchaseInfo;
- (BOOL)writePurchaseInfo;
//- (void)addNotification;
- (int)getCurrentTheme;
- (void)setCurrentTheme:(int)themeid;
@end
