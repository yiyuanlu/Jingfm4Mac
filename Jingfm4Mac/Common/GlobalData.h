//
//  GlobalData.h
//  Jingfm4Mac
//
//  Created by luyiyuan on 8/6/12.
//  Copyright 2012 Umeng.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PLSResult;
@class LoginResult;
@interface GlobalData : NSObject
@property (nonatomic,strong) NSString *JingAToken;
@property (nonatomic,strong) NSString *JingRToken;
@property (nonatomic,strong) NSString *curSongUrl;
@property (nonatomic,strong) NSNumber *curTid;
@property (nonatomic,strong) NSString *curCmbt;
@property (nonatomic,strong) NSNumber *uid;
@property (nonatomic,readonly) NSString *amCoverImgUrl;
@property (nonatomic,readonly) NSString *atCoverImgUrl;
@property (nonatomic,strong) PLSResult *plsResult;
@property (nonatomic,strong) LoginResult *loginResult;
@property (nonatomic) BOOL playingCache;
@property (nonatomic) BOOL roleBackCache;
+ (GlobalData*) sharedInstance;
@end
