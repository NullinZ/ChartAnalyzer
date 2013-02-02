//
//  ChartView.h
//  FinacialSSI
//
//  Created by Sheng Zhao on 12-7-29.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Candle.h"
#import "NSMutableArray+Property.h"
@class ChartController;
@interface ChartView : NSView{
@public
    BOOL isAnchorShow;
    int anchorStartX;
    
    ChartController *controller;
    BOOL _reload;
    int rangeStart;
    int rangeEnd;
    double _factor;
    BOOL _autoFit;
@private
    //当前鼠标位置
    int px;
    int py;
    //开始拖动鼠标位置
    int dragStartX;
    int dragStartY;
    //鼠标拖动距离
    int dragDeltaX;
    int dragDeltaY;
    //图的起始位置
    int rangeStartX;
    int rangeStartY;
    //蜡烛图宽度，屏幕宽高
    int pointWidth;
    int width;
    int height;
    
    int _cycle;
    //数据最大最小值，高比例，高偏移
    double max;
    double min;
    double k;
    double h;
    NSDateFormatter *fmt;
    Candle* _curCandle;
}
@property (nonatomic,retain) IBOutlet ChartController *controller;
@property (nonatomic,retain) Candle *curCandle;
@property (nonatomic) BOOL candleNeedDraw;
@property (nonatomic) BOOL isAnchorShow ;
@property (nonatomic) int pointWidth;
@property (nonatomic) int rangeStartX;
@property (nonatomic) int rangeStart;
@property (nonatomic) int rangeEnd;
@property (nonatomic) int cycle;
@property (nonatomic) double factor;
@property (nonatomic) BOOL autoFit;
@property (nonatomic) BOOL reload;

@end