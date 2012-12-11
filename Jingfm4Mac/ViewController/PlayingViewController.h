//
//  PlayingViewController.h
//  Jingfm4Mac
//
//  Created by luyiyuan on 11/27/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AudioStreamer;

@interface PlayingViewController : NSViewController<NSTextFieldDelegate,NSTableViewDataSource,NSTableViewDelegate>

@property (nonatomic,strong) IBOutlet NSTableView *tableView;
@property (nonatomic,strong) IBOutlet NSImageView *diskImage;
@property (nonatomic,strong) IBOutlet NSButton *btnLike;
@property (nonatomic,strong) IBOutlet NSButton *btnHate;
@property (nonatomic,strong) IBOutlet NSButton *btnChange;
@property (nonatomic,strong) IBOutlet NSTextField *txfSearch;
@property (nonatomic,strong) IBOutlet NSButton *btnLogout;
@property (nonatomic,strong) IBOutlet NSTextField *txfName;
@property (nonatomic,strong) AudioStreamer *streamer;
@property (nonatomic,strong) NSTimer *updateTimer;
@property (nonatomic,strong) NSDate *dataForReport;
@property (nonatomic,strong) NSArray *arraySearch;
//about keywords
@property (nonatomic,strong) NSMutableArray *arrayKeyWords;
@property (nonatomic,strong) NSString *curKeyword;
@property (nonatomic,strong) NSString *allKeywords;



-(IBAction)actPlayNext:(id)sender;
-(IBAction)actLove:(id)sender;
-(IBAction)actHate:(id)sender;
@end
