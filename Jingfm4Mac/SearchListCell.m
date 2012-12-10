//
//  UMAppListCell.m
//  UmengXcodeAssistant
//
//  Created by luyiyuan on 8/20/12.
//  Copyright (c) 2012 Umeng.com. All rights reserved.
//

#import "UMAppListCell.h"

#define BORDER_SIZE  5
#define LEFT_PAD     15
#define IMAGE_HEIGHT 31
#define IMAGE_WIDTH  31
#define TIT_FONT_SIZE    12.0f
#define SUB_FONT_SIZE    10.0f

@implementation UMAppListCell
@synthesize icon = _icon;
@synthesize iconUrl = _iconUrl;
@synthesize appName = _appName;
@synthesize bundleId = _bundleId;
@synthesize iconLink = _iconLink;
@synthesize url = _url;

-(id)init
{
    self = [self init];
    
    if(self)
    {
        _buttonCell = [[NSButtonCell alloc]init];
        self.iconLink = [NSImage imageNamed:@"graphs"];
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    UMAppListCell *cell = [super copyWithZone:zone];
    if (cell == nil) {
        return nil;
    }
    
    // Clear the image and subtitle as they won't be retained
    cell.icon = self.icon;
    cell.appName = self.appName;
    cell.iconLink = self.iconLink;
    cell.url = self.url;
    
    return cell;
}

- (NSRect)imageRectForBounds:(NSRect)bounds
{
    NSRect imageRect = bounds;
    
    imageRect.origin.x += BORDER_SIZE +LEFT_PAD;
    imageRect.origin.y += BORDER_SIZE;
    imageRect.size.width = IMAGE_WIDTH;
    imageRect.size.height = IMAGE_HEIGHT;
    
    return imageRect;
}

- (NSRect)titleRectForBounds:(NSRect)bounds
{
    NSRect titleRect = bounds;
    
    titleRect.origin.x += IMAGE_WIDTH + (BORDER_SIZE *4) + LEFT_PAD;
    titleRect.origin.y += BORDER_SIZE;
    
    NSAttributedString *title = [self attributedStringValue];
    if (title) {
        titleRect.size = [title size];
    } else {
        titleRect.size = NSZeroSize;
    }
    
    CGFloat maxX = NSMaxX(bounds);
    CGFloat maxWidth = maxX - NSMinX(titleRect);
    if (maxWidth < 0) {
        maxWidth = 0;
    }
    
    titleRect.size.width = MIN(NSWidth(titleRect), maxWidth);
    //titleRect.size.height = TIT_FONT_SIZE;
    
    return titleRect;
}

- (NSRect)subtitleRectForBounds:(NSRect)bounds forTitleBounds:(NSRect)titleBounds
{
    NSRect subtitleRect = bounds;
    
    if (!self.bundleId) {
        return NSZeroRect;
    }
    
    subtitleRect.origin.x = NSMinX(titleBounds);
    subtitleRect.origin.y = NSMaxY(titleBounds) + 2;
    
    CGFloat amountPast = NSMaxX(subtitleRect) - NSMaxX(bounds);
    if (amountPast > 0) {
        subtitleRect.size.width -= amountPast + 10;
    }
    
    //subtitleRect.size.height = SUB_FONT_SIZE;
    
    return subtitleRect;
}

- (NSRect)imageLinkRectForBounds:(NSRect)bounds
{
    NSRect imageRect = bounds;
    
    imageRect.origin.x = bounds.size.width - IMAGE_WIDTH - 15;
    imageRect.origin.y += BORDER_SIZE;
    imageRect.size.width = IMAGE_WIDTH;
    imageRect.size.height = IMAGE_HEIGHT;
    
    return imageRect;
}
- (NSAttributedString *)attributedTitleValue
{
    NSAttributedString *astr = nil;
    
    if (self.appName) {
        NSColor *textColour = [self isHighlighted] ? [NSColor whiteColor] : [NSColor whiteColor];
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:textColour,
                               NSForegroundColorAttributeName, nil];
        astr = [[NSAttributedString alloc] initWithString:self.appName attributes:attrs];
    }
    
    return astr;
}

