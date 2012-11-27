//
//  LoginViewController.m
//  Jingfm4Mac
//
//  Created by luyiyuan on 11/17/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
-(IBAction)actLogin:(id)sender
{
    RKParams *params = [[RKParams alloc] init];
    [params setValue:self.email.stringValue forParam:@"email"];
    [params setValue:self.pass.stringValue forParam:@"pwd"];
    
    [[RKClient sharedClient] get:SESSION_CREATE usingBlock:^(RKRequest *request) {
        request.params = params;
        request.method = RKRequestMethodPOST;
        
        request.onDidFailLoadWithError = ^(NSError *error)
        {
            NSLog(@"onDidFailLoadWithError error [%@]",error);
            //[DROP_WINDOW showTips:error.localizedDescription];
        };
        request.onDidLoadResponse = ^(RKResponse *response)
        {
            [GlobalData sharedInstance].JingAToken = SAFE_STR([response.allHeaderFields objectForKey:JING_HEAD_A_KEY]);
            [GlobalData sharedInstance].JingRToken = SAFE_STR([response.allHeaderFields objectForKey:JING_HEAD_R_KEY]);
        
            if (response.statusCode != 200)
            {
                //We got an error!
                NSLog(@"http status code is not 200[%ld]",response.statusCode);
                //[DROP_WINDOW showTips:@"对不起，服务器出错！"];
            }
            else
            {
                NSError *error = nil;
                NSDictionary *resDic = [response parsedBody:&error];
                BOOL success = [[resDic objectForKey:@"success"] boolValue];
                NSString *msg = SAFE_STR([resDic objectForKey:@"msg"]);
                NSLog(@"%@",msg);
                //Check Response Body to get Data!
                if(!error&&resDic&&success)
                {
                    //NSLog(@"resDic [%@]",resDic);
                    NSDictionary *result = [resDic objectForKey:@"result"];
                    NSDictionary *pld = [result objectForKey:@"pld"];
                    [GlobalData sharedInstance].LastMid = SAFE_STR([pld objectForKey:@"mid"]);
                    [GlobalData sharedInstance].Cmbt = SAFE_STR([pld objectForKey:@"cmbt"]);
                    [GlobalData sharedInstance].Uid = SAFE_STR([pld objectForKey:@"uid"]);
                    [APP_DELEGATE changeViewState:EView_Playing];
                
                    
                }
                else
                {
                    NSLog(@"%@",msg);
                    NSLog(@"200 error [%@]",[error description]);
    //                [DROP_WINDOW showTips:error.localizedDescription];
                }
            }
        };
        
        
    }];

}
@end
