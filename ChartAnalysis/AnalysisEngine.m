//
//  AnalysisEngine.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-10.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "AnalysisEngine.h"
#import "MVA.h"
#import "TrendLine.h"
#import "Histrogram.h"
#import "Log.h"
@implementation AnalysisEngine
@synthesize candles=_candles,symbols,importer,fdimporter,curSymbol,possibility;
@synthesize funData = _funData;
@synthesize charts = _charts;
-(id)init{
    self = [super init];
    if (self) {
        _chartViews = [[NSMutableArray alloc] init];
        _funData = [[NSMutableArray alloc] init];
        _candles = [[NSMutableArray alloc] init];
        _charts = [[NSMutableArray alloc] init];
        
        db = [[DBService alloc] init];
        [db initSymbolSheet];
        
        fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"yyyy-MM-dd"];
        
        self.possibility = 0.95f;
    }
    return self;
}


+(AnalysisEngine *)defaultEngine{
    static AnalysisEngine *mEngine;
    @synchronized(self){
        if(!mEngine){
            mEngine = [[AnalysisEngine alloc] init];
        }
    }
    return mEngine;
}
-(void)refreshChartViews{
    [_chartViews makeObjectsPerformSelector:@selector(setNeedsDisplay:) 
                                 withObject:[NSNumber numberWithBool:YES]];
}

-(void)importWithPath:(NSString *)path type:(NSString *)type{
    [self.importer importWithPath:path type:type toDb:db];
    self.symbols = [db getAllSymbols];

}

-(void)importFunDataWithType:(int)type start:(NSDate *)start end:(NSDate *)end{
    [db createFundamentalTables];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DATA_IMPORT_PROGRESS object:@"正在载入数据..."];

    switch (type) {
        case MAT_DATA:
            [self.fdimporter loadDataFrom:start to:end inDB:db];
            break;
        case MAT_NEWS:
            [self.fdimporter loadNewsFrom:start to:end inDB:db];
            break; 
        case MAT_ALL:
        default:
            [self.fdimporter loadDataFrom:[self lastDataDate] to:end inDB:db];
            [self.fdimporter loadNewsFrom:[self lastNewsDate] to:end inDB:db];
            break;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DATA_IMPORT_PROGRESS object:@"加载完成!"];
}

-(NSArray *)symbols{
    if(symbols == nil){
        self.symbols = [db getAllSymbols];
    }
    return symbols;
}
-(void)loadFunDataWithType:(int)type start:(NSDate *)date1 end:(NSDate *)date2 nation:(NSString *)nation keywords:(NSString *)key{
    if (type == 0) {
        [_funData removeAllObjects];
        [db getDataWithStart:date1 end:date2 nation:nation key:key inArr:_funData];
    }else if(type == 1){
        [_funData removeAllObjects];
        [db getNewsWithStart:date1 end:date2 nation:nation key:key inArr:_funData];
    }
}
-(void)loadCandles:(NSString *)symbol start:(NSDate*)date1 end:(NSDate *)date2{
    if (symbol != nil && [symbol length]) {
        NSArray *cs = nil;
        if (date1 == nil||date2 == nil) {
            cs = [db getCandlesBySymbol:symbol];
        }else{
            cs = [db getCandlesWithSymbol:symbol start:date1 end:date2];        
        }
        [self.candles removeAllObjects];
        [self.candles addObjectsFromArray:cs];
    }else{
        [importer loadCandlesInFile:nil withType:nil];
        self.candles = importer.candles;
    }
    [self clearChart];
}

-(CandleImporter *)importer
{
    if (importer == nil) {
        importer = [[CandleImporter alloc] init];
    }
    return importer;
}

-(FinanceDataImporter *)fdimporter
{
    if (fdimporter == nil) {
        fdimporter = [[FinanceDataImporter alloc] init];
    }
    return fdimporter;
}

-(NSDate *)lastDataDate{
    NSDate *date = [db lastDataDate];
    if (date) {
        return [date dateByAddingTimeInterval:DAY_SEC];
    }else{
        
        return [fmt dateFromString:@"2007-01-01"];
    }
}

-(NSDate *)lastNewsDate{
    NSDate *date = [db lastNewsDate];
    if (date) {
        return [date dateByAddingTimeInterval:DAY_SEC];
    }else{
        return [fmt dateFromString:@"2007-01-01"];
    }}

-(void)clearChart{
    [_charts removeAllObjects];
}

-(void)removeChartWithId:(long)identifier{
    BaseIndicator *bi;
    for (int i = 0 ;i < _charts.count; i++) {
        bi = [_charts objectAtIndex:i];
        if (bi.identity == identifier) {
            [_charts removeObject:bi];
            i--;
        }
    }
}

-(void)removeChartWithType:(int)type{
    for (BaseIndicator *bi in _charts) {
        if (bi.chartType == type) {
            [_charts removeObject:bi];
        }
    }
}

-(void)addChart:(BaseIndicator *)chart{
    if (chart != nil) {
        [_charts addObject:chart];
    }
}
-(void)removeChart:(BaseIndicator *)chart{
    if (chart != nil) {
        [_charts removeObject:chart];
    }
}

-(void)addChartView:(ChartView *)chart{
    if (chart != nil) {
        [_chartViews addObject:chart];
    }
}
-(void)removeChartView:(ChartView *)chart{
    [_chartViews removeObject:chart];
}

-(ChartView *)getMainChart{
    if (_chartViews&&_chartViews.count) {
        return [_chartViews objectAtIndex:0];
    }else
        return nil; 
}
-(void)dealloc{
    [_curSymbol release];
    [_funData release];
    [symbols release];
    [_charts release];
    [_chartViews release];
    [db release];
    [_candles release];
    [importer release];
    [fdimporter release];
    [super dealloc];
}
@end
