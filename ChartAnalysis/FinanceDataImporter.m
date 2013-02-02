//
//  FinanceDataLoader.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-17.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "FinanceDataImporter.h"
#import "ConstDef.h"
#import "ElementParser.h"
#import "DocumentRoot.h"
#import "FinanceData.h"
#import "FinanceNews.h"
@interface FinanceDataImporter(Private)
-(NSArray*)processNews:(NSString *)html year:(NSString *)year;
-(NSArray*)processMeeting:(NSString *)html year:(NSString *)year;
-(NSArray*)processIndicator:(NSString *)html year:(NSString *)year;
-(NSString *)requestWithType:(NSString *)type date:(NSString *)date;
@end
@implementation FinanceDataImporter

-(id)init{
    self = [super init];
    if (self) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日HH:mm"];
        date_format_str = [[NSDateFormatter alloc] init];
        [date_format_str setDateFormat:@"yyyy-MM-dd"];
        datetime_format_str = [[NSDateFormatter alloc] init];
        [datetime_format_str setDateFormat:@"yyyy-MM-dd HH:mm"];

    }
    return self;
}

-(void)loadDataByDate:(NSDate *)date inDB:(DBService *)db{
    NSString *dateStr = [date_format_str stringFromDate:date];
    NSString *html = [self requestWithType:FINANCE_DATA date:dateStr];

    NSString *year = [NSString stringWithFormat:@"%d", [[date dateWithCalendarFormat:nil timeZone:nil] yearOfCommonEra]];
    NSArray *indicators = [self processIndicator:html year:year];
    
    for (FinanceData* data in indicators) {
        [db insertData:data];
    }
}

-(void)loadNewsByDate:(NSDate *)date inDB:(DBService *)db{
    
    NSString *dateStr = [date_format_str stringFromDate:date];
    NSString *html = [self requestWithType:FINANCE_NEWS date:dateStr];

    NSString *year = [NSString stringWithFormat:@"%d", [[date dateWithCalendarFormat:nil timeZone:nil] yearOfCommonEra]];
    NSArray *news = [self processNews:html year:year];
    
    for (FinanceNews *data in news) {
        [db insertNews:data];
    }
}

-(void)loadDataFrom:(NSDate *)start to:(NSDate *)end inDB:(DBService *)db{
    NSDate *startDate = [NSDate dateWithTimeInterval:0 sinceDate:start];
    NSDate *endDate = end;
    
    while (endDate.timeIntervalSince1970/DAY_SEC > startDate.timeIntervalSince1970/DAY_SEC) {
        [self loadDataByDate:startDate inDB:db];
        startDate = [startDate dateByAddingTimeInterval:DAY_SEC];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DATA_IMPORT_PROGRESS object:[NSString stringWithFormat:@"正在请求%@指数数据...",[date_format_str stringFromDate:startDate]]];
    }
}

-(void)loadNewsFrom:(NSDate *)start to:(NSDate *)end inDB:(DBService *)db{
    NSDate *startDate = [NSDate dateWithTimeInterval:0 sinceDate:start];
    NSDate *endDate = end;
    
    while (endDate.timeIntervalSince1970/DAY_SEC > startDate.timeIntervalSince1970/DAY_SEC) {
        [self loadNewsByDate:startDate inDB:db];
        startDate = [startDate dateByAddingTimeInterval:DAY_SEC];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DATA_IMPORT_PROGRESS object:[NSString stringWithFormat:@"正在请求%@新闻数据...",[date_format_str stringFromDate:startDate]]];

    }
}

