//
//  PLSResult.h
//  Jingfm4Mac
//
//  Created by luyiyuan on 12/5/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SongItem;
@interface PLSResult : NSObject
@property (nonatomic,strong) NSValue *total;
@property (nonatomic,strong) NSValue *moods;
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong) NSString *moodids;
@property (nonatomic,strong) NSValue *normalmode;
@property (nonatomic,strong) NSValue *st;
@property (nonatomic,strong) NSValue *ps;
@end
