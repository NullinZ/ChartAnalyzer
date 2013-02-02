//
//  TrendAnalyzer.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-25.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "TrendAnalyzer.h"
#import "AnalysisEngine.h"
#import "Utilities.h"
#import "Trend.h"
#import "Log.h"
@interface TrendAnalyzer(Trend){
}
-(void)printReportHeader;
-(void)analysisTrendInfo:(NSArray *)trends;
-(void)mergeCandleInTrends:(NSMutableArray*)trends;
-(void)reduce:(NSMutableArray *)trends factor:(double)factor span:(int)span;
-(void)reduceKeepTrends:(NSMutableArray *)trends factor:(double)factor span:(int)span;

@end
@implementation TrendAnalyzer

-(void)trendAnalysis{
    NSAutoreleasePool *autoPool = [[NSAutoreleasePool alloc] init];
    AnalysisEngine *engine = [AnalysisEngine defaultEngine];
    NSMutableArray *candles = engine.candles;
    
    if (candles == nil || !candles.count) {
        NSLog(@"analyzer:candles is nil");
        return;
    }
    [self printReportHeader];

    NSMutableArray *trends = [[NSMutableArray alloc] init];
    [self mergeCandleInTrends:trends];
    [self analysisTrendInfo:trends];
    
    [self reduce:trends factor:0.38 span:3];
    [self analysisTrendInfo:trends];
    
    [self reduce:trends factor:0.5 span:5];
    [self analysisTrendInfo:trends];
    
    [self reduceKeepTrends:trends factor:0.6 span:3];
    [self analysisTrendInfo:trends];
//    [self reduceKeepTrends:trends factor:0.6 span:10];
//    [self analysisTrendInfo:trends];
    if (!ve) {
        ve = [[VE alloc] init];
    }
    [ve calcIndicatorWithNums: trends];
    ve.identity = [engine getMainChart]?(long)[engine getMainChart]:0;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ANALYSIS_CALLBACK object:ve];
    [trends release];
    [autoPool release];
}

-(void)mergeCandleInTrends:(NSMutableArray *)trends{
    AnalysisEngine *engine = [AnalysisEngine defaultEngine];
    NSMutableArray *candles = engine.candles;
    
    //合并相邻相同的烛线
    //candle ,last trend candle,last candle
    Candle* c = [candles objectAtIndex:0];
    Candle* lc = nil;
    
    Trend *t = [[Trend alloc] init];
    t.start = 0;
    t.open = c.open;
    t.high = c.high;
    t.low = c.low;
    t.type = c.type;
    
    for (int i = 1; i < candles.count - 1; i++) {
        lc = c;
        c = [candles objectAtIndex:i];
        if (c.type == t.type|| c.type == KEEP){
            continue;
        }else{
            t.end = i - 1;
            t.close = lc.close;
            t.high = MAX(c.high,t.high);
            t.low = MIN(c.low,t.low);
            [trends addObject:t];
            [t release];
            t = [[Trend alloc] init];
            t.start = i;
            t.open = c.open;
            t.type = c.type;
            t.high = c.high;
            t.low = c.low;
        }
    }
    t.end = (int)candles.count - 1;
    t.close = c.close;
    t.high = MAX(c.high,t.high);
    t.low = MIN(c.low,t.low);
    [trends addObject:t];
    [t release];

}

//factor 简化最大高度比例
//width 简化最大周期跨度
-(void)reduce:(NSMutableArray *)trends factor:(double)factor span:(int)span{
    [Log report:@"reduce trends factor:%f span:%d",factor,span];
    if (trends&&trends.count&&[[trends objectAtIndex:0] isKindOfClass:Trend.class]) {
        Trend *t = [trends objectAtIndex:0];
        Trend *pret,*next;
        for (int i = 1; i < trends.count; i++) {
            pret = t;
            next = [trends objectAtIndex:MIN(trends.count - 1, i+1)];
            
            t = [trends objectAtIndex:i];
            
            if (t.span <= span && t.height < pret.height *factor&& t.height < next.height) {
                t.start = pret.start;
                t.open = pret.open;
                t.end = next.end;
                t.close = next.close;
                t.type = pret.type;
                [trends removeObject:pret];
                [trends removeObject:next];
                i--;
            }
        }
    }
}

-(void)reduceKeepTrends:(NSMutableArray *)trends factor:(double)factor span:(int)span{
    [Log report:@"reduce keep trends \nfactor:%f span:%d",factor,span];
    if (trends&&trends.count&&[[trends objectAtIndex:0] isKindOfClass:Trend.class]) {
        Trend *t = nil;
        Trend *next = nil;
        for (int i = 0; i < trends.count - 1; i++) {
            
            t = [trends objectAtIndex:i];
            if (t.span <= span) {
                int j = i + 1;
                next = [trends objectAtIndex:j];
                while (next.span <= span && ((t.height < next.height && t.height > next.height * factor)||(t.height *factor < next.height&&t.height > next.height))) {
                    t.close = next.close;
                    t.end = next.end;
                    t.type = KEEP;
                    [trends removeObject:next];
                    if (j < trends.count) {
                        next = [trends objectAtIndex:j];
                    }else{
                        break;
                    }
                }
            }
        }
    }
}

-(void)analysisTrendInfo:(NSArray *)trends{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    Trend *t = nil;
    int sumRise = 0,sumFall = 0;
    for (int i = 0; i < trends.count; i++) {
        //大小分布
        t = [trends objectAtIndex:i];
        NSNumber *n = [NSNumber numberWithInt:t.end - t.start + 1];
        NSNumber *item = [dic objectForKey:n.stringValue];
        if (item) {
            [dic setValue:[NSNumber numberWithInt:item.intValue +1]  forKey:n.stringValue];
        }else{
            [dic setValue:[NSNumber numberWithInt:1]  forKey:n.stringValue];
        }
        //涨跌
        if (t.type == RISE) {
            sumRise++;
        }else{
            sumFall++;
        }
    }
    [Log report:@"\nTrend:"];
    [Log report:@"总数:%d 涨:%d 跌:%d",(int)trends.count,sumRise,sumFall];
    
    [Log report:@"宽度期望:%f",[Utilities avg:trends key:@"span"]];
    [Log report:@"宽度方差:%f",[Utilities variance:trends key:@"span"]];
    [Log report:@"宽度标准差:%f",[Utilities standardDeviation:trends key:@"span"]];
//    [Log report:@"宽度分布:\n%@",dic];
    Histrogram *h = [[Histrogram alloc] initWithDic:dic hf:0.7];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ANALYSIS_CALLBACK object:h];
    [h release];

    [dic release];
}

-(BOOL)analyze:(NSString *)params{
    return YES;
}

-(NSString *)paramString{
    return @"";
}
-(void)printReportHeader{
    [Log report:@"\n"];
    [Log report:@"********************Trend Analysis**********************"];
 }
-(void)dealloc{
    [ve release];
    [super dealloc];
}
@end
