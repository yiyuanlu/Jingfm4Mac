//
//  JFTextField.h
//  Jingfm4Mac
//
//  Created by luyiyuan on 12/11/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JFTextField : NSTextField
//about keywords
@property (nonatomic,strong) NSMutableArray *arrayKeyWords;
@property (nonatomic,strong) NSString *curKeyword;
@property (nonatomic,strong) NSString *allKeywords;
-(void)repcurKeyword:(NSString *)key;
@end
