//
//  News.h
//  FinacialAlarm
//
//  Created by Sheng Zhao on 12-3-28.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FinanceNews:NSObject{
    NSDate * date;
    NSNumber * _id;
    NSString * title;
    NSString * content;
}

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * _id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * content;

@end
