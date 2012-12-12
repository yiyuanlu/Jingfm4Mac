//
//  AppDelegate.m
//  Jingfm4Mac
//
//  Created by luyiyuan on 11/17/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "PlayingViewController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    //
    self.curViewState = EView_Init;
    [GlobalData sharedInstance];
}

- (void)awakeFromNib
{
    [self changeViewState:EView_Login];
}

- (void)changeViewState:(EView_State)state
{
    self.curViewState = state;
    
    if(self.currentVC!=nil&&self.currentVC.view!=nil)
    {
        [self.currentVC.view removeFromSuperview];
    }
    
    switch (state) {
        case EView_Login:
            self.loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            self.currentVC = self.loginVC;
            [self.window setContentView:self.loginVC.view];
            break;
        case EView_Playing:
            self.playingVC = [[PlayingViewController alloc] initWithNibName:@"PlayingViewController" bundle:nil];
            self.currentVC = self.playingVC;
            [self.window setContentView:self.playingVC.view];
            break;
        default:
            break;
    }
}
@end
