//
//  Analysiser.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-11.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "Analyzer.h"
#import "AnalysisEngine.h"
#import "BaseIndicator.h"
#import "Log.h"
#import "VE.h"
#import "MVA.h"
#import "TrendLine.h"
#import "NSMutableArray+Property.h"
#import "Utilities.h"
@interface Analyzer(){
}

-(void)printReportHeader;
-(void)analysisCandleInfo:(NSArray*)candles;

-(void)distributed;
@end
@implementation Analyzer
@synthesize histrogram,ppn,spe;

-(id)init{
    self = [super init];
    if (self) {
        ppn = 1;
        spe =0.95;
    }
    return self;
}

/**
 *分布
 */
-(void)prepareAnalysis{
    NSAutoreleasePool *autoPool = [[NSAutoreleasePool alloc] init];
    [self printReportHeader];
    [self analysisCandleInfo:[[AnalysisEngine defaultEngine] candles]];
    [self distributed];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ANALYSIS_CALLBACK object:self.histrogram];
    [autoPool release];

}
/**
 *分布
 */
-(void)distributed{
//    double spe = [AnalysisEngine defaultEngine].possibility;//small probability event
    if (self.histrogram == nil) {
        histrogram = [[Histrogram alloc] initWithHeightFactor:0.9];
        self.histrogram.span = 150;
    }
    NSMutableArray * heights = [[[AnalysisEngine defaultEngine] candles] arrayWithProperty:@"wholeHeight"];
    double max = 0,min = 100000;
    for (NSNumber *num in heights) {
        if ([num doubleValue] < min) {
            min = [num doubleValue];
        }
        if ([num doubleValue] >max) {
            max = [num doubleValue];
            if(max >0.0300){
                [Log report:@"%@",[[[AnalysisEngine defaultEngine] candles] objectAtIndex:[heights indexOfObject:num]]];
            }
        }
    }

    int *counts = calloc(self.histrogram.span ,sizeof(int));

    double atomh = (max - min) / self.histrogram.span;
    
    [Log report:@"最小:%f 最大:%f span:%f",min*ppn,max*ppn,atomh*ppn];
    
    for (int i = 0; i < heights.count; i++) {
        double num = [[heights objectAtIndex:i] doubleValue];
        counts[(int)((num-min) / atomh)]++;
    }
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.histrogram.span; i++) {
        [result addObject:[NSNumber numberWithInt:counts[i]]];
    }
    int sum = 0;
    double percent = 0;
    for (int i = 0; i < self.histrogram.span; i++) {
        sum+= counts[i];
        percent = sum * 1.0f / heights.count;
        if (percent >= spe) {
            [Log report:@"大概率点%d, %f - %f 占全分布的 %f%%",i, min *ppn, (min + atomh * i)*ppn, percent*100];
            break;
        }
    }
    [histrogram calcIndicatorWithNums:result];

    [heights removeAllObjects];
    free(counts);
    [result release];
}

-(void)analysisCandleInfo:(NSArray *)candles{
    Candle *t = nil;
    int countRise = 0,countFall = 0;
    for (int i = 0; i < candles.count; i++) {
        //大小分布
        t = [candles objectAtIndex:i];
        //涨跌
        if (t.type == RISE) {
            countRise++;
        }else{
            countFall++;
        }
    }
    double avgOpen = [Utilities avg:candles key:@"open"];
    double avgClose = [Utilities avg:candles key:@"close"];
    double avgHei = [Utilities avg:candles key:@"height"];
    double avgWholeHei = [Utilities avg:candles key:@"wholeHeight"];
    [Log report:@"\nCandles:"];
    [Log report:@"总数:%d 涨:%d 跌:%d 差:%d  %.2f%%",(int)candles.count,countRise,countFall,ABS(countFall-countRise),ABS(countFall-countRise)*100.0f/MIN(countFall, countRise)];
    [Log report:@"开盘期望:%f 收盘期望:%f",avgOpen,avgClose];
        
    [Log report:@"实体期望:%.2f 方差:%.2f 实体标准差:%.2f",
     avgHei * ppn, 
     [Utilities variance:candles key:@"height"] * pow(ppn, 2),
     [Utilities standardDeviation:candles key:@"height"] * ppn];
    
    [Log report:@"影线期望:%.2f 方差:%.2f 影线标准差:%.2f",
     avgWholeHei * ppn,
     [Utilities variance:candles key:@"wholeHeight"]* pow(ppn, 2),
     [Utilities standardDeviation:candles key:@"wholeHeight"] * ppn];
}
-(BOOL)analyze:(NSString *)params{
    NSDictionary* paramDic = [self paramdicFromString:params];
    if (!paramDic) {
        return NO;
    }
    spe = [[paramDic objectForKey:@"spe"] doubleValue]; 
    ppn = [[paramDic objectForKey:@"ppn"] doubleValue]; 
    return YES;
}

-(NSString *)paramString{
    return [NSString stringWithFormat:@"spe = %.3f\nppn = %.1f",spe,ppn];
}
-(void)printReportHeader{
    [Log report:@"\n"];
    [Log report:@"***************************************************************"];
    [Log report:@"*  Report %@ at %@  *",[AnalysisEngine defaultEngine].curSymbol, [NSDate date]];
    [Log report:@"***************************************************************"];
}
@end