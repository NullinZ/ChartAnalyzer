//
//  IndicatorEditor.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-15.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IndicatorEditorController : NSViewController
@property (nonatomic,retain) IBOutlet NSPanel *panel;

+ (IndicatorEditorController *)sharedInstance;
- (void)showPanel;
@end
