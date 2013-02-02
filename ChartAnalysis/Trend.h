//
//  Trend.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-25.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Candle.h"
@interface Trend : Candle {
    int _start;
    int _end;
    int _type;
}
@property (nonatomic) int start;
@property (nonatomic) int end;
@property (nonatomic) int type;
-(int)span;
-(double)height;
@end
