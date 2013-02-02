//
//  Candle.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-1.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "Candle.h"
#import "ConstDef.h"
@implementation Candle
@synthesize high,open = _open,low,close = _close,volume,date;
-(NSString *)description{
    return [NSString stringWithFormat:@"date:%@ open:%.5f high:%.5f low:%.5f close:%.5f",self.date, self.open,self.high,self.low,self.close];
}
-(double)height{
    return ABS(self.open - self.close);
}

-(double)wholeHeight{
    return ABS(self.high - self.low);
}

-(void)dealloc{
    [date release];
    [super dealloc];
}

-(int)type{
    if (_open > _close) {
        return FALL;
    }else if(_open < _close){
        return RISE;
    }else{
        return KEEP;
    }
}
@end
