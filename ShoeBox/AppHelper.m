//
//  AppHelper.m
//  myshoe
//
//  Created by andy on 13-4-17.
//  Copyright (c) 2013年 somolo. All rights reserved.
//

#import "AppHelper.h"
#import "EGODatabase.h"
#import "ShoeInfo.h"
#import "UIImage+fixOrientation.h"
#import "NoteInfo.h"
#import "Reachability.h"
#import "MBProgressHUD.h"

@implementation AppHelper

static AppHelper *instance = nil;

@synthesize sid,capturedImages,shoes,shoenotes,totalTimeline,sinfo,iap,HUDView;

+ (AppHelper*)sharedInstance
{
    @synchronized(self){
        if (instance == nil) {
            instance = [[AppHelper alloc]init];
            [instance start];
        }
    }
    return instance;
}

- (void)start
{
    if (self.capturedImages == nil) {
        self.capturedImages = [[NSMutableArray alloc]init];
    }
    
    [self initDatabase];

}
- (NSString*)generateSID
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyyMMddhhmmss"];
    self.sid = [dateFormatter stringFromDate:[NSDate date]];
    
    return self.sid;
}

- (void)addCapturedImage:(UIImage*)image
{
    [self.capturedImages addObject:image];
}

- (void)removeAllCapturedImages
{
    [self.capturedImages removeAllObjects];
}

- (void)saveCaptureImagesbackground:(NSString *)comment
{
 //   [self saveCaptureImagesWithComment:comment];
 //   [self performSelector:@selector(saveCaptureImagesWithComment:) withObject:comment];
    [self performSelectorInBackground:@selector(saveCaptureImagesWithComment:) withObject:comment];

}
- (void)saveCaptureImagesWithComment:(NSString*)comment
{
    if (!comment) {
        comment = @"";
    }
    [self generateSID];
    
    if (self.capturedImages.count != 0)
    {
        //盒子照片名
        NSString *imageName  = [NSString stringWithFormat:@"%@-b.png",self.sid];
        NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", imageName]];
        UIImage *image = [self.capturedImages objectAtIndex:1];
        CGSize size = [[UIScreen mainScreen] bounds].size;
        
        CGSize scaledsize = CGSizeMake(size.width,size.height);
        if (image.size.width > image.size.height) {
            scaledsize = CGSizeMake(size.height,size.width);
        }
       // image = [image scaleToSize:scaledsize];

        [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
        
        //鞋子照片名
        imageName = [NSString stringWithFormat:@"%@-s.png",self.sid];
        pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", imageName]];
        image = [self.capturedImages objectAtIndex:0];
 
        //CGSize size = [UIScreen mainScreen].bounds.size;
        
        scaledsize = CGSizeMake(size.width,size.height);
        if (image.size.width > image.size.height) {
            scaledsize = CGSizeMake(size.height,size.width);
        }
        scaledsize = CGSizeMake(size.width,size.height);
        if (image.size.width > image.size.height) {
            scaledsize = CGSizeMake(size.height,size.width);
        }

        image = [image scaleToSize:scaledsize];

        [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
        
        //鞋子缩略图照片名
   /*     imageName = [NSString stringWithFormat:@"%@-sx.png",self.sid];
        pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", imageName]];
        image = [self.capturedImages objectAtIndex:1];
        
//        CGSize size = [[CCDirector sharedDirector] winSize];
        
        scaledsize = CGSizeMake(size.width/4,size.height/4);
        if (image.size.width > image.size.height) {
            scaledsize = CGSizeMake(size.height/4,size.width/4);
        }
        image = [image scaleToSize:scaledsize];
        
        [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];*/
    }
    
    [self add2Database:self.sid withComment:comment];
    
    [self.capturedImages removeAllObjects];
    
    if ([comment isEqualToString:@""]) {
        //comment = @"add this shoe";
    }
    
    NoteInfo *ninfo = [[NoteInfo alloc]init];
    ninfo.sid = self.sid;
    ninfo.signtime = [self currentDateString];
    ninfo.content = comment;
    [self addtimeline:ninfo];
    
    [self.totalTimeline insertObject:ninfo atIndex:0];
    
    ShoeInfo *info = [[ShoeInfo alloc]init];
    info.sid = self.sid;
    info.name = comment;
    info.adddate = ninfo.signtime;
    
    [shoes insertObject:info atIndex:0];
//    [self loadshoes];
    [[NSNotificationCenter defaultCenter] postNotificationName:kSaveImageSucceededNotification object:self userInfo:nil];
    
}


- (void)resizeImages
{    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGSize scaledsize = CGSizeMake(size.width/2,size.height/2);
    for (ShoeInfo* info in self.shoes) {
        //resize box image
        NSString *imageName  = [NSString stringWithFormat:@"%@-b.png",info.sid];
        NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", imageName]];
        
        UIImage *sImage = [UIImage imageWithContentsOfFile:pngPath];
        if (sImage.size.width > sImage.size.height) {
            scaledsize = CGSizeMake(size.height/2,size.width/2);
        }
        sImage = [sImage scaleToSize:scaledsize];
        
        [UIImagePNGRepresentation(sImage) writeToFile:pngPath atomically:YES];
        
        //resize shoe image
        imageName  = [NSString stringWithFormat:@"%@-s.png",info.sid];
        pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", imageName]];
        
        sImage = [UIImage imageWithContentsOfFile:pngPath];
        if (sImage.size.width > sImage.size.height) {
            scaledsize = CGSizeMake(size.height/2,size.width/2);
        }
        sImage = [sImage scaleToSize:scaledsize];
        
        [UIImagePNGRepresentation(sImage) writeToFile:pngPath atomically:YES];
    }
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setInteger:1 forKey:@"resized"];
    
}

- (void)updateTimeline:(NoteInfo*)nInfo
{
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"update timeline set comment = '%@' where shoeid='%@' and signtime = '%@'",nInfo.content, nInfo.sid,nInfo.signtime];
    [database executeQuery:sqlQuery];
    [database close];

}

