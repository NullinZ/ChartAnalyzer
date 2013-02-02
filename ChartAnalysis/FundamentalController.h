//
//  FundamentalController.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-16.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AnalysisEngine.h"
#define NEWS 1
#define DATA 0
@interface FundamentalController : NSViewController<NSTableViewDataSource>
{
    int dataType;
    NSDateFormatter *format;
    
}
@property (nonatomic,retain) IBOutlet NSTabView *tabView;
@property (nonatomic,retain) IBOutlet NSProgressIndicator *pgiLoad;
@property (nonatomic,retain) IBOutlet NSDatePicker *dprStart;
@property (nonatomic,retain) IBOutlet NSDatePicker *dprEnd;
@property (nonatomic,retain) IBOutlet NSTextField *txfNation;
@property (nonatomic,retain) IBOutlet NSTextField *txfKeywords;
@property (nonatomic,retain) IBOutlet NSTableView *tbvData;
@property (nonatomic,retain) IBOutlet NSTableView *tbvAnaData;
-(IBAction)query:(id)sender;
-(IBAction)changeType:(id)sender;
-(IBAction)toAnalysis:(id)sender;
@end
