//
//  Utilities.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-3.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
+(int)indexOfObject:(NSArray*)arr obj:(id)obj key:(NSString *)key;
+(int)indexOfObject:(NSArray*)arr date:(NSDate*)date;
+(double)variance:(NSArray *)array key:(NSString *)key;
+(double)standardDeviation:(NSArray *)array key:(NSString *)key;
+(double)avg:(NSArray *)array key:(NSString *)key;

@end