- (void)addtimelineWithComment:(NSString*)note
{
    NoteInfo *ninfo = [[NoteInfo alloc]init];
    ninfo.sid = self.sinfo.sid;
    ninfo.signtime = [self currentDateString];
    ninfo.content = note;
    [self addtimeline:ninfo];
    
    [self.totalTimeline insertObject:ninfo atIndex:0];
    [self.shoenotes insertObject:ninfo atIndex:0];
    
}

- (void)addtimeline:(NoteInfo*)nInfo
{
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    
    NSString *sqlInsert= [NSString stringWithFormat:@"insert or replace into timeline(shoeid,type,signtime,comment) values ('%@',%d,'%@','%@')",nInfo.sid,nInfo.type,nInfo.signtime,nInfo.content];
    [database executeQuery:sqlInsert];
    [database close];

}

- (NSString*)currentDateString
{    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    return [dateFormatter stringFromDate:[NSDate date]];
}

- (void)initDatabase
{
    //最终数据库路径
    NSString *dbPath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dbPath])
    {
        EGODatabase* database = [EGODatabase databaseWithPath:dbPath];
        
        //create main table
        NSString *strSql = @"create table if not exists main(id integer primary key asc, shoeid text,name text,adddate text,comment text,tag text,archived text default '0',favorite text default '0');";
        [database executeQuery:strSql];
        
        //create timeline table
        strSql = @"create table if not exists timeline(id integer primary key asc, shoeid text,type integer,signtime text,comment text);";
        [database executeQuery:strSql];

        //create tag table
        strSql = @"create table if not exists tag(id integer primary key asc, name text);";
        [database executeQuery:strSql];
        
        [database close];
        
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        [pref setValue:@"1.2.5" forKey:@"dbver"];

    }
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSString* ver = [pref stringForKey:@"dbver"];
    if ( !ver || [ver isEqualToString:@""] || [ver isEqualToString:@"1.2.4"])
    {
        EGODatabase* database = [EGODatabase databaseWithPath:dbPath];
        
        //书签表
        NSString *strSql = @"alter table main add column tag text;";
        EGODatabaseResult* result = [database executeQuery:strSql];
        
        strSql = @"alter table main add column archived text default '0';";
        result = [database executeQuery:strSql];
        
        strSql = @"alter table main add column favorite text default '0';";
        result = [database executeQuery:strSql];
        
        //create tag table
        strSql = @"create table if not exists tag(id integer primary key asc, name text);";
        [database executeQuery:strSql];
        
        [database close];
        
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        [pref setValue:@"1.2.5" forKey:@"dbver"];
        
    }
}

