//
//  DBService.m
//  FinacialSSI
//
//  Created by Sheng Zhao on 12-7-20.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "DBService.h"
#import "ConstDef.h"
@interface DBService(Parser)
-(Candle*)candleFromDic:(NSDictionary*)dic;
-(FinanceData *)financeDataFromDic:(NSDictionary *)dic;
-(FinanceNews *)financeNewsFromDic:(NSDictionary *)dic;
@end
@implementation DBService
@synthesize mDatabaseHandler;


-(id)init{
    self = [super init];
    if (self) {
        mDatabaseHandler = [FMDatabaseHandler shareHandler];
    }
    return self;
}
-(void)initialize{
//    if ([mDatabaseHandler tableIsExists:@"ssi"]) {
//        [mDatabaseHandler drop:@"ssi"];
//    }
//    if ([mDatabaseHandler tableIsExists:@"html"]) {
//        [mDatabaseHandler drop:@"html"];
//    }
//    [mDatabaseHandler create:@"create table ssi(id integer primary key autoincrement,urlId integer,date varchar(40),time varchar(40),name varchar(40),price double, ssi double,sign varchar(40),remarks varchar(1000));"];
//    [mDatabaseHandler create:@"create table html(id integer primary key autoincrement,urlId integer,html text);"];

}
/*!
 Symbol 操作
 */
#pragma mark -
#pragma mark code
-(void)initCodeSheet{
    if ([mDatabaseHandler tableIsExists:TABLE_SYMBOLS]) {
        return;
    }
    [mDatabaseHandler create:@"create table code(id integer primary key autoincrement,name varchar(20),code varchar(2000));"];
    
}

-(void)insertCode:(NSDictionary *)code{
    if (code) {
        BOOL res = [mDatabaseHandler insert:@"INSERT INTO code(name,code) VALUES(?,?)",[code objectForKey:@"name"],[code objectForKey:@"code"]];
        NSLog(@"insert code %d",res);
    }
}

-(void)deleteCode:(NSString *)name{
    if([mDatabaseHandler tableIsExists:TABLE_CODE] && name){
        [mDatabaseHandler delete:[NSString stringWithFormat:@"delete from %@ where name = ?",TABLE_CODE],name];
    }
}

-(NSArray *)getAllCode{
    NSMutableArray *code = [[[NSMutableArray alloc] init] autorelease]; 
    NSMutableArray *result =[mDatabaseHandler query:@"select * from code order by id desc"];
    for (int i = 0; i < [result count]; i++) {
        NSDictionary *dicCode = [result objectAtIndex:i];
        [code addObject:dicCode];
    }
    return code;
}

/*!
    Symbol 操作
 */
#pragma mark -
#pragma mark symbol
-(void)initSymbolSheet{
    if ([mDatabaseHandler tableIsExists:TABLE_SYMBOLS]) {
        return;
    }
    [mDatabaseHandler create:@"create table symbols(id integer primary key autoincrement,name varchar(20),import_date varchar(20),count integer, date_span varchar(40),load_count integer);"];

}

-(void)insertSymbol:(Symbol *)symbol{
    if (symbol) {
        BOOL res = [mDatabaseHandler insert:@"INSERT INTO symbols(name,import_date,count,date_span,load_count,source_type) VALUES(?,?,?,?,0,?)",symbol.name,symbol.importDate,[NSNumber numberWithInt:symbol.count],symbol.dateSpan, symbol.sourceType];
        NSLog(@"insert symbol %d",res);
    }
}

-(void)dropCandleSheet:(NSString *)symbol{
    if ([mDatabaseHandler tableIsExists:symbol]) {
        [mDatabaseHandler drop:symbol];
    }
}
-(void)dropSymbolSheet{
    if ([mDatabaseHandler tableIsExists:TABLE_SYMBOLS]) {
        [mDatabaseHandler drop:TABLE_SYMBOLS];
    }
}

