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

-(void)doDraw:(CGContextRef)context withPointWidth:(int)pointWidth rangeStart:(int)rangeStart rangeEnd:(int)rangeEnd rangeStartY:(int)rangeStartY deltaY:(int)deltaY width:(int)width height:(int)height k:(double)k h:(double)h px:(int)px{
    NSArray * indices = self.data;
    if (!indices||indices.count<=0) {
        return;
    }
    CGContextSetFillColorWithColor(context, self.color);
    double volume;
    int start = self.span?0:rangeStart;
    int end = self.span?self.span:rangeEnd;
    for (int i = start; i < end && i < indices.count; i++) {
        volume = [[indices objectAtIndex:i] doubleValue];
        int cx = (i - start) * pointWidth;
        double cy = self.heightFactor * height * volume / self.maxHeight;
        CGContextFillRect(context, CGRectMake(cx, 0, pointWidth - 1, cy));
    }
    int index = px * self.span/ width;
    int key = self.keys&&self.keys.count?[[self.keys objectAtIndex:index] intValue]:index+1;
    const char * tip = [[NSString stringWithFormat:@"i:%d v:%f", key, [[indices objectAtIndex:MIN(index ,indices.count-1)] doubleValue]] UTF8String];
    CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, -1.0, 0.0);
    CGContextSetTextMatrix(context, xform);
    CGContextSelectFont(context, "Arial", 10, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetTextPosition(context, width-80, height-10);
    CGContextShowText(context, tip, strlen(tip));
    

}

-(void)dealloc{
    [keys release];
    [super dealloc];
}
@end
