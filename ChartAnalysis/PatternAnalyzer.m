//
//  PatternAnalyzer.m
//  ChartAnalysis
//
//  Created by 赵 晓敏 on 13-1-10.
//  Copyright (c) 2013年 Innovation Workshop. All rights reserved.
//

#import "PatternAnalyzer.h"
#import "AnalysisEngine.h"

#define OR @"|"
#define AND @"&"
//status
#define SANY @"a" //any
#define SKEEP @"k" //keep
#define SRISE @"r" //rise
#define SFALL @"f" //fall
#define SSAME @"s" //same
#define SDIFF @"d" //diff
//properties
#define OPEN @"o"
#define CLOSE @"c"
#define TOP @"t"
#define BOTTOM @"b"
#define LENGTH @"l"
#define HEIGHT @"h"
//reference
#define REF @"$"
#define COMMON @"#"
//mark equal larger than & smaller than
#define EQ @"="
#define LT @">"
#define ST @"<"
#define regExp @"(?<=\\[).+?(?=\\])"
#define regMark @"[+-]"//@"(?<=\\]).+?(?=\\[)"

@implementation DataDate
@synthesize position = _position,date = _date;
-(id)initWithDate:(NSDate *)date Data:(int)position{
    self = [super init];
    if (self) {
        self.position = position;
        self.date = date;
    }
    return self;
}
@end

@interface PatternAnalyzer()
-(BOOL)assertLine:(NSString*)line;
-(BOOL)assertStatus:(NSString*)status;
-(BOOL)assertExpression:(NSString*) expression;
-(BOOL)getRange:(NSString *)range Ret:(int[2])result;

-(double)valueOfExpression:(NSString*)expression;
-(double)valueOfProp:(NSString*)expression;

-(BOOL)isPureInt:(NSString *)string;
-(BOOL)isPureFloat:(NSString *)string;


@end
@implementation PatternAnalyzer
@synthesize candles,queryResults,log,check,patternLength;

-(id)init{
    self = [super init];
    if (self) {
        candles = [[AnalysisEngine defaultEngine] candles];
        queryResults = [[NSMutableArray alloc] init];
        if ([candles count] >0) {
            pointer = 0;
            offset = 0;
            candle = [candles objectAtIndex:0];
        }else{
            pointer = 0;
            offset = 0;
            candle = nil;
        }
        check = NO;
        log = [[NSMutableString alloc] init];
    }
    return self;
}
//主解析方法
-(BOOL)parseMain:(NSString*)sourceStr{
    if (sourceStr == nil) {
        return NO;
    }
    [queryResults removeAllObjects];
    BOOL result = YES;
    for (pointer = 0; pointer < candles.count; pointer++) {
        result = [self analysisFragment:sourceStr];
        if(result&&!check) {
//            NSLog(@"%@",[candles objectAtIndex:pointer]);
            DataDate *date =[[DataDate alloc] initWithDate:((Candle*)[candles objectAtIndex:pointer]).date Data:pointer];
            [queryResults addObject:date];
            [date release];
            
        }
    }
    return YES;
}

