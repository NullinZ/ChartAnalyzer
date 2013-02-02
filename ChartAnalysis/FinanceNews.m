//
//  News.m
//  FinacialAlarm
//
//  Created by Sheng Zhao on 12-3-28.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "FinanceNews.h"


@implementation FinanceNews

@synthesize date;
@synthesize _id;
@synthesize title;
@synthesize content;

-(void)dealloc{
    [_id release];
    [content release];
    [title release];
    [date release];
    [super dealloc];
}
@end
