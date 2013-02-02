//
//  CurveAnalyzer.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-29.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MVA.h"
#import "BaseAnalyzer.h"
#import "IParamAnalyze.h"
@interface CurveAnalyzer : BaseAnalyzer<IParamAnalyze>{
    MVA *mva;
    MVA *aboveLine;
    MVA *belowLine;
    double _fitDegree;
    int _cycle;
}
@property (nonatomic) double fitDegree;
@property (nonatomic) int cycle;
-(void)curveAnalysis;
@end
