//
//  BaseIndicator.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-12.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseIndicator : NSObject
{
    CGColorRef _color;
    int _lineWidth;
    NSMutableArray *_data;
    int _chartType;
    BOOL _needDraw;
    long _identity;
}
@property (nonatomic)CGColorRef color;
@property (nonatomic,retain) NSMutableArray* data;
@property (nonatomic) int lineWidth;
@property (nonatomic) long identity;
@property (nonatomic) BOOL needDraw;
@property (nonatomic) int chartType;

@end
