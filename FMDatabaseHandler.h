//
//  FMDatabaseHandler.h
//  GoogleMap
//
//  Created by huangjy on 11-6-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

//数据库名称
#define DATABASE_NAME @"Data.db"

//查询SQLite系统表
#define DATABASE_SYS_TABLE_QUERY @"select count(*) from sqlite_master where type='table' and name=? "

//查询最后插入数据ID
#define DATABASE_LAST_INSERT_ROWID @"select last_insert_rowid()"

@interface FMDatabaseHandler : NSObject

+ (id)shareHandler;

//判读表是否存在
- (BOOL)tableIsExists:(NSString *)tableName;

//创建表
- (BOOL)create:(NSString *)sql;

//删除表
- (BOOL)drop:(NSString *)sql;

//查询数据
- (NSMutableArray *)query:(NSString *)sql, ...;

//插入数据
- (BOOL)insert:(NSString *)sql, ...;

//更新数据
- (BOOL)update:(NSString *)sql, ...;

//删除数据
- (BOOL)delete:(NSString *)sql, ...;

//删除数据库
- (BOOL)removeDatabase;

//开始事务
- (void)beginTransaction;

//提交事务
- (void)commit;
@end
