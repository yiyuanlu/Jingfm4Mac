//
//  UMAppListCell.h
//  UmengXcodeAssistant
//
//  Created by luyiyuan on 8/20/12.
//  Copyright (c) 2012 Umeng.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UMAppListCell : NSCell
{
@private
    NSImage     *_icon;
    NSString    *_iconUrl;
    NSString    *_appName;
    NSString    *_bundleId;
    NSImage     *_iconLink;
    NSString    *_url;
    NSButtonCell *_buttonCell;
}
@property (strong) NSImage    *icon;
@property (strong) NSString   *iconUrl;
@property (strong) NSString   *appName;
@property (strong) NSString   *bundleId;
@property (strong) NSImage    *iconLink;
@property (strong) NSString   *url;
@end
