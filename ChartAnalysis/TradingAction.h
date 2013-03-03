//
//  TradingAction.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 13-3-3.
//  Copyright (c) 2013年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradingAction : NSObject
{
    NSString *symbol;
    int volume;
    NSDate *time;
    int tradingType;
    double price;
    
}

@property (retain,nonatomic) NSString* symbol;
@property (retain,nonatomic) NSDate *time;
@property (nonatomic) int volume;
@property (nonatomic) int tradingType;
@property (nonatomic) double price;
@end
