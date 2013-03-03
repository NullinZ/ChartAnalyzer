//
//  FileLoader.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-2.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "CandleImporter.h"
#import "Candle.h"
@interface CandleImporter(Private){
}
-(Candle*)parseCancleTSCSV:(NSString *)str;
-(Candle*)parseCancleMT4CSV:(NSString *)str;

@end
@implementation CandleImporter
@synthesize defaultManager,candles;
-(id)init{
    self = [super init];
    if(self){
        defaultManager = [NSFileManager defaultManager];
        candles = [[NSMutableArray alloc] init];
    }
    return self;

}

-(BOOL)loadCandlesInFile:(NSString *)path withType:(NSString *)type{
    if (!path) {
        path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"txt"];
        type = FILE_TYPE_TS2;
    }
    NSError *error = [[[NSError alloc] init] autorelease];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if(!str||error.code){
        return NO;
    }
    NSArray *candleStrs = [str componentsSeparatedByString:@"\n"];
    [candles removeAllObjects];
    if (!candleStrs || !candleStrs.count) {
        return NO;
    }
    int start = 0;
    if ([type isEqualToString:FILE_TYPE_TS2]) {
        start = 1;
    }
    Candle *c = nil;
    for (int i = start; i<[candleStrs count]; i++) {
        if ([type isEqualToString:FILE_TYPE_MT4]) {
            c = [self parseCancleMT4CSV:[candleStrs objectAtIndex:i]];
        }else if([type isEqualToString:FILE_TYPE_TS2]){
            c = [self parseCancleTSCSV:[candleStrs objectAtIndex:i]];
        }
        if (c){
            [candles addObject:c];
        }else if(i != candleStrs.count - 1){
            return NO;
        }
    }
    return YES;

}
-(Candle *)parseCancleTSCSV:(NSString *)str{
    Candle *candle = [[[Candle alloc] init] autorelease];
    if (!str) {
        return nil;
    }
     
    NSArray *items =  [str componentsSeparatedByString:@";"];
    if (!items || [items count] != 12) {
        return nil;
    }
    NSString *date = [items objectAtIndex:1];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
    
    candle.date = [dateFormatter dateFromString:date];
    [dateFormatter release];
    NSString *open = [items objectAtIndex:2];
    candle.open = [open doubleValue];
    NSString * high= [items objectAtIndex:3];
    candle.high = [high doubleValue];
    NSString *low = [items objectAtIndex:4];
    candle.low = [low doubleValue];
    NSString *close = [items objectAtIndex:5];
    candle.close = [close doubleValue];
    NSString *volume = [items objectAtIndex:10];
    candle.volume = [volume intValue];
    return candle;
    
}

-(Candle *)parseCancleMT4CSV:(NSString *)str{
    Candle *candle = [[[Candle alloc] init] autorelease];
    if (!str) {
        return nil;
    }
    
    NSArray *items =  [str componentsSeparatedByString:@","];
    if (!items||[items count] != 7) {
        return nil;
    }
    NSString *date = [items objectAtIndex:0];
    NSString *time = [items objectAtIndex:1];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; 
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSString *datetime = [NSString stringWithFormat:@"%@ %@",date,time];
    candle.date = [dateFormatter dateFromString:datetime];
    [dateFormatter release];
    NSString *open = [items objectAtIndex:2];
    candle.open = [open doubleValue];
    NSString * high= [items objectAtIndex:3];
    candle.high = [high doubleValue];
    NSString *low = [items objectAtIndex:4];
    candle.low = [low doubleValue];
    NSString *close = [items objectAtIndex:5];
    candle.close = [close doubleValue];
    NSString *volume = [items objectAtIndex:6];
    candle.volume = [volume intValue];
    return candle;
    
}

-(void)importWithPath:(NSString*)path type:(NSString *)type toDb:(DBService *)db{
    NSString *name = [[path lastPathComponent] stringByDeletingPathExtension];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
    NSAlert *alert = [[NSAlert alloc] init];
    if(!name || [name length] == 0||[[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] ==0 ||![[NSFileManager defaultManager] fileExistsAtPath:path]){
        [alert setMessageText:@"路径为空或文件不存在!"];
    }else if ([db createCandleTable:name]) {//建表
        //载入文件
        BOOL loadSucc;
        loadSucc = [self loadCandlesInFile:path withType:type];
        if(!loadSucc){
            [db dropCandleSheet:name];
            [alert setMessageText:@"加载失败!"];
        }else{
            for (int i = 0; i < candles.count; i++) {
                [db insertCandle:[candles objectAtIndex:i] inTable:name];
            }
            //插入记录到symbol表
            Symbol * s= [[Symbol alloc] init];
            s.name = name;
            s.count = (int)candles.count;
            s.importDate = [dateFormatter stringFromDate:[NSDate date]];
            Candle *cStart = [candles objectAtIndex:0];
            Candle *cEnd = [candles lastObject];
            s.dateSpan = [NSString stringWithFormat:@"%@ - %@",[dateFormatter stringFromDate:cStart.date],[dateFormatter stringFromDate:cEnd.date]];
            s.sourceType = type;
            [db insertSymbol:s];
            [s release];
            [alert setMessageText:@"数据导入成功!"];
        }
    }else {
        [alert setMessageText:@"该数据已存在!"];
    }
    [dateFormatter release];
    [alert runModal];
    [alert release];
}


-(void)dealloc{
    [candles release];
}
@end
