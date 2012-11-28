//
//  GlobalData.m
//  Jingfm4Mac
//
//  Created by luyiyuan on 8/6/12.
//  Copyright 2012 Umeng.com. All rights reserved.
//

#import "GlobalData.h"

@implementation GlobalData
#pragma mark -
#pragma mark Singleton Methods

+ (GlobalData*)sharedInstance {

	static GlobalData *_sharedInstance;
	if(!_sharedInstance) {
		static dispatch_once_t oncePredicate;
		dispatch_once(&oncePredicate, ^{
			_sharedInstance = [[super allocWithZone:nil] init];
            
            [RKClient setSharedClient:[[RKClient alloc] initWithBaseURLString:API1_URL]];
            [RKObjectManager setSharedManager:[RKObjectManager objectManagerWithBaseURLString:API1_URL]];
            
            
			});
        
		}

		return _sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone {	

	return [self sharedInstance];
}


- (id)copyWithZone:(NSZone *)zone {
	return self;	
}

#if (!__has_feature(objc_arc))

- (id)retain {	

	return self;	
}

- (NSUInteger)retainCount {
	return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release {
	//do nothing
}

- (id)autorelease {

	return self;	
}
#endif

#pragma mark -
#pragma mark Custom Methods

-(void)setFid:(NSString *)Fid
{
    
    _Fid = Fid;
    _amCoverImgUrl = [NSString stringWithFormat:@"%@/album/AM/%@/%@/%@/%@/AM%@",IMAGE_DOMAIN,[self.Fid substringToIndex:4],[self.Fid substringWithRange:NSMakeRange(4,4)],[self.Fid substringWithRange:NSMakeRange(8,2)],[self.Fid substringWithRange:NSMakeRange(10,2)],self.Fid];
    
    _atCoverImgUrl = [NSString stringWithFormat:@"%@/album/AT/%@/%@/%@/%@/AT%@",IMAGE_DOMAIN,[self.Fid substringToIndex:4],[self.Fid substringWithRange:NSMakeRange(4,4)],[self.Fid substringWithRange:NSMakeRange(8,2)],[self.Fid substringWithRange:NSMakeRange(10,2)],self.Fid];
    
}

// Add your custom methods here


@end
