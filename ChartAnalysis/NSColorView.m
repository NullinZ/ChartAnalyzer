//
//  NSColorView.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-22.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "NSColorView.h"

@implementation NSColorView
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _background = CGColorCreateGenericRGB(1, 1, 1, 1);
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _background = CGColorCreateGenericRGB(1, 1, 1, 1);
    }
    return self;
}
- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef c = [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetFillColorWithColor(c, _background);
    CGContextFillRect(c, dirtyRect);

}

-(void)setBackgroundColor:(NSColor *)color{
    CGFloat r,g,b,a;
    [color getRed:&r green:&g blue:&b alpha:&a];
    CGColorRelease(_background);
    _background = CGColorCreateGenericRGB(r, g, b, a);
}

-(void)dealloc{
    CGColorRelease(_background);
    [super dealloc];
}
    

@end
