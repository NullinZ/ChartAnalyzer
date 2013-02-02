//
//  ChartController.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-5.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Candle.h"
#import "CandleImporter.h"
#import "DBService.h"
#import "AnalysisEngine.h"
#import "AnalyzerController.h"
#import "TesterController.h"
#import "RecognitionController.h"
@class  ChartView;
@interface ChartController : NSViewController<NSComboBoxDataSource>{
    AnalyzerController *ac;
    TesterController *tc;
    RecognitionController *rc;

}


@property (retain,nonatomic) Candle *curCandle;
/**
 
 View
 
 */
@property (retain,nonatomic) IBOutlet NSComboBox *cbxSymbols;

@property (retain,nonatomic) IBOutlet NSTextField *txfStateDate;
@property (retain,nonatomic) IBOutlet NSTextField *txfStateVolume;
@property (retain,nonatomic) IBOutlet NSTextField *txfStateOpen;
@property (retain,nonatomic) IBOutlet NSTextField *txfStateHigh;
@property (retain,nonatomic) IBOutlet NSTextField *txfStateLow;
@property (retain,nonatomic) IBOutlet NSTextField *txfStateClose;
@property (retain,nonatomic) IBOutlet NSTextField *txfStateHeight;
@property (retain,nonatomic) IBOutlet NSTextField *txfStateRectHeight;

@property (retain,nonatomic) IBOutlet NSTextField *txfCycle;
@property (retain,nonatomic) IBOutlet NSTextField *txfVerScale;

@property (retain,nonatomic) IBOutlet NSButton *btnFilter;
@property (retain,nonatomic) IBOutlet NSDatePicker *dprFrom;
@property (retain,nonatomic) IBOutlet NSDatePicker *dprTo;

@property (retain,nonatomic) IBOutlet NSStepper *sprFactor;
@property (retain,nonatomic) IBOutlet NSTextField *txfFactor;

@property (retain,nonatomic) IBOutlet NSPanel *pnlIndicators;
@property (retain,nonatomic) IBOutlet NSPanel *pnlIndicatorAdd;
@property (retain,nonatomic) IBOutlet NSPanel *pnlTester;
@property (retain,nonatomic) IBOutlet NSPanel *pnlResult;


@property (retain,nonatomic) IBOutlet NSProgressIndicator * pgiLoad;
@property (retain,nonatomic) IBOutlet NSSlider * sdrCycle;
@property (retain,nonatomic) IBOutlet NSSlider * sdrRange;
@property (retain,nonatomic) IBOutlet ChartView *chartView;
@property (retain,nonatomic) IBOutlet NSTabView *tabView;

-(IBAction)showIndicator:(id)sender;
-(IBAction)showRecognitionPattern:(id)sender;
-(IBAction)testIndicator:(id)sender;
-(IBAction)showResult:(id)sender;
-(IBAction)loadCandleSource:(id)sender;
-(IBAction)cycleChange:(id)sender;
-(IBAction)sprFactorChange:(id)sender;
-(IBAction)txfFactorChange:(id)sender;
-(IBAction)resetCycle:(id)sender;
-(IBAction)anchor:(id)sender;
-(IBAction)moveChart:(id)sender;
-(IBAction)autoFit:(id)sender;
-(void)setCurCandle:(Candle *)curCandle;
@end
