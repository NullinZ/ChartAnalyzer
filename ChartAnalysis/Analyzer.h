//
//  Analysiser.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-11.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Candle.h"
#import "Histrogram.h"
#import "IParamAnalyze.h"
#import "BaseAnalyzer.h"
@interface Analyzer : BaseAnalyzer<IParamAnalyze>{
}

@property (nonatomic,retain) Histrogram *histrogram;
@property (nonatomic) double ppn;
@property (nonatomic) double spe;

-(void)prepareAnalysis;
@end
