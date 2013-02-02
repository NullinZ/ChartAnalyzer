//
//  CurveAnalyzer.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-29.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "CurveAnalyzer.h"
#import "AnalysisEngine.h"
#import "Log.h"
@interface CurveAnalyzer()
-(void)genMVA:(int)peroid;
-(void)printReportHeader;

@end
@implementation CurveAnalyzer

@synthesize fitDegree = _fitDegree,cycle=_cycle;

-(id)init{
    self = [super init];
    if (self) {
        _fitDegree = 0.05*0.01;
        _cycle = 104;
    }
    return self;
}

-(void)curveAnalysis{
    NSAutoreleasePool *autoPool = [[NSAutoreleasePool alloc] init];
    AnalysisEngine *engine = [AnalysisEngine defaultEngine];
    [self printReportHeader];
    [self genMVA:_cycle];

    NSArray *candles = [AnalysisEngine defaultEngine].candles;
    
    Candle *c = nil;
    double m = 0;
    double belowRate = 1;
    double aboveRate = 1;
    int count = 0;
    int countAbove = 0,countBelow = 0,countCross = 0;
    int countAN = 0,countBN = 0,countANN = 0,countBNN = 0;
    for (int i = 0; i < candles.count; i++) {
        c = [candles objectAtIndex:i];
        m = [[mva.data objectAtIndex:i] doubleValue];
        aboveRate = m * (1 + _fitDegree);
        belowRate = m * (1 - _fitDegree);
        if (m < 0) {
            continue;
        }
        count++;
        if (c.high < belowRate) {
            countBelow++;
        }else if(c.low > aboveRate){
            countAbove++;
        }
        if (MIN(c.open, c.close) > belowRate && MAX(c.open, c.close) <= m) {
            countBNN++;
        }
        if (MAX(c.open, c.close) < aboveRate && MIN(c.open, c.close) >= m) {
            countANN++;
        }
        if(c.high >= belowRate&&c.high <= m){
            countBN++;
        }else if(c.low <= aboveRate&& c.low >= m){
            countAN++;
        }
        if ((c.open < m && c.close > m)||(c.open > m && c.close < m)) {
            countCross++;
        }
    }
    [Log report:@"总数:%d 线上:%d 线下:%d 突破:%d 突破率:%.2f%%",count, countAbove, countBelow, countCross,countCross*100.0/count];
    [Log report:@"下触:%d 上触:%d 贴近(上):%d 贴近(下):%d",countAN, countBN,countANN,countBNN];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ANALYSIS_CALLBACK object:mva];
    
    if (!aboveLine) {
        aboveLine = [[MVA alloc] initWithPeroid:_cycle];
        aboveLine.identity = [engine getMainChart]?(long)[engine getMainChart]:0;
        [aboveLine setColor:CGColorCreateGenericRGB(1, 0, 0, .1)];
    }
    
    [aboveLine calcIndicatorWithNums:[engine.candles arrayWithProperty:@"close"] scale:1 + _fitDegree];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ANALYSIS_CALLBACK object:aboveLine];
    if (!belowLine) {
        belowLine = [[MVA alloc] initWithPeroid:_cycle];
        belowLine.identity = [engine getMainChart]?(long)[engine getMainChart]:0;
        [belowLine setColor:CGColorCreateGenericRGB(1, 0, 0, .1)];
    }
    [belowLine calcIndicatorWithNums:[engine.candles arrayWithProperty:@"close"] scale:1 - _fitDegree];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ANALYSIS_CALLBACK object:belowLine];
    
    [autoPool release];
}

-(void)genMVA:(int)peroid{
    AnalysisEngine *engine = [AnalysisEngine defaultEngine];
    if (!mva) {
        mva = [[MVA alloc] initWithPeroid:_cycle];
    }
    mva.periods = peroid;
    mva.identity = [engine getMainChart]?(long)[engine getMainChart]:0;

    [mva calcIndicatorWithNums:[engine.candles arrayWithProperty:@"close"]];
}
-(BOOL)analyze:(NSString *)params{
    NSDictionary* paramDic = [self paramdicFromString:params];
    if (!paramDic) {
        return NO;
    }
    _cycle = [[paramDic objectForKey:@"cycle"] intValue]; 
    _fitDegree = [[paramDic objectForKey:@"fitDegree"] doubleValue]; 
    return YES;
}

-(NSString *)paramString{
    return [NSString stringWithFormat:@"cycle = %d\nfitDegree = %.4f",_cycle,_fitDegree];
}
-(void)printReportHeader{
    [Log report:@"\n"];
    [Log report:@"***************Curve Analysis*********************"];
}

@end
