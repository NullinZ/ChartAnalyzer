//
//  TrendAnalyzer.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-25.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VE.h"
#import "BaseAnalyzer.h"
#import "IParamAnalyze.h"

@interface TrendAnalyzer : BaseAnalyzer<IParamAnalyze>{
    VE *ve;
}
-(void)trendAnalysis;

@end