-(NSArray *)getAllSymbols{
    NSMutableArray *symbols = [[[NSMutableArray alloc] init] autorelease]; 
    NSMutableArray *result =[mDatabaseHandler query:@"select * from symbols order by load_count,name desc"];
    for (int i = 0; i < [result count]; i++) {
        Symbol *s = [[Symbol alloc] init];
        NSDictionary *dicS = [result objectAtIndex:i];
        s.name = [dicS objectForKey:@"name"];
        s.importDate = [dicS objectForKey:@"import_date"];
        s.dateSpan = [dicS objectForKey:@"date_span"];
        s.count = [[dicS objectForKey:@"count"] intValue];
        s.loadCount = [[dicS objectForKey:@"load_count"] intValue];
        s.sourceType = [dicS objectForKey:@"source_type"];
        [symbols addObject:s];
        [s release];
    }
    return symbols;
}

-(void)deleteAllSymbols{
    if ([mDatabaseHandler tableIsExists:TABLE_SYMBOLS]) {
        [mDatabaseHandler delete:@"delete * from ?",TABLE_SYMBOLS];
    }

}

-(void)deleteSymbolByName:(NSString *)name{
    if ([mDatabaseHandler tableIsExists:TABLE_SYMBOLS] && name) {
        [mDatabaseHandler delete:@"delete from symbols where name = ?",name];
    }
}

-(void)zeroingSymbols{
    if ([mDatabaseHandler tableIsExists:TABLE_SYMBOLS]) {
        [mDatabaseHandler update:[NSString stringWithFormat:@"update %@ set load_count = 0;",TABLE_SYMBOLS]];
    }
}
#pragma mark -
#pragma mark fundamental
-(BOOL)createFundamentalTables{
    if (![mDatabaseHandler tableIsExists:TABLE_NEWS]) {
        [mDatabaseHandler create:[NSString stringWithFormat:@"create table %@(id integer primary key autoincrement,date date,title varchar(100),content varchar(800));",TABLE_NEWS]];
    }
    if (![mDatabaseHandler tableIsExists:TABLE_DATA]) {
        [mDatabaseHandler create:[NSString stringWithFormat:@"create table %@(id integer primary key autoincrement,date date,title varchar(100),actualValue varchar(20),forecastValue varchar(20),previousValue varchar(20),level varchar(10),content varchar(800));",TABLE_DATA]];
    }
    return YES;
}

