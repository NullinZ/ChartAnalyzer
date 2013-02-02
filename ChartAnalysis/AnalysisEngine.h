//
//  AnalysisEngine.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-10.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CandleImporter.h"
#import "FinanceDataImporter.h"
#import "ChartController.h"
#import "DBService.h"
#import "ChartView.h"
#import "Analyzer.h"
#import "ConstDef.h"
#import "BaseIndicator.h"
#import "AnalyzerController.h"

@interface AnalysisEngine : NSObject{
    NSMutableArray *_candles;
    NSMutableArray *_funData;
    NSMutableArray *_charts;
    NSMutableArray *_chartViews;
    NSString *_curSymbol;
    NSArray *symbols;
    
    CandleImporter *importer;
    FinanceDataImporter *fdimporter;
    DBService *db;
    
    NSDateFormatter *fmt;
}


@property (retain) NSMutableArray* charts;
@property (nonatomic,retain) NSMutableArray *candles;
@property (nonatomic,retain) NSMutableArray *funData;
@property (nonatomic,retain) NSString *curSymbol;
@property (nonatomic,retain) CandleImporter *importer;
@property (nonatomic,retain) FinanceDataImporter *fdimporter;
@property (nonatomic,retain) NSArray *symbols;
@property (nonatomic) double possibility;

+(AnalysisEngine*)defaultEngine;
-(void)importWithPath:(NSString*)path type:(NSString *)type;
-(void)loadCandles:(NSString *)symbol start:(NSDate*)date1 end:(NSDate *)date2;
-(void)loadFunDataWithType:(int)type start:(NSDate *)date1 end:(NSDate *)date2 nation:(NSString *)nation keywords:(NSString*)key;

-(ChartView*)getMainChart;

-(void)addChart:(BaseIndicator*)chart;
-(void)removeChart:(BaseIndicator*)chart;
-(void)clearChart;
-(void)removeChartWithId:(long)identifier;
-(void)removeChartWithType:(int)type;

-(void)addChartView:(ChartView *)chart;
-(void)removeChartView:(ChartView *)chart;
-(void)refreshChartViews;

-(void)importFunDataWithType:(int)type start:(NSDate *)start end:(NSDate *)end;

-(NSDate *)lastNewsDate;
-(NSDate *)lastDataDate;
@end
