//
//  Indicator.h
//  FinacialAlarm
//
//  Created by Sheng Zhao on 12-3-27.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FinanceData:NSObject{
   NSString * actualValue;
   NSString * content;
   NSDate * date;
   NSString * forecastValue;
   NSNumber * _id;
   NSString * level;
   NSNumber * notime;
   NSString * previousValue;
   NSString * title;
}

@property (nonatomic, retain) NSString * actualValue;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * forecastValue;
@property (nonatomic, retain) NSNumber * _id;
@property (nonatomic, retain) NSString * level;
@property (nonatomic, retain) NSNumber * notime;
@property (nonatomic, retain) NSString * previousValue;
@property (nonatomic, retain) NSString * title;

@end
