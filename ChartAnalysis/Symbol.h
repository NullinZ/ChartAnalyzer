//
//  Symbol.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-4.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstDef.h"
@interface Symbol : NSObject
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *importDate;
@property (nonatomic,retain) NSString *dateSpan;
@property (nonatomic,retain) NSString *sourceType;
@property (nonatomic) int count;
@property (nonatomic) int loadCount;

@end
