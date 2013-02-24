//
//  Symbol.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-4.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "Symbol.h"

@implementation Symbol
@synthesize name,count,dateSpan,importDate,loadCount,sourceType;
-(NSString *)description{
    
    return [NSString stringWithFormat:@"name:%@ count:%d dateSpan:%@",name,count,dateSpan];
}
-(void)dealloc{
    [name release];
    [dateSpan release];
    [importDate release];
    [super dealloc];
}
@end