//load all shoes
- (void)loadshoes:(BOOL)bOnlyArchived
{
    @synchronized(self){
    NSLog(@"load shoes");
    
    if (!self.shoes) {
        self.shoes = [[NSMutableArray alloc]init];
    }
    [self.shoes removeAllObjects];
    
    NSString *filter = @"where archived == '0'";
    if (bOnlyArchived) {
            filter = @" where archived == '1'";
    }
    
    NSString *sqlQuery = [[NSString alloc]initWithFormat:@"select * from main %@ order by shoeid desc",filter];
    NSLog(@"%@",sqlQuery);
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    EGODatabaseResult *result = [database executeQuery:sqlQuery];
    for(EGODatabaseRow* row in result) {
        ShoeInfo *info = [[ShoeInfo alloc]init];
        info.sid = [row stringForColumn:@"shoeid"];
        info.name = [row stringForColumn:@"name"];
        info.adddate = [row stringForColumn:@"adddate"];
        info.bFavorite= [[row stringForColumn:@"favorite"] boolValue];
        info.bArchived = [[row stringForColumn:@"archived"] boolValue];
        info.tags = [[NSMutableString alloc]initWithString:[row stringForColumn:@"tag"]];

        NSLog(@"load %@",info.sid);
        
        [shoes addObject:info];
    }
    //[result release];
    [database close];
    }
}

- (void)loadshoeWithFilter:(NSString*)filter
{
    NSLog(@"load shoes");
    
    if (!self.shoes) {
        self.shoes = [[NSMutableArray alloc]init];
    }
    [self.shoes removeAllObjects];
    
    BOOL bFilterbyTag = FALSE;
    NSString *filterSql = @"where archived == '0'";
    if ([filter isEqualToString:@"all"]) {
        filterSql = @" where archived = '0'";
    }
    else if ([filter isEqualToString:@"archived"])
    {
        filterSql = @" where archived = '1'";
    }
    else if ([filter isEqualToString:@"favorite"])
    {
        filterSql = @" where favorite = '1'";
    }
    else if (![filter isEqualToString:@""])
    {
        filterSql = @"";
        bFilterbyTag = TRUE;
    }
    
    NSString *sqlQuery = [[NSString alloc]initWithFormat:@"select * from main %@ order by shoeid desc",filterSql];
    NSLog(@"%@",sqlQuery);
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    EGODatabaseResult *result = [database executeQuery:sqlQuery];
    for(EGODatabaseRow* row in result) {
        ShoeInfo *info = [[ShoeInfo alloc]init];
        info.sid = [row stringForColumn:@"shoeid"];
        info.name = [row stringForColumn:@"name"];
        info.adddate = [row stringForColumn:@"adddate"];
        info.bFavorite= [[row stringForColumn:@"favorite"] boolValue];
        info.bArchived = [[row stringForColumn:@"archived"] boolValue];
        info.tags = [[NSMutableString alloc]initWithString:[row stringForColumn:@"tag"]];
        
        if (bFilterbyTag && [info.tags rangeOfString:filter].length <= 0)
        {
            continue;
        }
        NSLog(@"load %@",info.sid);
        
        [shoes addObject:info];
    }
    //[result release];
    [database close];
}

