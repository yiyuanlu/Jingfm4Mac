//
//  AppDelegate.h
//  Jingfm4Mac
//
//  Created by luyiyuan on 11/17/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LoginViewController;
@class PlayingViewController;

typedef enum
{
    EView_Init,
    EView_Login,
    EView_Playing,
}EView_State;


@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property EView_State curViewState;
@property (nonatomic,weak) NSViewController *currentVC;
@property (nonatomic,strong) LoginViewController *loginVC;
@property (nonatomic,strong) PlayingViewController *playingVC;

- (void)changeViewState:(EView_State)state;
@end
