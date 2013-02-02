//
//  Log.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-19.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Log : NSObject{
    
}

+(void)report:(NSString *)format,...;
+(NSString*)report;
+(void)releaseLog;
@end
