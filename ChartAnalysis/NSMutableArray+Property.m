//
//  NSMutableArray+Property.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-10.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "NSMutableArray+Property.h"

@implementation NSMutableArray (Property)

-(NSMutableArray *)arrayWithProperty:(NSString *)propName{
    NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
    NSObject* prop;
    for (NSObject* obj in self) {
        prop = [obj valueForKey:propName];
        if (prop) {
            [result addObject:prop];
        }
    }
    return result;
}

@end
