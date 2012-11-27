//
//  LoginViewController.h
//  Jingfm4Mac
//
//  Created by luyiyuan on 11/17/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LoginViewController : NSViewController
@property (nonatomic,strong) IBOutlet NSTextField *email;
@property (nonatomic,strong) IBOutlet NSTextField *pass;
@property (nonatomic,strong) IBOutlet NSButton *btnLogin;
-(IBAction)actLogin:(id)sender;
@end
