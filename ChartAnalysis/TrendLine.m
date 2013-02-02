//
//  TrendLine.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-14.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "TrendLine.h"
#import "ConstDef.h"
@implementation TrendLine
-(id)initWithStart:(int)start end:(int)end{
    self = [super init];
    if (self) {
        _start = start;
        _end = end;
        _chartType = CHART_LINE; 
    }
    return self;
}

-(void)calcIndicatorWithNums:(NSArray *)numbers{
    _ye = [[numbers objectAtIndex:_end] doubleValue];
    _ys = [[numbers objectAtIndex:_start] doubleValue];
    _data = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:_start] ,[NSNumber numberWithDouble:_ys] ,[NSNumber numberWithInt:_end],[NSNumber numberWithDouble:_ye], nil];
}
@end
