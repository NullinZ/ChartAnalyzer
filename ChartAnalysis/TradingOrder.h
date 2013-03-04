//
//  TradingOrder.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 13-3-3.
//  Copyright (c) 2013年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TradingAction.h"

@interface TradingOrder : NSObject
{
    long tradingId;
    TradingAction *startAction;
    TradingAction *endAction;
    double points;
    double earning;
    double interest;
    double limit;
    double stop;
}
@property (retain,nonatomic) TradingAction *startAction;
@property (retain,nonatomic) TradingAction *endAction;
@property (nonatomic) long tradingId;
@property (nonatomic) double points;
@property (nonatomic) double earning;
@property (nonatomic) double interest;
@property (nonatomic) double limit;
@property (nonatomic) double stop;

@end
