//
//  FMDatabaseHandler.m
//  GoogleMap
//
//  Created by huangjy on 11-6-21.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FMDatabaseHandler.h"
static FMDatabaseHandler *dbHandler = nil;

@interface FMDatabaseHandler()

@property (nonatomic, retain) FMDatabase *database;

@end

@implementation FMDatabaseHandler

@synthesize database = _database;

- (FMDatabaseHandler *)init
{
	self = [super init];
	if(self)
	{
		//paths： ios下Document路径，Document为ios中可读写的文件夹  
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
		NSString *documentDirectory = [paths objectAtIndex:0]; 
		
		//dbPath： 数据库路径，在Document中。  
		NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DATABASE_NAME];
		NSLog(@"%@", dbPath);
		
		self.database = [FMDatabase databaseWithPath:dbPath];
		if(![self.database open])
		{
			NSLog(@"Can not open database");
		}
	}
	return self;
}

- (void) dealloc
{
	[self.database close];
	[_database release];
	
	if(dbHandler)
		[dbHandler release];
	
	[super dealloc];
}

+ (id)shareHandler
{
	@synchronized(self)
	{
		if(dbHandler == nil)
			dbHandler = [[FMDatabaseHandler alloc]init];
	}
	return dbHandler;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) {
		if (dbHandler == nil) {
            dbHandler = [super allocWithZone:zone];
			return dbHandler;
		}
	}
	return nil;
}

- (BOOL)tableIsExists:(NSString *)tableName
{
	BOOL ret = NO;
	
	if(tableName)
	{
		FMResultSet *rs = [self.database executeQuery:DATABASE_SYS_TABLE_QUERY, tableName];
		if([rs next])
		{
			if([rs intForColumnIndex:0])
				ret = YES;
		}
	}
	return ret;
}

- (BOOL)create:(NSString *)sql
{
	BOOL ret = NO;
	if(sql)
	{
		ret = [self.database executeUpdate:sql];
	}
	return ret;
}


- (BOOL)drop:(NSString *)tableName
{ 
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];

	BOOL ret = NO;
	if(sqlstr)
	{
        [self.database closeOpenResultSets];
		ret = [self.database executeUpdate:sqlstr];
	}
	return ret;
}

- (NSMutableArray *)query:(NSString *)sql, ...
{
	NSMutableArray *ret = nil;
	va_list args;
	
	if(sql)
	{
		ret = [[[NSMutableArray alloc]init]autorelease];
		
		va_start(args, sql);
		
		FMResultSet *rs = [self.database executeQuery:sql withArgumentsInArray:nil orVAList:args];
		int col_count = [rs columnCount];
		
		while([rs next])
		{
			NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
			for(int i = 0; i < col_count; i++)
			{
				NSString *col_name = [rs columnNameForIndex:i];
				if([rs stringForColumn:col_name])
					[dictionary setObject:[rs stringForColumn:col_name] forKey:col_name];
				else
					[dictionary setObject:@"" forKey:col_name];
			}
			[ret addObject:dictionary];
			[dictionary release];
		}
        [rs close];
		va_end(args);
	}
	
	return ret;
}

- (BOOL)insert:(NSString *)sql, ...
{
	BOOL ret = NO;
	va_list args;
	if(sql)
	{
		va_start(args, sql);
		ret = [self.database executeUpdate:sql error:nil withArgumentsInArray:nil orVAList:args];
       
		va_end(args);
	}
	return ret;
}

- (BOOL)update:(NSString *)sql, ...
{
	BOOL ret = NO;
	va_list args;
	if(sql)
	{
		va_start(args, sql);
		ret = [self.database executeUpdate:sql error:nil withArgumentsInArray:nil orVAList:args];
		va_end(args);
	}
	return ret;
}

- (BOOL)delete:(NSString *)sql, ...
{
	BOOL ret = NO;
	va_list args;
	if(sql)
	{
		va_start(args, sql);
		ret = [self.database executeUpdate:sql error:nil withArgumentsInArray:nil orVAList:args];
        va_end(args);
	}
	return ret;
	
}

- (BOOL)removeDatabase
{
	BOOL ret = NO;
	
	if(self.database)
	{
		[self.database close];
		//paths： ios下Document路径，Document为ios中可读写的文件夹  
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
		NSString *documentDirectory = [paths objectAtIndex:0]; 
		
		//dbPath： 数据库路径，在Document中。  
		NSString *dbPath = [documentDirectory stringByAppendingPathComponent:DATABASE_NAME];
		
		//删除旧的数据库文件
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if([fileManager fileExistsAtPath:dbPath])
			ret = [fileManager removeItemAtPath:dbPath error:NO];
		
	}
	return ret;
}

- (void)beginTransaction
{
	[self.database beginTransaction];
}

- (void)commit
{
	[self.database commit];
}

@end