#pragma mark -
#pragma mark process
-(NSArray*)processNews:(NSString *)html year:(NSString *)year{
    //[date dateWithCalendarFormat:nil timeZone:nil] yearOfCommonEra
    
    DocumentRoot* doc = [Element parseHTML:html];
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    NSArray *trs = [doc selectElements:@"tr.record"];
    FinanceNews* i = nil;
    for (int j = 0; j < [trs count]; j++) {
        Element* tr = [trs objectAtIndex:j];
        NSArray* tds = [tr selectElements:@"td"];
        i = [[FinanceNews alloc] init];
        NSMutableString *dateStr = [[NSMutableString alloc] initWithFormat:@"%@年%@", year ,[[tds objectAtIndex:0] contentsText]];
        i.date =  [formatter dateFromString: dateStr];
        [dateStr release];
        i.title = [[[tds objectAtIndex:1] selectElement:@"a"] contentsText];
        if (!i.title) {
            i.title = [[tds objectAtIndex:1] contentsText];
        }
        
        i.content = [[[tds objectAtIndex:1] selectElement:@"div"] contentsText];
        if (!i.content) {
            i.content = i.title;
        }
        [array addObject:i];
        [i release];
    }
    return array;
}
-(NSArray*)processMeeting:(NSString *)html year:(NSString *)year{
    //[date dateWithCalendarFormat:nil timeZone:nil] yearOfCommonEra
    
    DocumentRoot* doc = [Element parseHTML:html];
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    NSArray *trs = [[[doc selectElements:@".listtable"] objectAtIndex:0] selectElements:@"tr"];
    
    FinanceNews* i = nil;
    for (int j = 1; j < [trs count]; j++) {
        Element* tr = [trs objectAtIndex:j];
        NSArray* tds = [tr selectElements:@"td"];
        i = [[FinanceNews alloc] init];
        NSMutableString *dateStr = [[NSMutableString alloc] initWithFormat:@"%@ %@",[[tds objectAtIndex:0] contentsText],[[tds objectAtIndex:1] contentsText]];
        i.date =  [formatter dateFromString: dateStr];
        [dateStr release];
        i.title = [[tds objectAtIndex:3] contentsText];
        i.content = [[tds objectAtIndex:2] contentsText];
        [array addObject:i];
        [i release];
    }
    return array;
}
-(NSArray*)processIndicator:(NSString *)html year:(NSString *)year{
    DocumentRoot* doc = [Element parseHTML:html];
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    NSArray *arr = [doc selectElements:@"table.outside table tr"];
    FinanceData* i = nil;
    NSAutoreleasePool *autoPool = [[NSAutoreleasePool alloc] init];
    for (int j = 0; j < [arr count]; j++) {
        Element* tr = [arr objectAtIndex:j];
        NSArray* tds = [tr selectElements:@"td"];
        if([tds count] == 7){
            i = [[[FinanceData alloc] init] autorelease];
            NSMutableString *dateStr = [[NSMutableString alloc] initWithString:[[tds objectAtIndex:0] contentsText]];
            [dateStr appendString:@" "];
            [dateStr appendString:[[tds objectAtIndex:1] contentsText]];
            i.date =  [datetime_format_str dateFromString: dateStr];
            [dateStr release];
            i.title = [[tds objectAtIndex:2] contentsText];
            i.level = [[tds objectAtIndex:3] contentsText];
            i.previousValue = [[tds objectAtIndex:4] contentsText];
            i.forecastValue = [[tds objectAtIndex:5] contentsText];
            i.actualValue = [[tds objectAtIndex:6] contentsText];
            [array addObject:i];
        }else if([tds count] == 1){
            if (i) {
                i.content = [[tds objectAtIndex:0] contentsText];
            }
        }
    }
    [autoPool release];
    return array;
}

-(NSString *)requestWithType:(NSString *)type date:(NSString *)date{
    ASIFormDataRequest* request = [[[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:DATA_URL]] autorelease];
    [request addRequestHeader:@"Referer" value:BASE_URL];
    [request addPostValue:date forKey:@"date"];
    
    [request addPostValue:type forKey:@"type"];
    [request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];
    [request setDelegate:self];
    [request startSynchronous];
    NSString* html = nil;
    if ([request error]) {
        html = [[[NSString alloc] initWithFormat:@"数据请求失败，请检查网络后重试!\n详细日志：\n%@",[[request error] userInfo]] autorelease];
        NSLog(@"%@",html);
    }else{
        html = [[[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding] autorelease];
    }
    return html;
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    
}
-(void)dealloc{
    [date_format_str release];
    [datetime_format_str release];
    [formatter release];
    [super dealloc];
}
@end
