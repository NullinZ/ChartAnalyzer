//
//  VE.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-20.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "VE.h"
#import "ConstDef.h"
#import "Trend.h"
@implementation VE
@synthesize riseColor = _riseColor,fallColor = _fallColor,keepColor = _keepColor,fill = _fill;
-(id)init{
    self = [super init];
    if (self) {
        _color = CGColorCreateGenericRGB(0, 0, 0, 1);
        _riseColor = CGColorCreateGenericRGB(0, 0, 1, 0.1);
        _fallColor = CGColorCreateGenericRGB(1, 0, 0, 0.1);
        _keepColor = CGColorCreateGenericRGB(1, 1, 1, 0.1);
        _fill = YES;
        _chartType = CHART_AREA;
        _data = [[NSMutableArray alloc] init];

    }
    return self;
}
-(void)calcIndicatorWithNums:(NSArray *)numbers{
    [_data removeAllObjects];
    [_data addObjectsFromArray:numbers];
}

-(void)doDraw:(CGContextRef)context withPointWidth:(int)pointWidth rangeStart:(int)rangeStart rangeEnd:(int)rangeEnd rangeStartY:(int)rangeStartY deltaY:(int)deltaY width:(int)width height:(int)height k:(double)k h:(double)h px:(int)px{
    NSArray* indices = self.data;
    if (!indices||indices.count<=0) {
        return;
    }
    Trend *t;
    int cx;
    for (int i = 0;i < indices.count;i++) {
        t = [indices objectAtIndex:i];
        cx = ((self.fill?t.start : t.end) - rangeStart) * pointWidth + (self.fill?0:pointWidth);
        switch (t.type) {
            case RISE:
                CGContextSetFillColorWithColor(context, self.riseColor);
                break;
            case KEEP:
                CGContextSetFillColorWithColor(context, self.keepColor);
                break;
            case FALL:
                CGContextSetFillColorWithColor(context, self.fallColor);
                break;
            default:
                NSLog(@"bad trend type for setColor");
                
        }
        CGContextFillRect(context, CGRectMake(cx, 0, self.fill?(t.span+1) * pointWidth:1, height));
    }
}


-(void)setRiseColor:(CGColorRef)riseColor{
    CGColorRelease(_riseColor);
    _riseColor = riseColor;
}

-(void)setFallColor:(CGColorRef)fallColor{
    CGColorRelease(_fallColor);
    _fallColor = fallColor;
}

-(void)setKeepColor:(CGColorRef)keepColor{
    CGColorRelease(_keepColor);
    _keepColor = keepColor;
}

-(void)dealloc{
    CGColorRelease(_riseColor);
    CGColorRelease(_fallColor);
    CGColorRelease(_keepColor);
    [super dealloc];
}
@end