- (NSMutableArray*)loadTags
{
    if (!self.taglist) {
        self.taglist = [[NSMutableArray alloc]init];
    }
    [self.taglist removeAllObjects];
    
    NSString *sqlQuery = [[NSString alloc]initWithFormat:@"select * from tag"];
    NSLog(@"%@",sqlQuery);
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    EGODatabaseResult *result = [database executeQuery:sqlQuery];
    for(EGODatabaseRow* row in result) {
        NSString *tagname = [row stringForColumn:@"name"];;
        
        [self.taglist addObject:tagname];
    }
    
    [database close];
    
    return self.taglist;
}

- (void)NewTag:(NSString*)tagname
{
    NSString *sqlQuery = [[NSString alloc]initWithFormat:@"insert into tag(name) values('%@')",tagname];
    NSLog(@"%@",sqlQuery);
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    EGODatabaseResult *result =[database executeQuery:sqlQuery];
    [database close];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppAddTagName" object:tagname]; // -> Analytics Event
    
}

- (void)addTag:(NSString*)tags toShoe:(int)number
{
    self.sinfo = (ShoeInfo*)[self.shoes objectAtIndex:number];
    self.sinfo.tags = [[NSMutableString alloc]initWithString:tags];
    
    NSString *sqlQuery = [[NSString alloc]initWithFormat:@"update main set tag='%@' where shoeid = '%@'",self.sinfo.tags, self.sinfo.sid];
    NSLog(@"%@",sqlQuery);
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    [database executeQuery:sqlQuery];
    [database close];

}

- (void)addTag2CurrentShoe:(NSString*)tags
{
    self.sinfo = self.sinfo;
    self.sinfo.tags = [[NSMutableString alloc]initWithString:tags];
    
    NSString *sqlQuery = [[NSString alloc]initWithFormat:@"update main set tag='%@' where shoeid = '%@'",self.sinfo.tags, self.sinfo.sid];
    NSLog(@"%@",sqlQuery);
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    [database executeQuery:sqlQuery];
    [database close];

}

- (void)deleteTag:(NSString*)tagName
{
    NSString *sqlQuery = [[NSString alloc]initWithFormat:@"delete from tag where name = '%@'",tagName];
    NSLog(@"%@",sqlQuery);
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    [database executeQuery:sqlQuery];
    [database close];

}
//load all shoes timeline
- (void)loadtimeline
{
    if (!self.totalTimeline) {
        self.totalTimeline = [[NSMutableArray alloc]init];
    }
    [self.totalTimeline removeAllObjects];
    
    NSString *sqlQuery = [[NSString alloc]initWithFormat:@"select * from timeline order by signtime desc"];
    NSLog(@"%@",sqlQuery);
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    EGODatabaseResult *result = [database executeQuery:sqlQuery];
    for(EGODatabaseRow* row in result) {
        NoteInfo *note = [[NoteInfo alloc]init];
        note.sid = [row stringForColumn:@"shoeid"];
        note.type = [row intForColumn:@"type"];
        note.signtime = [row stringForColumn:@"signtime"];
        note.content = [row stringForColumn:@"comment"];
        [self.totalTimeline addObject:note];
    }
   // [result release];
    [database close];
}

//load shoe note when click on main screen
//- (void)loadshoeNoteWithTag:(int)tag
//{
//    if (!self.shoenotes) {
//        self.shoenotes = [[NSMutableArray alloc]init];
//    }
//    [self.shoenotes removeAllObjects];
//    
//    self.sinfo = (ShoeInfo*)[self.shoes objectAtIndex:tag];
//    
//    NSString *sqlQuery = [[NSString alloc]initWithFormat:@"select * from timeline where shoeid = '%@' order by signtime desc",self.sinfo.sid];
//    NSLog(@"%@",sqlQuery);
//    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
//    EGODatabaseResult *result = [database executeQuery:sqlQuery];
//    for(EGODatabaseRow* row in result) {
//        NoteInfo *note = [[NoteInfo alloc]init];
//        note.sid = [row stringForColumn:@"shoeid"];
//        note.type = [row intForColumn:@"type"];
//        note.signtime = [row stringForColumn:@"signtime"];
//        note.content = [row stringForColumn:@"comment"];
//        [self.shoenotes addObject:note];
//        [note release];
//    }
//    [database close];
//}

