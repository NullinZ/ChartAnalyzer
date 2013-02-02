//
//  BaseAnalyzer.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-11-1.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "BaseAnalyzer.h"

@implementation BaseAnalyzer
-(NSDictionary*)paramdicFromString:(NSString *)string{

    NSMutableDictionary *ret = [[[NSMutableDictionary alloc] init] autorelease];
    NSArray *lines = [string componentsSeparatedByString:@"\n"];
    NSArray *line = nil;
    NSString *key = nil; 
    NSString *value = nil; 
    for (int i = 0; i < lines.count; i++) {
        line = [[lines objectAtIndex:i] componentsSeparatedByString:@"="];
        if (line.count == 2) {
            key = [[line objectAtIndex:0]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            value = [[line objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [ret setValue:value forKey:key];
        }else{
            NSLog(@"解析错误第%d行",i);
            return nil;
        }
    }
    return ret;
}

@end
