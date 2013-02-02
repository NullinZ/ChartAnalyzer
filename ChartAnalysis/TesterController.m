//
//  TesterController.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-11-1.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "TesterController.h"

@implementation TesterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
+ (TesterController *)sharedInstance
{
    static TesterController	*sharedInstance = nil;
    
    if (sharedInstance == nil)
    {
        sharedInstance = [[self alloc] init];
        [NSBundle loadNibNamed:@"TesterController.nib" owner:sharedInstance];
    }
    
    return sharedInstance;
}
@end
