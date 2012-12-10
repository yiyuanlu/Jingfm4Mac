//
//  SearchListCell.m
//  Jingfm4Mac
//
//  Created by luyiyuan on 8/20/12.
//  Copyright (c) 2012 tapray.com. All rights reserved.
//

#import "SearchListCell.h"

#define BORDER_SIZE  5
#define LEFT_PAD     15
#define IMAGE_HEIGHT 31
#define IMAGE_WIDTH  31
#define TIT_FONT_SIZE    12.0f
#define SUB_FONT_SIZE    10.0f

@implementation SearchListCell

-(id)init
{
    self = [self init];
    
    if(self)
    {
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    SearchListCell *cell = [super copyWithZone:zone];
    if (cell == nil) {
        return nil;
    }
    
    // Clear the image and subtitle as they won't be retained
    cell.icon = self.icon;
    cell.name = self.name;
    
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

- (NSAttributedString *)attributedTitleValue
{
    NSAttributedString *astr = nil;
    
    if (self.name) {
        NSColor *textColour = [self isHighlighted] ? [NSColor whiteColor] : [NSColor whiteColor];
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:textColour,
                               NSForegroundColorAttributeName, nil];
        astr = [[NSAttributedString alloc] initWithString:self.name attributes:attrs];
    }
    
    return astr;
}

-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:cellFrame];
    [[NSColor blackColor] set];
    [path fill];
    
    
//    NSRect imageRect = [self imageRectForBounds:cellFrame];
//    
//    if (self.icon)
//    {
//        [self.icon drawInRect:imageRect
//                     fromRect:NSZeroRect
//                    operation:NSCompositeSourceOver
//                     fraction:1.0
//               respectFlipped:YES
//                        hints:nil];
//    }
//    else
//    {
//        
//        NSImage *default_icon = [NSImage imageNamed:@"default_icon"];
//        [default_icon drawInRect:imageRect
//                        fromRect:NSZeroRect
//                       operation:NSCompositeSourceOver
//                        fraction:1.0
//                  respectFlipped:YES
//                           hints:nil];
//    
////        NSBezierPath *path = [NSBezierPath bezierPathWithRect:imageRect];
////        [[NSColor grayColor] set];
////        [path fill];
//    }
    
    NSRect titleRect = [self titleRectForBounds:cellFrame];
    NSAttributedString *aTitle = [self attributedTitleValue];
    
    if ([aTitle length] > 0){
        [aTitle drawInRect:titleRect];
    }
}



@end
