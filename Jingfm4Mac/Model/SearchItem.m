//
//  SearchItem.m
//  Jingfm4Mac
//
//  Created by luyiyuan on 12/10/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import "SearchItem.h"

@implementation SearchItem
- (id)copyWithZone:(NSZone *)zone
{
    SearchItem *item = [[SearchItem alloc] init];
    if (item == nil) {
        return nil;
    }
    
    // Clear the image and subtitle as they won't be retained
    item.fid = self.fid;
    item.nameId = self.nameId;
    item.n = self.n;
    item.t = self.t;

    return item;
}
@end
