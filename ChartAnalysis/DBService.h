//
//  DBService.h
//  FinacialSSI
//
//  Created by Sheng Zhao on 12-7-20.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseHandler.h"
#import "Candle.h"
#import "Symbol.h"
#import "FinanceNews.h"
#import "FinanceData.h"
@interface DBService : NSObject
@property (strong,nonatomic)FMDatabaseHandler* mDatabaseHandler;
-(id)init;
-(void)initialize;
/**
    蜡烛图表
 */
-(BOOL)createCandleTable:(NSString*)table;
-(void)insertCandle:(Candle*)candle inTable:(NSString *) symbol;
-(NSMutableArray*)getCandlesBySymbol:(NSString *)symbol;
-(NSMutableArray*)getCandlesWithSymbol:(NSString *)symbol start:(NSDate*)date1 end:(NSDate *)date2;
-(void)deleteAllCandle;
-(void)dropCandleSheet:(NSString *)symbol;
/**
 代码
 */
-(void)insertCode:(NSDictionary *)code;
-(void)deleteCode:(NSString *)name;
-(NSArray *)getAllCode;

/**
    基本面相关表
 */
-(BOOL)createFundamentalTables;
-(BOOL)insertNews:(FinanceNews*)news;
-(NSDate *)lastNewsDate;
-(NSDate *)lastDataDate;
-(BOOL)insertData:(FinanceData*)financeData;

-(void)getNewsWithStart:(NSDate *)date1 end:(NSDate *)date2 nation:(NSString*)nation key:(NSString*)key inArr:(NSMutableArray*)retArr;
-(void)getDataWithStart:(NSDate *)date1 end:(NSDate *)date2 nation:(NSString*)nation key:(NSString*)key inArr:(NSMutableArray*)retArr;

/**
    导入蜡烛图记录表
 */
-(void)initSymbolSheet;
-(void)dropSymbolSheet;
-(void)insertSymbol:(Symbol*)symbol;
-(NSArray*)getAllSymbols;
-(void)deleteAllSymbols;
-(void)deleteSymbolByName:(NSString*)name;
-(void)zeroingSymbols;
-(void)deleteNewsWithStart:(NSDate *)date1 end:(NSDate *)date2;
-(void)deleteDataWithStart:(NSDate *)date1 end:(NSDate *)date2;
@end
