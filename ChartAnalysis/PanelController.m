//
//  PanelController.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-27.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "PanelController.h"

@implementation PanelController
@synthesize panel,eventSender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


#pragma mark PUBLIC INSTANCE METHODS

// Show the panel, starting the text at the top with the animation going
- (void)showPanel
{
    if (![panel isVisible]) {
        [panel makeKeyAndOrderFront:nil];
    }
    // Make it the key window so it can watch for keystrokes
}

// Stop scrolling and hide the panel. (We stop the scrolling only to avoid
// wasting the processor, since if we kept scrolling it wouldn’t be visible anyway.)
//
- (void)hidePanel
{
    
    [panel orderOut: nil];
}

@end
