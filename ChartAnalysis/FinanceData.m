//
//  Indicator.m
//  FinacialAlarm
//
//  Created by Sheng Zhao on 12-3-27.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "FinanceData.h"


@implementation FinanceData

@synthesize actualValue;
@synthesize content;
@synthesize date;
@synthesize forecastValue;
@synthesize _id;
@synthesize level;
@synthesize notime;
@synthesize previousValue;
@synthesize title;
-(void)dealloc{
    [actualValue release];
    [content release];
    [date release];
    [forecastValue release];
    [_id release];
    [level release];
    [notime release];
    [previousValue release];
    [title release];
    [super dealloc];
}
@end
