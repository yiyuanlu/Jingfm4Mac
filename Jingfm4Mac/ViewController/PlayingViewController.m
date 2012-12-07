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
        [self loadMusic:[GlobalData sharedInstance].loginResult.pldItem.mid fid:[GlobalData sharedInstance].loginResult.pldItem.fid];
    
        //load pls
        [self loadPls:[GlobalData sharedInstance].loginResult.pldItem.cmbt st:[NSNumber numberWithInt:0]];
    }
    
    return self;
}

- (void)loadMusic:(NSString *)mid fid:(NSString *)fid
{
    [self loadSong:mid];
    [self loadImageCover:fid];
}



-(void)loadSong:(NSString *)mid
{
    //get song url
    RKParams *params = [[RKParams alloc] init];
    [params setValue:mid forParam:@"mid"];
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
                
                [self playSong:[GlobalData sharedInstance].curSongUrl];
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

-(void)loadPls:(NSString *)cmbt st:(NSNumber *)st
{
    NSLog(@"loadPls ====");
    //fetch pls
    RKObjectMapping* songItemMapping = [RKObjectMapping mappingForClass:[SongItem class]];
    [songItemMapping mapAttributes:@"abid",@"aid",@"an",@"b",@"d",@"fid",@"mid",@"n",@"tid",nil];
    
    RKObjectMapping *resultMapping = [RKObjectMapping mappingForClass:[PLSResult class]];
    [resultMapping mapAttributes:@"total",@"moods",@"moodids",@"normalmode",@"st",@"ps",nil];
    [resultMapping mapKeyPath:@"items" toRelationship:@"items" withMapping:songItemMapping];
    
    [[RKObjectManager sharedManager].mappingProvider setMapping:resultMapping forKeyPath:@"result"];
    
    //post request
    [[RKObjectManager sharedManager] loadObjectsAtResourcePath:FETCH_PLS usingBlock:^(RKObjectLoader *loader) {

        //mapping
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:cmbt, @"q", @"5", @"ps",st, @"st",[GlobalData sharedInstance].loginResult.pldItem.uid, @"u", nil, @"mt",nil];
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
        [mapping mapAttributes:@"q",@"ps",@"st",@"u",@"mt", nil];
        RKObjectSerializer *serializer = [RKObjectSerializer serializerWithObject:dic mapping:mapping];
        NSError *error = nil;
        id<RKRequestSerializable> serialization = [serializer serializationForMIMEType:@"application/x-www-form-urlencoded" error:&error];
        loader.params = serialization;
        //other & add Header
        loader.method = RKRequestMethodPOST;
        loader.additionalHTTPHeaders = [NSDictionary dictionaryWithKeysAndObjects:@"Jing-A-Token-Header",[GlobalData sharedInstance].JingAToken,@"Referer",@"http://jing.fm/",nil];
        
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
            [GlobalData sharedInstance].plsResult = (PLSResult *)object;
            NSLog(@"songs[%ld] st[%d] ps[%d] total[%d]",[[GlobalData sharedInstance].plsResult.items count],[[GlobalData sharedInstance].plsResult.st intValue],[[GlobalData sharedInstance].plsResult.ps intValue],[[GlobalData sharedInstance].plsResult.total intValue]);
            
        };
    }];
}

-(void)loadImageCover:(NSString *)fid
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *imageURL = [NSURL URLWithString:AM_COVER_IMGURL(fid)];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:imageURL
                                             options:0
                                               error:&error];
        NSImage *imageFromBundle = [[NSImage alloc] initWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{

            if (imageFromBundle&&data)
                {
                // The image loaded properly, so lets display it.
                self.diskImage.image = imageFromBundle;
                }
            else
                {
                NSLog(@"imageView could not be loaded.");
                }
        });
    });

}

-(void)updateTimer:(NSTimer *)timer
{
    //report playing data
    NSTimeInterval timeSince = -[self.dataForReport timeIntervalSinceNow];
    if(timeSince>=10.0f&&[self.streamer isPlaying])
    {
        self.dataForReport = [NSDate date];
        [self reportPlayingData];
    }
}
-(void)playSong:(NSString *)url
{
    self.streamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:url]];
#ifdef PLAY_SONGS
    [self.streamer start];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChanged:) name:ASStatusChangedNotification object:self.streamer];
#endif
    
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    self.dataForReport = [NSDate date];
}

-(void)stopSong
{
    [self.streamer stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ASStatusChangedNotification
                                                  object:self.streamer];
    if(self.updateTimer)
    {
		[self.updateTimer invalidate];
        self.updateTimer = nil;
    }
    self.streamer = nil;
    
}

-(void)dealloc
{
    [self stopSong];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([self.streamer isWaiting])
    {
        NSLog(@" isWaiting progress [%lf] dur [%lf] bitrate[%d]",self.streamer.progress,self.streamer.duration,self.streamer.bitRate);
    }
	else if ([self.streamer isPlaying])
    {
        if([GlobalData sharedInstance].playingCache&&![GlobalData sharedInstance].roleBackCache)
        {
            [GlobalData sharedInstance].roleBackCache = YES;
            [self.streamer seekToTime:[[GlobalData sharedInstance].loginResult.pldItem.ct doubleValue]];
        }
        NSLog(@"isPlaying progress [%lf] dur [%lf] bitrate[%d]",self.streamer.progress,self.streamer.duration,self.streamer.bitRate);
    }
	else if ([self.streamer isIdle])
    {
        NSLog(@"isIdle progress [%lf] dur [%lf] bitrate[%d]",self.streamer.progress,self.streamer.duration,self.streamer.bitRate);    
        [self playingNext];
    }
}

