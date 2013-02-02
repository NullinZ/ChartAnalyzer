//
//  FinanceDataLoader.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-17.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "DBService.h"
@interface FinanceDataImporter : NSObject<ASIHTTPRequestDelegate>{
    NSDateFormatter *formatter;
    NSDateFormatter *date_format_str;
    NSDateFormatter *datetime_format_str;

}
-(void)loadDataByDate:(NSDate *)date inDB:(DBService*)db;
-(void)loadDataFrom:(NSDate *)start to:(NSDate *)end inDB:(DBService*)db;
-(void)loadNewsByDate:(NSDate *)date inDB:(DBService*)db;
-(void)loadNewsFrom:(NSDate *)start to:(NSDate *)end inDB:(DBService*)db;
@end
