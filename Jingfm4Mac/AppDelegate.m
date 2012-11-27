//
//  AppDelegate.m
//  Jingfm4Mac
//
//  Created by luyiyuan on 11/17/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    //
    [GlobalData sharedInstance];
    
}

- (void)awakeFromNib
{
    self.loginVC = [[LoginViewController alloc] init];
    [self.window setContentView:self.loginVC.view];
    
    
}
@end
