//
//  NoteInfo.h
//  myshoe
//
//  Created by andy on 13-4-25.
//  Copyright (c) 2013年 somolo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum NoteType{
    NoteTypeAdd = 1,
    NoteTypeModify,
    NoteTypeComment
}NoteType;

@interface NoteInfo : NSObject

@property (nonatomic,strong) NSString* sid;
@property (nonatomic,strong) NSString *signtime;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,assign) NoteType type;
@end