//load shoe note special sid
- (void)loadshoeNote
{
    if (!self.shoenotes) {
        self.shoenotes = [[NSMutableArray alloc]init];
    }
    [self.shoenotes removeAllObjects];
    
    NSString *sqlQuery = [[NSString alloc]initWithFormat:@"select * from timeline where shoeid = '%@' order by signtime desc",self.sinfo.sid];
    NSLog(@"%@",sqlQuery);
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    EGODatabaseResult *result = [database executeQuery:sqlQuery];
    for(EGODatabaseRow* row in result) {
        NoteInfo *note = [[NoteInfo alloc]init];
        note.sid = [row stringForColumn:@"shoeid"];
        note.type = [row intForColumn:@"type"];
        note.signtime = [row stringForColumn:@"signtime"];
        note.content = [row stringForColumn:@"comment"];
        [self.shoenotes addObject:note];
    }
  //  [result release];
    [database close];

}

- (BOOL)loadShoe:(ShoeInfo*)shoe
{
    [self.capturedImages removeAllObjects];
    
    self.sinfo = shoe;
    
    //盒子照片名
    NSString *imageName  = [NSString stringWithFormat:@"%@-b.png",self.sinfo.sid];
    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", imageName]];
    self.sinfo.boxpng = pngPath;
    
    //鞋子照片名
    imageName = [NSString stringWithFormat:@"%@-s.png",self.sinfo.sid];
    pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", imageName]];
    self.sinfo.shoepng = pngPath;
    
    [self loadshoeNote];
    
    return YES;
}

//load shoe on main screen
- (BOOL)loadShoeWithTag:(int)tag
{
    [self.capturedImages removeAllObjects];
    
    self.sinfo = (ShoeInfo*)[self.shoes objectAtIndex:tag];
    
    //盒子照片名
    NSString *imageName  = [NSString stringWithFormat:@"%@-b.png",self.sinfo.sid];
    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", imageName]];
    self.sinfo.boxpng = pngPath;
    
    //鞋子照片名
    imageName = [NSString stringWithFormat:@"%@-s.png",self.sinfo.sid];
    pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", imageName]];
    self.sinfo.shoepng = pngPath;
    
    [self loadshoeNote];
    
    return YES;
}

- (BOOL)loadShoeWithNoteTag:(int)tag
{
    NoteInfo *ninfo = (NoteInfo*)[self.totalTimeline objectAtIndex:tag];
    if (!self.sinfo) {
        self.sinfo = [[ShoeInfo alloc]init];
    }
    self.sinfo.sid = ninfo.sid;
    
    //盒子照片名
    NSString *imageName  = [NSString stringWithFormat:@"%@-b.png",ninfo.sid];
    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", imageName]];
    self.sinfo.boxpng = pngPath;
    
    //鞋子照片名
    imageName = [NSString stringWithFormat:@"%@-s.png",ninfo.sid];
    pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", imageName]];
    self.sinfo.shoepng = pngPath;
    
    [self loadshoeNote];
    
    return YES;

}
- (void)loadShoeWithSearch:(NSString*)searchkey
{
    if (!self.shoes) {
        self.shoes = [[NSMutableArray alloc]init];
    }
    [self.shoes removeAllObjects];
    
    NSString *sqlQuery = [[NSString alloc]initWithFormat:@"select * from main where name like '%%%@%%' order by shoeid desc",searchkey];
    NSLog(@"%@",sqlQuery);
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    EGODatabaseResult *result = [database executeQuery:sqlQuery];
    for(EGODatabaseRow* row in result) {
        ShoeInfo *shoeinfo = [[ShoeInfo alloc]init];
        shoeinfo.sid = [row stringForColumn:@"shoeid"];
        [shoes addObject:shoeinfo];
    }
    [database close];

}

- (void)deleteShoeWithTag:(int)tag
{
    ShoeInfo *info = (ShoeInfo*)[self.shoes objectAtIndex:tag];
    [self deleteFromDatabase:info.sid];
    [self deleteShoeImages:info.sid];
    
    [self.shoes removeObject:info];
}

