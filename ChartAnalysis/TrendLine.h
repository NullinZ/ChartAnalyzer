//
//  TrendLine.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-14.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "BaseIndicator.h"
#import "IIndicator.h"
@interface TrendLine : BaseIndicator<IIndicator>{
    int _start;
    int _end;
    double _ys,_ye;
}

-(id)initWithStart:(int)start end:(int)end;
@end
