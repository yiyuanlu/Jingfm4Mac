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
#import "PLSResult.h"

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
            NSLog(@"http status code is not 200[%ld] __[%s]__ url [%@]",response.statusCode,__FUNCTION__,request.resourcePath);
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
#ifdef PLAY_SONGS
                [self.streamer start];
                [[NSNotificationCenter defaultCenter]
                 addObserver:self
                 selector:@selector(playbackStateChanged:)
                 name:ASStatusChangedNotification
                 object:self.streamer];
#endif
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
    RKObjectMapping* songItemMapping = [RKObjectMapping mappingForClass:[SongItem class]];
    [songItemMapping mapAttributes:@"abid",@"aid",@"an",@"b",@"d",@"fid",@"mid",@"n",@"tid",nil];
//    [[RKObjectManager sharedManager].mappingProvider setMapping:songItemMapping forKeyPath:@"items"];
    
//    RKObjectMapping* resMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
//    [[RKObjectManager sharedManager].mappingProvider setMapping:resMapping forKeyPath:@"result"];
    
    RKObjectMapping *resultMapping = [RKObjectMapping mappingForClass:[PLSResult class]];
    [resultMapping mapKeyPathsToAttributes:@"total",@"moods", nil];
    [resultMapping mapKeyPath:@"items" toRelationship:@"items" withMapping:songItemMapping];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:resultMapping forKeyPath:@"result"];
    
//    [[RKObjectManager sharedManager].mappingProvider registerMapping:songItemMapping withRootKeyPath:@"result"];
    //post request
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:FETCH_PLS usingBlock:^(RKObjectLoader *loader) {

        //mapping
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[GlobalData sharedInstance].Cmbt, @"q", @"5", @"ps",@"0", @"st",[GlobalData sharedInstance].Uid, @"u", nil, @"mt",nil];
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
        [mapping mapAttributes:@"q",@"ps",@"st",@"u",@"mt", nil];
        RKObjectSerializer *serializer = [RKObjectSerializer serializerWithObject:dic mapping:mapping];
        NSError *error = nil;
        id<RKRequestSerializable> serialization = [serializer serializationForMIMEType:@"application/x-www-form-urlencoded" error:&error];
        loader.params = serialization;
        //other & add Header
        loader.method = RKRequestMethodPOST;
        loader.additionalHTTPHeaders = [NSDictionary dictionaryWithKeysAndObjects:@"Jing-A-Token-Header",[GlobalData sharedInstance].JingAToken,@"Referer",@"http://jing.fm/",nil];

        //NSLog(@"%@",STR_FROM_BOOL([loader prepareURLRequest]));
        //NSLog(@"%@",[loader.URLRequest allHTTPHeaderFields]);
        
        loader.onDidFailLoadWithError = ^(NSError *error)
        {
            NSLog(@"onDidFailLoadWithError error [%@]",error);
            //[DROP_WINDOW showTips:error.localizedDescription];
        };
        
        loader.onDidLoadResponse = ^(RKResponse *response)
        {
            //NSLog(@"%@",response.bodyAsString);
            if (response.statusCode != 200)
            {
                //We got an error!
                NSLog(@"http status code is not 200[%ld] __[%s]__ url [%@]",response.statusCode,__FUNCTION__,loader.resourcePath);
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

                
                }
                else
                {
                    NSLog(@"%@",msg);
                    NSLog(@"200 error [%@]",[error description]);
                    //                [DROP_WINDOW showTips:error.localizedDescription];
                }
            }
        };
        loader.onDidLoadObject = ^(id object){
//            NSLog(@"%@ [%@]",[object class],[(PLSResult *)object valueForKey:@"items"]);
            [GlobalData sharedInstance].songItesms = [(PLSResult *)object valueForKey:@"items"];
            NSLog(@"song items [%ld]",[[GlobalData sharedInstance].songItesms count]);
            
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
