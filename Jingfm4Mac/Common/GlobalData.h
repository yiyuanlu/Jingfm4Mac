//
//  GlobalData.h
//  Jingfm4Mac
//
//  Created by luyiyuan on 8/6/12.
//  Copyright 2012 Umeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalData : NSObject
@property (nonatomic,strong) NSString *JingAToken;
@property (nonatomic,strong) NSString *JingRToken;
@property (nonatomic,strong) NSString *LastMid;
@property (nonatomic,strong) NSString *Cmbt;
@property (nonatomic,strong) NSString *Uid;
@property (nonatomic,strong) NSString *Fid;
@property (nonatomic,strong) NSString *curSongUrl;
@property (nonatomic,readonly) NSString *amCoverImgUrl;
@property (nonatomic,readonly) NSString *atCoverImgUrl;
+ (GlobalData*) sharedInstance;
@end
