//
//  Candle.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-1.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RISE 1
#define FALL -1
#define KEEP 0

@interface Candle : NSObject{
    double low;
    double high;
    double _open;
    double _close;
    NSDate *date;
    int volume;
}
@property (nonatomic) double low;
@property (nonatomic) double high;
@property (nonatomic) double open;
@property (nonatomic) double close;
@property (retain,nonatomic) NSDate *date;
@property int volume;
-(double)height;
-(double)wholeHeight;
-(int)type;
@end