-(BOOL)insertData:(FinanceData *)financeData{
    if (!financeData) {
        NSLog(@"financeData in insertData is nil");
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (date,title,actualValue,forecastValue,previousValue,level,content) VALUES(?,?,?,?,?,?,?)",TABLE_DATA];
    return [mDatabaseHandler insert:sql,financeData.date,financeData.title,financeData.actualValue,financeData.forecastValue,financeData.previousValue,financeData.level,financeData.content];
}

-(BOOL)insertNews:(FinanceNews *)news{
    if (!news) {
        NSLog(@"financenews in insertNews is nil");
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (date,title,content) VALUES(?,?,?)",TABLE_NEWS];
    return [mDatabaseHandler insert:sql,news.date,news.title,news.content];
}

-(NSDate *)lastNewsDate{
    NSString *sql = [NSString stringWithFormat:@"select date from %@ order by date desc limit 0,1",TABLE_NEWS];
    NSArray *res = [mDatabaseHandler query:sql];
    if (res && res.count) {
        NSDictionary *n = [res objectAtIndex:0];
        NSDate * date =[NSDate dateWithTimeIntervalSince1970: [[n objectForKey:@"date"] longLongValue]];
        return date;
    }
    return nil;
}

-(NSDate *)lastDataDate{
    NSString *sql = [NSString stringWithFormat:@"select date from %@ order by date desc limit 0,1",TABLE_DATA];
    NSArray *res = [mDatabaseHandler query:sql];
    if (res && res.count) {
        NSDictionary *n = [res objectAtIndex:0];
        NSDate * date =[NSDate dateWithTimeIntervalSince1970: [[n objectForKey:@"date"] longLongValue]];
        return date;
    }
    return nil;
}

-(void)deleteDataWithStart:(NSDate *)date1 end:(NSDate *)date2{
    if ([mDatabaseHandler tableIsExists:TABLE_DATA] && date1 && date2) {
        [mDatabaseHandler delete:[NSString stringWithFormat:@"delete from %@ where (date >= ? and date <= ?)",TABLE_DATA],date1,date2];
    }
}

-(void)deleteNewsWithStart:(NSDate *)date1 end:(NSDate *)date2{
    if ([mDatabaseHandler tableIsExists:TABLE_NEWS] && date1 && date2) {
        [mDatabaseHandler delete:[NSString stringWithFormat:@"delete from %@ where (date >= ? and date <= ?)",TABLE_NEWS],date1,date2];
    }
}

-(void)getNewsWithStart:(NSDate *)date1 end:(NSDate *)date2 nation:(NSString*)nation key:(NSString*)key inArr:(NSMutableArray*)retArr{
    NSMutableArray* canDics = nil;
    if ((date1 != nil && date2 != nil)&&(nation!=nil&&[nation length])&&(key!=nil&&[key length])) {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where (date >= ? and date <= ?) and title like'%%%@%%' and  title like'%%%@%%' order by date desc;",TABLE_NEWS,nation,key];
        canDics = [mDatabaseHandler query:sql,date1,date2];
        
    }else if((date1 != nil && date2 != nil)&&(nation!=nil&&[nation length])){
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where (date >= ? and date <= ?) and title like'%%%@%%' order by date desc;",TABLE_NEWS,nation];
        canDics = [mDatabaseHandler query:sql,date1,date2];
    }else if((date1 != nil && date2 != nil)&&(key!=nil&&[key length])){
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where (date >= ? and date <= ?) and title like'%%%@%%' order by date desc;",TABLE_NEWS,key];
        canDics = [mDatabaseHandler query:sql,date1,date2];
    }else if((date1 != nil && date2 != nil)){
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where date >= ? and date <= ? order by date desc;",TABLE_NEWS];
        canDics = [mDatabaseHandler query:sql,date1,date2];
    }else{
        NSString *sql = [NSString stringWithFormat:@"select * from %@ order by date desc;",TABLE_NEWS];
        canDics = [mDatabaseHandler query:sql];
    }
    for (int i = 0; i < canDics.count; i++) {
        NSDictionary *cd = [canDics objectAtIndex:i];
        FinanceNews *c = [self financeNewsFromDic:cd];
        [retArr addObject:c];
    }
}
-(void)getDataWithStart:(NSDate *)date1 end:(NSDate *)date2 nation:(NSString*)nation key:(NSString*)key inArr:(NSMutableArray*)retArr{
    NSMutableArray* canDics = nil;
    if ((date1 != nil && date2 != nil)&&(nation!=nil&&[nation length])&&(key!=nil&&[key length])) {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where (date >= ? and date <= ?) and title like'%%%@%%' and  title like'%%%@%%' order by date desc;",TABLE_DATA,nation,key];
        canDics = [mDatabaseHandler query:sql,date1,date2];
        
    }else if((date1 != nil && date2 != nil)&&(nation!=nil&&[nation length])){
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where (date >= ? and date <= ?) and title like '%%%@%%' order by date desc;",TABLE_DATA,nation];
        canDics = [mDatabaseHandler query:sql,date1,date2];
    }else if((date1 != nil && date2 != nil)&&(key!=nil&&[key length])){
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where (date >= ? and date <= ?) and title like '%%%@%%' order by date desc;",TABLE_DATA,key];
        canDics = [mDatabaseHandler query:sql,date1,date2];
    }else if((date1 != nil && date2 != nil)){
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where (date >= ? and date <= ?) order by date desc;",TABLE_DATA];
        canDics = [mDatabaseHandler query:sql,date1,date2];
    }else{
        NSString *sql = [NSString stringWithFormat:@"select * from %@ order by date desc;",TABLE_DATA];
        canDics = [mDatabaseHandler query:sql];
    }

    for (int i = 0; i < canDics.count; i++) {
        NSDictionary *cd = [canDics objectAtIndex:i];
        FinanceData *c = [self financeDataFromDic:cd];
        [retArr addObject:c];
    }
}


#pragma mark -
#pragma mark candle

-(BOOL)createCandleTable:(NSString *)table{
    if(!table){
        return NO;
    }
    if ([mDatabaseHandler tableIsExists:table]) {
        return NO;
    }
    [mDatabaseHandler create:[NSString stringWithFormat:@"create table %@(id integer primary key autoincrement,date date,open double,high double,low double,close double,volume integer);",table]];
    return YES;
}
/*!
 Candle操作
 */
-(void)insertCandle:(Candle *)candle inTable:(NSString *)symbol{
    if (candle) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (date,open,high,low,close,volume) VALUES(?,?,?,?,?,?)",symbol];
        [mDatabaseHandler insert:sql,candle.date,[NSNumber numberWithDouble:candle.open],[NSNumber numberWithDouble:candle.high],[NSNumber numberWithDouble:candle.low],[NSNumber numberWithDouble:candle.close],[NSNumber numberWithInt:candle.volume]];
        
    }
}
-(void)deleteAllCandle{
}
-(NSMutableArray*)getCandlesBySymbol:(NSString *)symbol{
    if (symbol) {
        NSMutableArray* canDics = [mDatabaseHandler query:[NSString stringWithFormat:@"select * from %@",symbol]];
        NSMutableArray* candles = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 0; i < canDics.count; i++) {
                        NSDictionary *cd = [canDics objectAtIndex:i];
            Candle *c = [self candleFromDic:cd];
            [candles addObject:c];
        }
        [mDatabaseHandler update:[NSString stringWithFormat:@"update %@ set load_count = load_count+1 where name = ?",TABLE_SYMBOLS],symbol];
        return candles;
    }else{
        return nil;
    }
}
-(NSMutableArray *)getCandlesWithSymbol:(NSString *)symbol start:(NSDate *)date1 end:(NSDate *)date2{
    if(date1 == nil && date2 == nil){
        NSLog(@"You should use function -(NSMutableArray*)getCandlesBySymbol:(NSString *)symbol instead of this");
        return nil;
    }
    if (symbol) {
        NSMutableArray* canDics = [mDatabaseHandler query:[NSString stringWithFormat:@"select * from %@ where date >= ? and date <= ?;",symbol],date1,date2];
        NSMutableArray* candles = [[[NSMutableArray alloc] init] autorelease];
        for (int i = 0; i < canDics.count; i++) {
            NSDictionary *cd = [canDics objectAtIndex:i];
            Candle *c = [self candleFromDic:cd];
            [candles addObject:c];
        }
         
    //[mDatabaseHandler update:[NSString stringWithFormat:@"update %@ set load_count = load_count+1 where title = ?",TABLE_SYMBOLS],symbol];
        return candles;
    }else{
        return nil;
    }
}
#pragma mark -
#pragma mark parser method
-(Candle *)candleFromDic:(NSDictionary *)dic{
    Candle *c = [[[Candle alloc] init] autorelease];
    long long timeInterval = [[dic objectForKey:@"date"] longLongValue] + HOUR12;
    c.date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    c.open = [[dic objectForKey:@"open"] doubleValue];
    c.high = [[dic objectForKey:@"high"] doubleValue];
    c.low = [[dic objectForKey:@"low"] doubleValue];
    c.close = [[dic objectForKey:@"close"] doubleValue];
    c.volume = [[dic objectForKey:@"volume"] intValue];
    return c;
}

-(FinanceNews *)financeNewsFromDic:(NSDictionary *)dic{
    FinanceNews *c = [[[FinanceNews alloc] init] autorelease];
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"date"] longLongValue]];
    c._id = [dic objectForKey:@"id"];
    c.date = d;
    c.title = [dic objectForKey:@"title"];
    c.content = [dic objectForKey:@"content"];
    return c;
}

-(FinanceData *)financeDataFromDic:(NSDictionary *)dic{
    FinanceData *c = [[[FinanceData alloc] init] autorelease];
    c.date = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"date"] longLongValue]];
    c._id = [dic objectForKey:@"id"];
    c.title = [dic objectForKey:@"title"];
    c.actualValue = [dic objectForKey:@"actualValue"];
    c.forecastValue = [dic objectForKey:@"forecastValue"];
    c.previousValue = [dic objectForKey:@"previousValue"];
    c.level = [dic objectForKey:@"level"];
    c.content = [dic objectForKey:@"content"] ;
    return c;
}
@end
