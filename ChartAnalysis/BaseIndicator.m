//
//  BaseIndicator.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-12.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "BaseIndicator.h"

@implementation BaseIndicator
@synthesize color = _color;
@synthesize lineWidth = _lineWidth;
@synthesize data = _data;
@synthesize chartType = _chartType;
@synthesize needDraw = _needDraw;
@synthesize identity = _identity;
-(void)dealloc{
    CGColorRelease(_color);
    [_data release];
    [super dealloc];
}
-(NSString *)description{

    return [NSString stringWithFormat:@"color:%@ lw:%d ct:%d",_color,_lineWidth,_chartType];
}
-(void)setColor:(CGColorRef)color{
    CGColorRelease(_color);
    _color = color;
}
@end
