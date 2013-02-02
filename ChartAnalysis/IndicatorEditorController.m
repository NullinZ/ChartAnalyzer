//
//  IndicatorEditor.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-15.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "IndicatorEditorController.h"

@implementation IndicatorEditorController
@synthesize panel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}
-(void)showPanel{
    [panel makeKeyAndOrderFront:nil];
}
+ (IndicatorEditorController *)sharedInstance
{
    static IndicatorEditorController	*sharedInstance = nil;
    
    if (sharedInstance == nil)
    {
        sharedInstance = [[self alloc] init];
        [NSBundle loadNibNamed:@"IndicatorEditorController.nib" owner:sharedInstance];
    }
    
    return sharedInstance;
}
@end
