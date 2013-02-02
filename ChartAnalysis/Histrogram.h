//
//  Histrogram.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-26.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "BaseIndicator.h"
#import "IIndicator.h"
#import "ConstDef.h"
@interface Histrogram : BaseIndicator<IIndicator>{
    double _heightFactor;
    double _maxHeight;
    NSMutableArray *keys;
}
@property (nonatomic) double heightFactor;
@property (nonatomic,readonly) double maxHeight;
@property (nonatomic) int span;
@property (nonatomic,retain) NSMutableArray *keys;

-(id)initWithHeightFactor:(double)hf;
-(id)initWithDic:(NSDictionary*)dic hf:(double)hf;

@end
