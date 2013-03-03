//
//  IIndicator.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-12.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IIndicator <NSObject>

@required
-(void)calcIndicatorWithNums:(NSArray*)numbers;
@optional
-(void)doDraw:(CGContextRef)context withPointWidth:(int) pointWidth rangeStart:(int)rangeStart rangeEnd:(int)rangeEnd rangeStartY:(int)rangeStartY deltaY:(int)deltaY width:(int)width height:(int)height k:(double)k h:(double)h px:(int)px;

@end