-(BOOL)analysisFragment:(NSString *)fragment{
    fragment = [fragment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *lines = [fragment componentsSeparatedByString:@"\n"];
    if (lines&&lines.count) {
        patternLength = (int)lines.count;
    }else{
        @throw [NSException exceptionWithName:@"语句符号" reason:[NSString stringWithFormat:@"line:%d error:analysisFragment:语句为空\n",offset] userInfo:nil];        
    }
    if (pointer + lines.count >= candles.count&&!check) {
        return NO;
    }
    if (check) {
        pointer = 0;
    }
    NSArray *lineFgmts;
    NSString *line,*status;
    int range[2];
    BOOL isRangeLine = NO;
    offset = 0;
    for (int i = 0; i < [lines count]; i++) {
        line = [lines objectAtIndex:i];
        candle = [candles objectAtIndex:pointer + offset++];
        BOOL result = NO;
        lineFgmts = [line componentsSeparatedByString:@":"];
        if ([lineFgmts count] < 2) {
            @throw [NSException exceptionWithName:@"状态符号" reason:[NSString stringWithFormat:@"line:%d error:parseLine:语句必须包含状态,和断言用:隔开\n",offset] userInfo:nil];        
            return NO;
        }
        status = [lineFgmts objectAtIndex:0];
        if (!isRangeLine&&[COMMON isEqualToString:status]) {
           isRangeLine = [self getRange:[lineFgmts objectAtIndex:1] Ret:range];
        }
        result = [self assertStatus:status];
        if (!result&&!check) {
            return NO;
        }
        if (isRangeLine) {
            offset += range[0];
            continue;
        }
        if (![self assertLine:[lineFgmts objectAtIndex:1]]) {
            if(!check){
                return NO;
            }
        }
    }
    return YES;
}

//将每一行分解为表达式
-(BOOL)assertLine:(NSString*)line{
       //and优先级大于or 先分and 再分or
    NSArray *conditions = [line componentsSeparatedByString:AND];
    BOOL resAnd = YES;
    BOOL tmpOr = NO;
    BOOL resOr = NO;
    for (NSString *conAnd in conditions) {
        NSArray * conditions2= [conAnd componentsSeparatedByString:OR];
        resOr = NO;
        for (NSString*conOr in conditions2) {
            tmpOr = [self assertExpression:conOr];
            resOr|=tmpOr;
        }
        resAnd&=resOr;
        if(!resAnd&&!check){
            return NO;
        }
    }
    return resAnd;
    
}

//解析可变周期
-(BOOL)getRange:(NSString *)range Ret:(int[2])result{
    if (range == nil) {
        return NO;
    }
    NSArray *rangeNum = [range componentsSeparatedByString:@","];
    if (rangeNum == nil||rangeNum.count != 1) {
        return NO;
    }
    result [0] = [[[rangeNum objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
    result [1] = [[[rangeNum objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
    return YES;
}
//解析状态
-(BOOL)assertStatus:(NSString*)status{
    if (!status) {
        return NO;
    }
    if ([status isEqualToString:SANY]) {
        return [candle type] == KEEP||[candle type] == RISE||[candle type] == FALL;
        
    }else if ([status isEqualToString:SKEEP]) {
        return [candle type] == KEEP;
        
    }else if ([status isEqualToString:SRISE]) {
        return [candle type] == RISE;
        
    }else if ([status isEqualToString:SFALL]) {
        return [candle type] == FALL;
    }else if ([status isEqualToString:SSAME]){
        int index = MAX(pointer + offset -2, 0);
        return [candle type] == [(Candle*)[candles objectAtIndex:index] type];
    }else if ([status isEqualToString:SDIFF]){
        int index = MAX(pointer + offset -2, 0);
        return [candle type] != [(Candle*)[candles objectAtIndex:index] type];
    }else{
        @throw [NSException  exceptionWithName:@"解析状态" reason:[NSString stringWithFormat:@"line:%d error:parseExpression:断言状态符只可以为a/k/r/f\n",offset] userInfo:nil];        
    }
}

-(BOOL)assertExpression:(NSString*) expression{
    if ([expression rangeOfString:EQ].length) {
        NSArray *symbols = [expression componentsSeparatedByString:EQ];
        return [self valueOfExpression:[symbols objectAtIndex:0]] == [self valueOfExpression:[symbols objectAtIndex:1]];
    }else if([expression rangeOfString:LT].length){
        NSArray *symbols = [expression componentsSeparatedByString:LT];
        return [self valueOfExpression:[symbols objectAtIndex:0]] >= [self valueOfExpression:[symbols objectAtIndex:1]];
    }else if([expression rangeOfString:ST].length){
        NSArray *symbols = [expression componentsSeparatedByString:ST];
        return [self valueOfExpression:[symbols objectAtIndex:0]] <= [self valueOfExpression:[symbols objectAtIndex:1]];
    }else{
        if ([expression rangeOfRegex:COMMON].location == 0) {
            return YES;
        }
        @throw [NSException  exceptionWithName:@"解析符号" reason:[NSString stringWithFormat:@"line:%d error:parseExpression:断言符号只可以为>/</=\n",offset] userInfo:nil];        
    }
    return YES;
}


-(double)valueOfExpression:(NSString*)expression{
    NSArray *arrExp = [expression componentsSeparatedByRegex:regMark];
    NSArray *arrMark = [expression componentsMatchedByRegex:regMark];
    double result = 0;
    if (![arrExp count]) {
        return [self valueOfProp:expression];
    }else{
        result = [self valueOfProp:[arrExp objectAtIndex:0]];
        NSString *mark;
        for (int i = 1; i < [arrExp count]; i++) {
            mark = [[arrMark objectAtIndex:i-1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([mark isEqualToString:@"+"]) {
                result+=[self valueOfProp:[arrExp objectAtIndex:i]];
            }else if([mark isEqualToString:@"-"]){
                result-=[self valueOfProp:[arrExp objectAtIndex:i]];                
            }else{
                @throw [NSException  exceptionWithName:@"解析符号" reason:[NSString stringWithFormat:@"line:%d error:valueOfExpression:属性运算只能为+/-\n",offset] userInfo:nil];
            }
        }
        return result;
    }
}


-(double)valueOfProp:(NSString*)expression{
    expression = [[expression stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByReplacingOccurrencesOfRegex:@"[\\[\\]]" withString:@""];
    NSArray *item = [expression componentsSeparatedByRegex:@"\\s+"];
    Candle *c;
    NSString *prop;
    double result;
    BOOL noRef = NO;
    if ([item count] == 1||[item count] == 0) {
        c = candle;
        prop = [expression stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([self isPureFloat:prop]){
            return [prop doubleValue];
        }
    }else if([item count] <= 3){
        NSString* ref = [[item objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([ref rangeOfString:REF].length) {
            ref = [ref substringFromIndex:1];
            if ([self isPureInt:ref]) {
                c = [candles objectAtIndex:pointer + [ref intValue]];
                prop = [[item objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];            
            }else{
                @throw [NSException  exceptionWithName:@"解析属性引用" reason:[NSString stringWithFormat:@"line:%d error:valueOfProp:引用索引有误\n",offset] userInfo:nil];
            }
        }else{
            noRef = YES;
            c = [candles objectAtIndex:pointer + [ref intValue]];
            prop = [[item objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  
            //@throw [NSException  exceptionWithName:@"解析属性" reason:[NSString stringWithFormat:@"line:%d error:valueOfProp:引用格式有误\n",offset] userInfo:nil];
        }

    }
    if ([prop isEqualToString:OPEN]) {
        result = c.open;
    }else if([prop isEqualToString:CLOSE]) {
        result = c.close;            
    }else if([prop isEqualToString:TOP]) {
        result = c.high;
    }else if([prop isEqualToString:BOTTOM]) {
        result = c.low;
    }else if([prop isEqualToString:HEIGHT]) {
        result = c.height;
    }else if([prop isEqualToString:LENGTH]) {
        result = c.wholeHeight;
    }else{
        @throw [NSException  exceptionWithName:@"解析属性" reason:[NSString stringWithFormat:@"line:%d error:valueOfProp:属性名不存在\n",offset] userInfo:nil];
    }
    if ([item count] == 3||noRef) {
        NSString* factor = [[item objectAtIndex:noRef?
                             1:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([self isPureFloat:factor]) {
            result *= [factor doubleValue];
        }else{
            @throw [NSException  exceptionWithName:@"解析属性" reason:[NSString stringWithFormat:@"line:%d error:valueOfProp:属性系数应为数值",offset] userInfo:nil];
        }
    }
    return result;
    
}


- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string]; 
    int val; 
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string]; 
    float val; 
    return [scan scanFloat:&val] && [scan isAtEnd];
}
@end
