//
//  IParamAnalyze.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-11-1.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IParamAnalyze <NSObject>
-(BOOL)analyze:(NSString*)params;
-(NSString*)paramString;
@end
