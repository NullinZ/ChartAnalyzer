//
//  FSAppDelegate.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-9-22.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AnalysisEngine.h"

@interface FSAppDelegate : NSObject <NSApplicationDelegate>{
}
@property (assign) IBOutlet AnalysisEngine *mEngine;
@property (assign) IBOutlet NSWindow *window;
@end
