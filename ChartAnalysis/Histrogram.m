//
//  Histrogram.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-26.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "Histrogram.h"
@interface Histrogram()
-(void)calcMaxHeight;
@end
@implementation Histrogram
@synthesize heightFactor = _heightFactor,maxHeight = _maxHeight,span;
@synthesize keys;
-(id)initWithHeightFactor:(double)hf{
    self = [super init];
    if (self) {
        _chartType = CHART_HISTOGRAM;
        _data = [[NSMutableArray alloc] init];
        _heightFactor = hf;

    }
    return self;
}

-(id)initWithDic:(NSDictionary *)dic hf:(double)hf{
    self = [self initWithHeightFactor:hf];
    if (self) {
        keys = [[NSMutableArray alloc] init];
        NSSortDescriptor *d = [NSSortDescriptor sortDescriptorWithKey:@"intValue" ascending:YES];
        NSArray *ks = [dic.allKeys sortedArrayUsingDescriptors:[NSArray arrayWithObject:d]];
        for (id key in ks) {
            [keys addObject:key];
            [_data addObject:[dic objectForKey:key]];
            [self calcMaxHeight];
        }
        self.span = (int)keys.count;
    }
    return self;
}

-(void)calcIndicatorWithNums:(NSArray *)numbers{
    [self.data removeAllObjects];
    [self.data addObjectsFromArray: numbers];
    [self calcMaxHeight];
}
-(void)calcMaxHeight{
    double max = 0,min = 100000;
    for (NSNumber * num in self.data){
        if ([num doubleValue] < min) {
            min = [num doubleValue];
        }
        if ([num doubleValue] >max) {
            max = [num doubleValue];
        }
    }
    _maxHeight = max - min;
}
-(void)dealloc{
    [keys release];
    [super dealloc];
}
@end
