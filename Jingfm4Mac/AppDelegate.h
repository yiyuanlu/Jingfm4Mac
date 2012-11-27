//
//  AppDelegate.h
//  Jingfm4Mac
//
//  Created by luyiyuan on 11/17/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LoginViewController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic,strong) LoginViewController *loginVC;

@end
