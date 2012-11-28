//
//  PlayingViewController.m
//  Jingfm4Mac
//
//  Created by luyiyuan on 11/27/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import "PlayingViewController.h"
#import "AudioStreamer.h"
#import "SongItem.h"

@interface PlayingViewController ()

@end

@implementation PlayingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Initialization code here.
    
        //load music data
        [self loadMusicData];
        //set cover image
        [self performSelectorInBackground:@selector(loadImageData) withObject:nil];
        //load other data
        [self loadOtherData];
    
    }
    
    return self;
}

-(void)loadMusicData
{
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

-(void)loadOtherData
{
    //fetch pls
    RKParams *params = [[RKParams alloc] init];
    [params setValue:[GlobalData sharedInstance].Cmbt forParam:@"q"];
    [params setValue:@"5" forParam:@"ps"];
    [params setValue:@"0" forParam:@"st"];
    [params setValue:[GlobalData sharedInstance].Uid forParam:@"u"];
    [params setValue:@"0" forParam:@"u"];
    [params setValue:nil forParam:@"mt"];
    
    
    //setup mapping
    RKObjectMapping* appNodeMapping = [RKObjectMapping mappingForClass:[SongItem class]];

    
    [[RKObjectManager sharedManager].mappingProvider setMapping:appNodeMapping forKeyPath:@"Apps"];
    
    [[RKClient sharedClient] get:FETCH_PLS usingBlock:^(RKRequest *request) {
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
