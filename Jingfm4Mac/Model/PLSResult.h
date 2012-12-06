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
@property (nonatomic,strong) NSNumber *total;
@property (nonatomic,strong) NSNumber *moods;
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong) NSString *moodids;
@property (nonatomic,strong) NSNumber *normalmode;
@property (nonatomic,strong) NSNumber *st;
@property (nonatomic,strong) NSNumber *ps;
@property (nonatomic) int             cur;
@end
