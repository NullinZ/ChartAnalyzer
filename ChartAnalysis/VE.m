//
//  VE.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-20.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "VE.h"
#import "ConstDef.h"
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
