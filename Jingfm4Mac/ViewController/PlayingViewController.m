//
//  PlayingViewController.m
//  Jingfm4Mac
//
//  Created by luyiyuan on 11/27/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import "PlayingViewController.h"
#import "AudioStreamer.h"

@interface PlayingViewController ()

@end

@implementation PlayingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        {
        //set cover image
        [self performSelectorInBackground:@selector(loadImageData) withObject:nil];
        
        
        //get song url
        RKParams *params = [[RKParams alloc] init];
        [params setValue:[GlobalData sharedInstance].LastMid forParam:@"mid"];
        [params setValue:@"NO" forParam:@"type"];
        
        [[RKClient sharedClient] get:SONG_URL usingBlock:^(RKRequest *request) {
            request.params = params;
            request.method = RKRequestMethodPOST;
            request.additionalHTTPHeaders = [NSDictionary dictionaryWithKeysAndObjects:@"Jing-A-Token-Header",[GlobalData sharedInstance].JingAToken, nil];
            
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
                //Check Response Body to get Data!
                if(!error&&resDic&&success)
                    {
                    //NSLog(@"resDic [%@]",resDic);
                    [GlobalData sharedInstance].curSongUrl = SAFE_STR([resDic objectForKey:@"result"]);
                    NSLog(@"song url [%@]",[GlobalData sharedInstance].curSongUrl);
                    self.streamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:[GlobalData sharedInstance].curSongUrl]];
                    [self.streamer start];
                    [[NSNotificationCenter defaultCenter]
                                            addObserver:self
                                            selector:@selector(playbackStateChanged:)
                                            name:ASStatusChangedNotification
                                            object:self.streamer];
                    
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
    }
    
    return self;
}

-(void)loadImageData
{
    NSURL *imageURL = [NSURL URLWithString:[GlobalData sharedInstance].amCoverImgUrl];
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfURL:imageURL
                                         options:0
                                           error:&error];
    
    NSImage *imageFromBundle = [[NSImage alloc] initWithData:data];
    
    
    if (imageFromBundle&&data)
    {
        // The image loaded properly, so lets display it.
        self.diskImage.image = imageFromBundle;
    }
    else
    {
        NSLog(@"imageView could not be loaded.");
    }
}


- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([self.streamer isWaiting])
        {

        }
	else if ([self.streamer isPlaying])
        {

        }
	else if ([self.streamer isIdle])
        {

        }
}

//-(void)

@end
