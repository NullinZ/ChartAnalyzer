//
//  FileLoader.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-2.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBService.h"

@interface CandleImporter : NSObject
{
    NSMutableArray *candles;
    double max;
    double min;
}
@property (retain,nonatomic) NSFileManager *defaultManager;
@property (retain,nonatomic) NSMutableArray *candles;


/*!
 @method 从文件导入数据 将值存储到candles属性中
 */
-(BOOL)loadCandlesInFile:(NSString *)path withType:(NSString*) type;
-(void)importWithPath:(NSString*)path type:(NSString *)type toDb:(DBService *)db;

@end
