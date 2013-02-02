//
//  MVA.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-12.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "MVA.h"
#import "ConstDef.h"
@implementation MVA 
@synthesize periods = _periods;

-(id)initWithPeroid:(int)num{
    self = [super init];
    if (self) {
        _color = CGColorCreateGenericRGB(0, 0, 0, 1);
        _lineWidth = 1;
        _periods = num;
        _data = [[NSMutableArray alloc] init];
        _chartType = CHART_CURVE;
    }
    return self;
}
-(void)calcIndicatorWithNums:(NSMutableArray *)numbers{ 
    [self calcIndicatorWithNums:numbers scale:1];
}

-(void)calcIndicatorWithNums:(NSMutableArray *)numbers scale:(double)scale{
    if (numbers == nil || numbers.count <= 0) {
        NSLog(@"numbers is empty");
        return;
    }
    [_data removeAllObjects];
    double c;
    for (int i = (int)numbers.count - 1; i >= 0; i--) {
        if (i < _periods) {
            [_data insertObject:[NSNumber numberWithInt:-1] atIndex:0];
        }else{
            double avg = 0;
            for (int j = i;j > i - _periods;j--) {
                c = [[numbers objectAtIndex:j] doubleValue];
                avg += (c / _periods);
            }
            avg*=scale;
            [_data insertObject:[NSNumber numberWithDouble:avg] atIndex:0];
        }
    }
}
-(void)dealloc{
    [super dealloc];
}
@end
