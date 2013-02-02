//
//  IndicatorGenerator.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-15.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrendLine.h"
#import "ChartView.h"
#import "ConstDef.h"
#import "MVA.h"
@interface IndicatorGenerator : NSObject
+(IndicatorGenerator *)shareGenerator;
-(NSArray*)genChartWithData:(NSArray*)data type:(NSString*)type param:(NSArray *)params;
@end
