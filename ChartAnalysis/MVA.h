//
//  MVA.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-12.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IIndicator.h"
#import "BaseIndicator.h"

@interface MVA : BaseIndicator<IIndicator>{
    int _periods;
}
@property (nonatomic) int periods;
-(id)initWithPeroid:(int)num;
-(void)calcIndicatorWithNums:(NSMutableArray *)numbers scale:(double)scale;

@end