-(void)playingNext
{
    [self stopSong];
    
    if([GlobalData sharedInstance].playingCache)
    {
        [GlobalData sharedInstance].playingCache = NO;
    }
    
    NSArray *arrItems = [GlobalData sharedInstance].plsResult.items;
    int arrCount = (int)[arrItems count];
    int curIndex = [GlobalData sharedInstance].plsResult.cur;
    
    int total = [[GlobalData sharedInstance].plsResult.total intValue];
    int st = [[GlobalData sharedInstance].plsResult.st intValue];
    
    //play next
    if(arrCount>0&&curIndex<arrCount)
    {
        SongItem *songItem = [arrItems objectAtIndex:curIndex];
        [GlobalData sharedInstance].curTid = songItem.tid;
        [self loadMusic:songItem.mid fid:songItem.fid];
    
        [GlobalData sharedInstance].plsResult.cur++;
    }
    else
    {
        NSLog(@"arrCount[%d] curIndex[%d] total[%d] st[%d]",arrCount,curIndex,total,st);
    }
    
    //playing the eof
    if([GlobalData sharedInstance].plsResult.cur == (arrCount-1))
    {
        if(total>0)
        {
            if((st+arrCount)<total)
            {
                if(st == 0)
                {
                    [self loadPls:[GlobalData sharedInstance].loginResult.pldItem.cmbt st:[NSNumber numberWithInt:arrCount+1]];
                }
                else
                {
                    [self loadPls:[GlobalData sharedInstance].loginResult.pldItem.cmbt st:[NSNumber numberWithInt:st+arrCount]];
                }
            }
            else
            {
                [self loadPls:[GlobalData sharedInstance].loginResult.pldItem.cmbt st:[NSNumber numberWithInt:0]];
            }
            
        }
        else
        {
            //replaying
            //[self.streamer start];
        }

    }
    
}

-(IBAction)actPlayNext:(id)sender
{
    [self playingNext];
}
-(IBAction)actLove:(id)sender
{
    [self reportLove];
}
-(IBAction)actHate:(id)sender
{
    [self reportHate];
}
-(void)reportPlayingData
{    
    [[RKClient sharedClient] get:REPORT_PLAYING usingBlock:^(RKRequest *request) {
        
        //mapping
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[GlobalData sharedInstance].uid, @"uid", [GlobalData sharedInstance].curCmbt, @"cmbt",[GlobalData sharedInstance].curTid, @"tid",[NSString stringWithFormat:@"%d",(int)self.streamer.progress], @"ct", nil];
        
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
        [mapping mapAttributes:@"uid",@"cmbt",@"tid",@"ct",nil];
        RKObjectSerializer *serializer = [RKObjectSerializer serializerWithObject:dic mapping:mapping];
        NSError *error = nil;
        id<RKRequestSerializable> serialization = [serializer serializationForMIMEType:@"application/x-www-form-urlencoded" error:&error];
        request.params = serialization;
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
                NSLog(@"resDic [%@]",resDic);

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

-(void)reportLove
{
    [[RKClient sharedClient] get:LOVE_SONG usingBlock:^(RKRequest *request) {
        
        //mapping
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[GlobalData sharedInstance].uid, @"uid", [GlobalData sharedInstance].curCmbt, @"cmbt",[GlobalData sharedInstance].curTid, @"tid",@"1", @"c",[GlobalData sharedInstance].plsResult.moodids,@"moodTagIds", nil];
        
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
        [mapping mapAttributes:@"uid",@"cmbt",@"tid",@"c",@"moodTagIds",nil];
        RKObjectSerializer *serializer = [RKObjectSerializer serializerWithObject:dic mapping:mapping];
        NSError *error = nil;
        id<RKRequestSerializable> serialization = [serializer serializationForMIMEType:@"application/x-www-form-urlencoded" error:&error];
        request.params = serialization;
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
                NSLog(@"resDic [%@]",resDic);
                
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
-(void)reportHate
{
    [[RKClient sharedClient] get:HATE_SONG usingBlock:^(RKRequest *request) {
        
        //mapping
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[GlobalData sharedInstance].uid, @"uid", [GlobalData sharedInstance].curCmbt, @"cmbt",[GlobalData sharedInstance].curTid, @"tid",@"1", @"c", nil];
        
        RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
        [mapping mapAttributes:@"uid",@"cmbt",@"tid",@"c",nil];
        RKObjectSerializer *serializer = [RKObjectSerializer serializerWithObject:dic mapping:mapping];
        NSError *error = nil;
        id<RKRequestSerializable> serialization = [serializer serializationForMIMEType:@"application/x-www-form-urlencoded" error:&error];
        request.params = serialization;
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
                NSLog(@"resDic [%@]",resDic);
                
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
