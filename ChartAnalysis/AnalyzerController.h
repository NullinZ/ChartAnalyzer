//
//  TesterController.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-26.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChartView.h"
#import "BaseIndicator.h"
#import "PanelController.h"
#import "Analyzer.h"
#import "TrendAnalyzer.h"
#import "CurveAnalyzer.h"
@interface AnalyzerController : PanelController{
    Analyzer *analyzer;
    TrendAnalyzer *tAnalyzer;
    CurveAnalyzer *cAnalyzer;
    BOOL first;
}

@property (nonatomic,retain) IBOutlet ChartView *chart;
@property (nonatomic,retain) IBOutlet NSTextView *txfLog;
@property (nonatomic,retain) IBOutlet NSTextView *txvParams;
@property (nonatomic,retain) IBOutlet NSMatrix *matAnalysisType;
@property (nonatomic,retain) IBOutlet NSProgressIndicator *pgiProgress;
-(void)addHistogram:(BaseIndicator*)indicator;

#pragma mark PUBLIC CLASS METHODS
+ (AnalyzerController *)sharedInstance;

-(IBAction)typeChaged:(id)sender;
-(IBAction)analysisByType:(id)sender;
@end