- (void)deleteCurrentShoe
{
    ShoeInfo *info = self.sinfo;
    [self deleteFromDatabase:info.sid];
    [self deleteShoeImages:info.sid];
    
    [self.shoes removeObject:info];
}

- (void)archiveShoeWithTag:(int)tag
{
    ShoeInfo *info = (ShoeInfo*)[self.shoes objectAtIndex:tag];
    
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"update main set archived = '1' where shoeid='%@'",info.sid];
    NSLog(@"archive shoe %@",info.sid);
    
    [database executeQuery:sqlQuery];
    [database close];
    
    [self.shoes removeObject:info];
}

- (void)archiveCurrentShoe
{
    ShoeInfo *info = self.sinfo;
    
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"update main set archived = '1' where shoeid='%@'",info.sid];
    NSLog(@"archive shoe %@",info.sid);
    
    [database executeQuery:sqlQuery];
    [database close];
    
    [self.shoes removeObject:info];
}
- (void)unarchiveShoeWithTag:(int)tag
{
    ShoeInfo *info = (ShoeInfo*)[self.shoes objectAtIndex:tag];
    
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"update main set archived = '0' where shoeid='%@'",info.sid];
    NSLog(@"archive shoe %@",info.sid);
    
    [database executeQuery:sqlQuery];
    [database close];
    
    [self.shoes removeObject:info];
}

- (void)unarchiveCurrentShoe
{
    ShoeInfo *info = self.sinfo;
    
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"update main set archived = '0' where shoeid='%@'",info.sid];
    NSLog(@"archive shoe %@",info.sid);
    
    [database executeQuery:sqlQuery];
    [database close];
    
    [self.shoes removeObject:info];
}

- (void)favoriteShoeWithTag:(int)tag
{
    ShoeInfo *info = (ShoeInfo*)[self.shoes objectAtIndex:tag];
    info.bFavorite = TRUE;
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"update main set favorite = '1' where shoeid='%@'",info.sid];
    NSLog(@"archive shoe %@",info.sid);
    
    [database executeQuery:sqlQuery];
    [database close];
}

- (void)unfavoriteShoeWithTag:(int)tag
{
    ShoeInfo *info = (ShoeInfo*)[self.shoes objectAtIndex:tag];
    info.bFavorite = FALSE;
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"update main set favorite = '0' where shoeid='%@'",info.sid];
    NSLog(@"archive shoe %@",info.sid);
    
    [database executeQuery:sqlQuery];
    [database close];
}


- (void)favoriteCurrentShoe
{
    ShoeInfo *info = self.sinfo;
    info.bFavorite = TRUE;
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"update main set favorite = '1' where shoeid='%@'",info.sid];
    NSLog(@"archive shoe %@",info.sid);
    
    [database executeQuery:sqlQuery];
    [database close];
}

- (void)unfavoriteCurrentShoe
{
    ShoeInfo *info = self.sinfo;
    info.bFavorite = FALSE;
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"update main set favorite = '0' where shoeid='%@'",info.sid];
    NSLog(@"archive shoe %@",info.sid);
    
    [database executeQuery:sqlQuery];
    [database close];
}


- (void)deleteShoeNote:(NSString *)shoeid
{
    
}
- (void)deleteShoeImages:(NSString*)shoeid
{
    //盒子照片名
    NSString *imageName  = [NSString stringWithFormat:@"%@-b.png",shoeid];
    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", imageName]];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    [filemanager removeItemAtPath:pngPath error:nil];
    
    //鞋子照片名
    imageName = [NSString stringWithFormat:@"%@-s.png",shoeid];
    pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", imageName]];
    [filemanager removeItemAtPath:pngPath error:nil];
    
    //鞋子照片名
    imageName = [NSString stringWithFormat:@"%@-sx.png",shoeid];
    pngPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", imageName]];
    [filemanager removeItemAtPath:pngPath error:nil];
    
}

