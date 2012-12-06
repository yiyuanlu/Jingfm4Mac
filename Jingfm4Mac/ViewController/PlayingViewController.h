//
//  PlayingViewController.h
//  Jingfm4Mac
//
//  Created by luyiyuan on 11/27/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AudioStreamer;

@interface PlayingViewController : NSViewController

@property (nonatomic,strong) IBOutlet NSImageView *diskImage;
@property (nonatomic,strong) IBOutlet NSButton *btnLike;
@property (nonatomic,strong) IBOutlet NSButton *btnHate;
@property (nonatomic,strong) IBOutlet NSButton *btnChange;
@property (nonatomic,strong) IBOutlet NSTextField *txfSearch;
@property (nonatomic,strong) IBOutlet NSButton *btnLogout;
@property (nonatomic,strong) IBOutlet NSTextField *txfName;
@property (nonatomic,strong) AudioStreamer *streamer;

-(IBAction)actPlayNext:(id)sender;
@end
