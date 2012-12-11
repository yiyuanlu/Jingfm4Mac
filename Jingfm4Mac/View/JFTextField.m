//
//  JFTextField.m
//  Jingfm4Mac
//
//  Created by luyiyuan on 12/11/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import "JFTextField.h"

@implementation JFTextField

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.arrayKeyWords = [[NSMutableArray alloc] init];
        self.curKeyword = @"";
        self.allKeywords = @"";
    }
    
    return self;
}
//
//- (void)drawRect:(NSRect)dirtyRect
//{
//    // Drawing code here.
//}

-(void)setStringValue:(NSString *)aString;
{
    if(self.stringValue==nil||[self.stringValue length]==0)
    {
        NSArray *arr = [aString componentsSeparatedByString:@" + "];
        [self.arrayKeyWords addObjectsFromArray:arr];
        self.allKeywords = aString;
        NSLog(@"%@",aString);
    }

    [super setStringValue:aString];
}

-(BOOL)becomeFirstResponder
{   
    if([self.stringValue length]>0&&![self.stringValue hasSuffix:@" + "])
    {
        self.stringValue = [NSString stringWithFormat:@"%@ + ",self.stringValue];
    }

    return [super becomeFirstResponder];
}

-(BOOL)resignFirstResponder
{
    NSLog(@"%s",__FUNCTION__);
    
    return [super resignFirstResponder];
}

-(void)textDidChange:(NSNotification *)notification
{
    self.curKeyword = [self.stringValue substringFromIndex:[self.allKeywords length]+[@" + " length]];
    NSLog(@"%s [%@] curKeyword [%@]",__FUNCTION__,self.stringValue,self.curKeyword);
    [super textDidChange:notification];
}

-(void)repcurKeyword:(NSString *)key
{
    self.curKeyword = @"";
    [self.arrayKeyWords addObject:key];
    self.allKeywords = [NSString stringWithFormat:@"%@ + %@",self.allKeywords,key];
    self.stringValue = self.allKeywords;
}
@end
