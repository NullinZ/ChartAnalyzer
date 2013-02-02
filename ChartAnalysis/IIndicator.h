//
//  IIndicator.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-12.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IIndicator <NSObject>

@required
-(void)calcIndicatorWithNums:(NSArray*)numbers;
@optional

@end
