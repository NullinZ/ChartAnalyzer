//
//  Utilities.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-3.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "Utilities.h"
const static int MAX = 2048;

@implementation Utilities
+(int)indexOfObject:(NSArray*)arr obj:(id)obj key:(NSString *)key{
    if(arr&&arr.count){
        int low = 0;
        int high = (int)arr.count - 1;
        while(low <= high) {
            int middle = (low + high)/2;
            id ik= [obj valueForKey:key];
            id ak = [[arr objectAtIndex:middle] valueForKey:key];
            if ([ik isKindOfClass:[NSDate class] ]) {
                ik =(id)(int)([ik timeIntervalSince1970] /60);
                ak = (id)(int)([ak timeIntervalSince1970] /60);
            }
            if( ik == ak) {
                return middle;
            }else if(ik < ak) {
                high = middle - 1;
            }else {
                low = middle + 1;
            }
        }
        return -1;
    }else{
        return -1; 
    }
}
+(int)indexOfObject:(NSArray *)arr date:(NSDate *)date{
    if(arr&&arr.count){
//        NSDateComponents;
        int low = 0;
        int high = (int)arr.count - 1;
        while(low <= high) {
            int middle = (low + high)/2;
            NSDate *ak = [[arr objectAtIndex:middle] date];
            if( date.timeIntervalSince1970 == ak.timeIntervalSince1970||high - low <20) {
                if (high != low) {
                    if ([[arr objectAtIndex:low] date].timeIntervalSince1970 < date.timeIntervalSince1970) {
                        for (int i = low; i <= high; i++) {
                            ak = [[arr objectAtIndex:i] date];
                            if (date.timeIntervalSince1970 < ak.timeIntervalSince1970) {
                                return i-1;
                            }
                        }
                    }
                }
                return low;
            }else if(date.timeIntervalSince1970 < ak.timeIntervalSince1970) {
                high = middle - 1;
            }else {
                low = middle + 1;
            }
        }
        return -1;
    }else{
        return -1; 
    }
}

+(double)variance:(NSArray *)array key:(NSString *)key{
    double sum = 0;
    double item;
    double e = [Utilities avg:array key:key];
    for(int i = 0;i < array.count;i++){
        if (key) {
            item = [[[array objectAtIndex:i] valueForKey:key] doubleValue];
        }else{
            item = [[array objectAtIndex:i] doubleValue];
        }
        sum+=pow(item - e, 2);
    }
    return sum/array.count;
}
+(double)standardDeviation:(NSArray *)array key:(NSString *)key{
    return sqrt([self variance:array key:key]);
}
+(double)avg:(NSArray *)array key:(NSString *)key{
    double sum = 0;
    id o;
    for(int i = 0;i < array.count;i++){
        if (key) {
            o = [[array objectAtIndex:i] valueForKey:key];
        }else{
            o = [array objectAtIndex:i];
        }
        sum+= [o doubleValue];
    }
    return sum / array.count;
}
@end
