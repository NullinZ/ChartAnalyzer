//
//  Log.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-19.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "Log.h"
#import "ConstDef.h"
@implementation Log
NSMutableString *_report;

+(void)report:(NSString *)format,...{
    if (_report == nil) {
        _report = [[NSMutableString alloc] init];
    }
//    id arg; 
    va_list argList; 
    va_start(argList,format);
    [_report appendString:@"\n"];
    NSString *str = [[NSString alloc] initWithFormat:format arguments:argList];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_ANALYSIS_LOG object:[NSString stringWithFormat:@"\n%@",str]];

    [_report appendString:str];
    [str release];
//    while ((arg = va_arg(argList,id))) 
//    { 
//    } 
    va_end(argList); 

}

+(NSString*)report{
    return _report;
}
+(void)releaseLog{
    [_report release];
    _report = nil;
}
@end
