//
//  PatternAnalyzer.h
//  ChartAnalysis
//
//  Created by 赵 晓敏 on 13-1-10.
//  Copyright (c) 2013年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Candle.h"
#import "RegexKitLite.h"

#define DEMO_STR @"r:#start\nf:o<[$0 c]&h<[$o h 0.3]\nf:0<[@1 c]&h<[@0 h 0.3]"

@interface PatternAnalyzer : NSObject{
    NSArray *candles;
    NSMutableArray *queryResults;
    Candle *candle;
    int patternLength;
    int pointer;
    int offset;
}
@property (retain,nonatomic) NSMutableArray *queryResults;
@property (retain,nonatomic) NSArray *candles;
@property (nonatomic) BOOL check;
@property (nonatomic) int patternLength;
@property (retain,nonatomic) NSMutableString *log;

-(id)init;
-(BOOL)parseMain:(NSString*)source;
-(BOOL)analysisFragment:(NSString *)fragment;

@end
@interface DataDate : NSObject {
    NSDate *_date;
    int _position;
}
@property (nonatomic) int position;
@property (retain,nonatomic) NSDate* date;
-(id)initWithDate:(NSDate*)date Data:(int)position;
@end