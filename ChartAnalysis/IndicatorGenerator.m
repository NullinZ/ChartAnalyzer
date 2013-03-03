//
//  IndicatorGenerator.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-15.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "IndicatorGenerator.h"

@implementation IndicatorGenerator
+(IndicatorGenerator *)shareGenerator{
    static IndicatorGenerator *mGenerator;
    @synchronized(self){
        if(!mGenerator){
            mGenerator = [[IndicatorGenerator alloc] init];
        }
    }
    return mGenerator;
}

-(BaseIndicator *)genChartWithData:(NSArray *)data type:(NSString *)type  param:(NSArray *)params{
    if (!data) {
        return nil;
    }
    if ([type isEqualToString:@"LINE"]) {
        int start = [[params objectAtIndex:0] intValue];
        int end = [[params objectAtIndex:1] intValue];
        TrendLine * line = [[TrendLine alloc] initWithStart:start end:end];
        BaseIndicator *chart = [[[BaseIndicator alloc] init] autorelease];
        [line release];
        return chart;
    }else if([type isEqualToString:@"MVA"]){
        int peroid = [[params objectAtIndex:0] intValue];
        MVA *mva = [[MVA alloc] initWithPeroid:peroid];
        [mva calcIndicatorWithNums:data];
        BaseIndicator *chart = [[[BaseIndicator alloc] init] autorelease];
        [mva release];
        return chart;
    }else if([type isEqualToString:@"MAE"]){
        
    }else if([type isEqualToString:@"RSI"]){
        
    }else if([type isEqualToString:@"SSI"]){
        
    }
    return nil;
}

@end