- (void)deleteNote:(NoteInfo*)nInfo
{
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"delete from timeline where shoeid='%@' and signtime = '%@'",nInfo.sid,nInfo.signtime];
    [database executeQuery:sqlQuery];
    [database close];

}

- (void)deleteFromDatabase:(NSString*)shoeid
{
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"delete from main where shoeid='%@'",shoeid];
    NSLog(@"delete shoe %@",shoeid);
    
    [database executeQuery:sqlQuery];
    sqlQuery = [NSString stringWithFormat:@"delete from timeline where shoeid='%@'",shoeid];
    [database executeQuery:sqlQuery];
    [database close];
}

- (void)add2Database:(NSString*)shoeid withComment:(NSString*)comment
{
    EGODatabase* database = [EGODatabase databaseWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"]];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"select * from main where shoeid='%@'",shoeid];
    EGODatabaseResult *result = [database executeQuery:sqlQuery];
    if (result.count != 0) {
        NSString *strDelete = [NSString stringWithFormat:@"delete from main where shoeid='%@'",shoeid];
        [database executeQuery:strDelete];
    }
    
    NSString *sqlInsert= [NSString stringWithFormat:@"insert or replace into main(shoeid,name,adddate,comment) values ('%@','%@','%@','%@')",shoeid,comment,[self currentDateString] ,comment];
    NSLog(@"%@",sqlInsert);
    
    [database executeQuery:sqlInsert];
    [database close];
}

- (void)upgrade
{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if(!r.isReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Can't connect to iTunes, Please check network" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (!self.iap) {
        InAppPurchaseManager *purchase = [[InAppPurchaseManager alloc] init];
        self.iap = purchase;
    }
    
    [self.iap loadStore];
}

- (void)restore
{
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if(!r.isReachable)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Can't connect to iTunes, Please check network" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    if (!self.iap) {
        InAppPurchaseManager *purchase = [[InAppPurchaseManager alloc] init];
        self.iap = purchase;
    }
    
    [self.iap restore];
}

- (BOOL)readPurchaseInfo
{
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    int value = [pref integerForKey:@"purchased"];
    if (value == 1) {
        return TRUE;
    }
    return FALSE;
}

- (BOOL)writePurchaseInfo
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setInteger:1 forKey:@"purchased"];
    
    return TRUE;
}

- (int)getCurrentTheme
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    int value = [pref integerForKey:@"themeid"];
    
    if (value > 100) {
        value = 0;
    }
    
    return value;
}

- (void)setCurrentTheme:(int)themeid
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setInteger:themeid forKey:@"themeid"];
}

//一个月不使用就提醒
- (void)addNotification {
/*    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];

    
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *stryear = [dateFormatter stringFromDate:today];
    [dateFormatter setDateFormat:@"MM"];
    NSString *strmonth = [dateFormatter stringFromDate:today];
    [dateFormatter setDateFormat:@"dd"];
    NSString *strday = [dateFormatter stringFromDate:today];
        
    NSString *strFutureDate = nil;
    
    if ([strmonth intValue] == 12)
    {
        strFutureDate = [NSString stringWithFormat:@"%d-%d-%d",[stryear intValue] + 1, 1,[strday intValue]];
    }
    else
    {
        strFutureDate = [NSString stringWithFormat:@"%d-%d-%d",[stryear intValue], [strmonth intValue] + 1, [strday intValue]];
    }
    
    NSLog(@"%@",strFutureDate);

    [dateFormatter setTimeStyle:kCFDateFormatterMediumStyle];
    [dateFormatter setDateStyle:kCFDateFormatterMediumStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSDate *dd = [dateFormatter dateFromString:strFutureDate];
//    NSString *strToday = [dateFormatter stringFromDate:dd];
    localNotification.fireDate = [dateFormatter dateFromString:strFutureDate];
    localNotification.alertBody = @"Your shoes miss you!";
    localNotification.soundName = UILocalNotificationDefaultSoundName;

    
//    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Object 1", @"Key 1", @"Object 2", @"Key 2", nil];
//    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    localNotification.applicationIconBadgeNumber = 0;
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [localNotification release];*/
}

@end
