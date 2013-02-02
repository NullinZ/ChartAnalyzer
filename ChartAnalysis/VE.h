//
//  VE.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-20.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "BaseIndicator.h"
#import "IIndicator.h"
@interface VE : BaseIndicator<IIndicator>{
    CGColorRef _riseColor;
    CGColorRef _fallColor;
    CGColorRef _keepColor;
    BOOL _fill;
}
@property (nonatomic) BOOL fill;
@property (nonatomic) CGColorRef riseColor;
@property (nonatomic) CGColorRef fallColor;
@property (nonatomic) CGColorRef keepColor;

@end
