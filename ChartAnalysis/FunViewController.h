//
//  CellViewController.h
//  Example
//
//  Created by Aaron Brethorst on 5/3/11.
//  Copyright 2011 Structlab LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChartView.h"
#import "FinanceData.h"
#import "FinanceNews.h"
#import "VE.h"
#import "AnalysisEngine.h"

#define FUN_VIEW_GRID 0
#define FUN_VIEW_LINE 1

@interface FunViewController : NSViewController
{
    AnalysisEngine *engine;
    NSDateFormatter *fmt;
    FinanceData *_data;
    FinanceNews *_news;
    VE *_ve;
    
}
@property(nonatomic,retain) IBOutlet NSView *viewDataContainer;
@property(nonatomic,retain) IBOutlet NSTextView *txvNews;
@property(nonatomic,retain) IBOutlet NSScrollView *sclNews;

@property(nonatomic,retain) IBOutlet NSTextField *txfTitle;
@property(nonatomic,retain) IBOutlet NSTextField *txfDate;
@property(nonatomic,retain) IBOutlet NSTextField *txfPre;
@property(nonatomic,retain) IBOutlet NSTextField *txfFor;
@property(nonatomic,retain) IBOutlet NSTextField *txfAct;
@property(nonatomic,retain) IBOutlet ChartView *chart;
-(void)setData:(FinanceData*)data;
-(void)setNews:(FinanceNews*)data;
-(id)initWithType:(int)type;

@end
