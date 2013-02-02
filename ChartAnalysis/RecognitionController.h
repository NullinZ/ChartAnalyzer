//
//  RecognitionController.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-12-30.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PanelController.h"
#import "PatternAnalyzer.h"
#import "VE.h"
#import "Trend.h"

@interface RecognitionController : PanelController <NSTableViewDelegate,NSTableViewDataSource>{
    PatternAnalyzer *prAnalysis;
    NSDateFormatter *format;
    NSMutableArray *codeArray;
    VE* _ve;
}

@property (nonatomic,retain) IBOutlet NSMutableArray *codeArray;
@property (nonatomic,retain) IBOutlet NSTextView *txvPattern;
@property (nonatomic,retain) IBOutlet NSTextField *txvName;
@property (nonatomic,retain) IBOutlet NSTableView *resultTableView;
@property (nonatomic,retain) IBOutlet NSTableView *codeTableView;
@property (nonatomic,retain) IBOutlet NSTextView *logView;
@property (nonatomic,retain) VE *ve;
-(IBAction)check:(id)sender;
-(IBAction)analysis:(id)sender;
-(IBAction)savePattern:(id)sender;
-(IBAction)deletePattern:(id)sender;
+ (RecognitionController *)sharedInstance;

@end
