//
//  Trend.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-25.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "Trend.h"

@implementation Trend
@synthesize end = _end,type = _type,start = _start;
-(int)span{
    return _end - _start;
}
-(double)height{
    return ABS(_open - _close);
}
-(NSString *)description{
    switch (_type) {
        case FALL:
            return [NSString stringWithFormat:@"trend:fall[s:%d %f;e:%d %f;d:%d]",_start,_open, _end,_close, _end - _start];
        case RISE:
            return [NSString stringWithFormat:@"trend:rise[s:%d %f;e:%d %f;d:%d]",_start,_open, _end,_close, _end - _start];
        default:
            return [NSString stringWithFormat:@"trend:keep[s:%d %f;e:%d %f;d:%d]",_start,_open, _end,_close, _end - _start];
    }
}

@end
