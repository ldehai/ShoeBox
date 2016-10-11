//
//  ShoeInfo.h
//  myshoe
//
//  Created by andy on 13-4-18.
//  Copyright (c) 2013年 somolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoeInfo : NSObject

@property (nonatomic,strong) NSString* sid;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* adddate;
@property (nonatomic,strong) NSString *boxpng;
@property (nonatomic,strong) NSString *shoepng;
@property (nonatomic,assign) BOOL bArchived;
@property (nonatomic,assign) BOOL bFavorite;
@property (nonatomic,strong) NSMutableString *tags;
@end