- (NSAttributedString *)attributedSubtitleValue
{
    NSAttributedString *astr = nil;
    
    if (self.bundleId)
        {
        NSColor *textColour = [self isHighlighted] ? [NSColor whiteColor] : [NSColor grayColor];
        NSFont  *textFont = [NSFont systemFontOfSize:SUB_FONT_SIZE];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        //[paraStyle setAlignment:NSRightTextAlignment];
        [paraStyle setLineBreakMode:NSLineBreakByTruncatingHead];
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:textColour,
                               NSForegroundColorAttributeName,textFont,NSFontAttributeName,paraStyle,NSParagraphStyleAttributeName,nil];
        astr = [[NSAttributedString alloc] initWithString:self.bundleId attributes:attrs];
        
        }
    
    return astr;
}

-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:cellFrame];
    [[NSColor blackColor] set];
    [path fill];
    
    
    NSRect imageRect = [self imageRectForBounds:cellFrame];
    
    if (self.icon)
    {
        [self.icon drawInRect:imageRect
                     fromRect:NSZeroRect
                    operation:NSCompositeSourceOver
                     fraction:1.0
               respectFlipped:YES
                        hints:nil];
    }
    else
    {
        
        NSImage *default_icon = [NSImage imageNamed:@"default_icon"];
        [default_icon drawInRect:imageRect
                        fromRect:NSZeroRect
                       operation:NSCompositeSourceOver
                        fraction:1.0
                  respectFlipped:YES
                           hints:nil];
    
//        NSBezierPath *path = [NSBezierPath bezierPathWithRect:imageRect];
//        [[NSColor grayColor] set];
//        [path fill];
    }
    
    NSRect titleRect = [self titleRectForBounds:cellFrame];
    NSAttributedString *aTitle = [self attributedTitleValue];
    
    if ([aTitle length] > 0){
        [aTitle drawInRect:titleRect];
    }
    
    NSRect subtitleRect = [self subtitleRectForBounds:cellFrame forTitleBounds:titleRect];
    NSAttributedString *aSubtitle = [self attributedSubtitleValue];
    
    if ([aSubtitle length] > 0) {
        [aSubtitle drawInRect:subtitleRect];
    }
    
    if(!_buttonCell)
    {
        _buttonCell = [[NSButtonCell alloc]init];        
    }
    
    [_buttonCell setBordered:NO];
    [_buttonCell setImage:[NSImage imageNamed:@"graphs"]];
    [_buttonCell setAlternateImage:[NSImage imageNamed:@"graphs_on"]];
    [_buttonCell setButtonType:NSMomentaryChangeButton];
    [_buttonCell setTarget:self];
    [_buttonCell setAction:@selector(actTest:)];
//    [_buttonCell drawWithFrame:[self imageLinkRectForBounds:cellFrame] inView:controlView];
    [_buttonCell drawWithFrame:[self imageLinkRectForBounds:cellFrame] inView:controlView];

}

-(void)actTest:(id)sender
{
    self.url = @"http://umeng.com";
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:self.url]];
    
}

- (NSUInteger)hitTestForEvent:(NSEvent *)event
                       inRect:(NSRect)cellFrame
                       ofView:(NSView *)controlView {
    NSUInteger hitType = [super hitTestForEvent:event inRect:cellFrame ofView:controlView];
    NSPoint location = [event locationInWindow];
    location = [controlView convertPointFromBase:location];
    // get the button cell's |buttonRect|, then
    if (NSMouseInRect(location, [self imageLinkRectForBounds:cellFrame], [controlView isFlipped])) {
        // We are only sent tracking messages for trackable areas.
        hitType |= NSCellHitTrackableArea;
    }
    return hitType;
}

+ (BOOL)prefersTrackingUntilMouseUp {
    // you want a single, long tracking "session" from mouse down till up
    return YES;
}

- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView {
    // use NSMouseInRect and [controlView isFlipped] to test whether |startPoint| is on the button
    // if so, highlight the button
    [_buttonCell setHighlighted:YES];
    return YES;  // keep tracking
}

- (BOOL)continueTracking:(NSPoint)lastPoint at:(NSPoint)currentPoint inView:(NSView *)controlView {
    // if |currentPoint| is in the button, highlight it
    // otherwise, unhighlight it
    return YES;  // keep on tracking
}

- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag {
    // if |flag| and mouse in button's rect, then
    [[NSApplication sharedApplication] sendAction:_buttonCell.action to:_buttonCell.target from:controlView];
    // and, finally,
    [_buttonCell setHighlighted:NO];
}

@end
