//
//  ChartController.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-5.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "ChartController.h"
#import "ChartView.h"
#import "ConstDef.h"
#import "IndicatorEditorController.h"
@interface ChartController(Private)
-(void)loadCandleInThread:(id)sender;
-(void)loadCandleInThreadSucc:(id)sender;
-(void)moveChartTo:(NSNotification *)notify;
@end
@implementation ChartController
@synthesize chartView,txfStateLow,txfStateDate,txfStateHigh,txfStateOpen,txfStateClose,txfStateHeight,txfStateVolume,txfStateRectHeight,sdrCycle,sdrRange,txfCycle,cbxSymbols,dprFrom,dprTo,txfVerScale,btnFilter,sprFactor,txfFactor,pnlIndicatorAdd,pnlIndicators,pnlResult,pnlTester,pgiLoad,tabView;
@synthesize curCandle;
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moveChartTo:)
                                                     name:NOTIFY_MOVE_CHART_TO
                                                   object:nil];

        
    }        
    return self;
}

-(void)setView:(NSView *)view{
    [super setView:view];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setDay:-100];
    dprTo.dateValue = date;
    dprFrom.dateValue = [calendar dateByAddingComponents:comp toDate:date options:0];
    [comp release];
    [cbxSymbols setDataSource:self];
    [cbxSymbols selectItemAtIndex:0];
//    [self showRecognitionPattern:nil];
}

-(void)setCurCandle:(Candle *)candle{
    if (!candle) {
        return;
    }
    curCandle = candle;
    [txfStateLow setTitleWithMnemonic:[NSString stringWithFormat:@"%f",candle.low]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm EE"];
    [txfStateDate setTitleWithMnemonic:[formatter stringFromDate:candle.date]];
    [formatter release];
    [txfStateHigh setTitleWithMnemonic:[NSString stringWithFormat:@"%f",candle.high]];
    [txfStateOpen setTitleWithMnemonic:[NSString stringWithFormat:@"%f",candle.open]];
    [txfStateClose setTitleWithMnemonic:[NSString stringWithFormat:@"%f",candle.close]];
    [txfStateHeight setTitleWithMnemonic:[NSString stringWithFormat:@"%f",candle.high-candle.low]];
    [txfStateVolume setTitleWithMnemonic:[NSString stringWithFormat:@"%d",candle.volume]];
    [txfStateRectHeight setTitleWithMnemonic:[NSString stringWithFormat:@"%f",ABS(candle.open - candle.close)]];
}

#pragma mark -
#pragma mark data loading

-(void)loadCandleSource:(id)sender{
    NSString *symbol = [cbxSymbols stringValue];
    if (symbol == nil || [symbol isEqualToString:@""]) {
        NSAlert * alert= [[NSAlert alloc] init];
        [alert setMessageText:@"请先载入元数据再进行筛选！"];
        [alert runModal];
        [alert release];
        return;
    }
    [sender setEnabled:NO];
    [pgiLoad setHidden:NO];
    [pgiLoad startAnimation:self];
    [self performSelectorInBackground:@selector(loadCandleInThread:) withObject:sender];
}

-(void)loadCandleInThread:(id)sender{
    NSAutoreleasePool *pool =[[NSAutoreleasePool alloc] init];
    NSString *symbol = [cbxSymbols stringValue];
    NSDate *date1 = nil;
    NSDate *date2 = nil;
    if (sender == btnFilter) {
        date1 = [dprFrom dateValue];
        date2 = [dprTo dateValue];
    }
    [[AnalysisEngine defaultEngine] loadCandles:symbol start:date1 end:date2];
    [self performSelectorOnMainThread:@selector(loadCandleInThreadSucc:) withObject:sender waitUntilDone:YES];
    [AnalysisEngine defaultEngine].curSymbol = symbol;
    [pool release];
}

-(void)loadCandleInThreadSucc:(id)sender{
    sdrRange.maxValue = [AnalysisEngine defaultEngine].candles.count - DEFAULT_CYCLE / 2;
    sdrRange.intValue = (int)[AnalysisEngine defaultEngine].candles.count;
    chartView.reload = YES;
    [self resetCycle:nil];
    [sender setEnabled:YES];
    [pgiLoad stopAnimation:self];    
}

-(void)anchor:(id)sender{
    NSArray *candles = [AnalysisEngine defaultEngine].candles;
    if (candles == nil || !candles.count) {
        NSAlert * alert= [[NSAlert alloc] init];
        [alert setMessageText:@"请先载入元数据再进行筛选！"];
        [alert runModal];
        [alert release];
        return;
    }      
    
    if (chartView.isAnchorShow) {
        Candle *c = [candles objectAtIndex:chartView.rangeEnd];
        if ([c.date isLessThanOrEqualTo:dprFrom.dateValue]) {
            NSAlert * alert= [[NSAlert alloc] init];
            [alert setMessageText:[NSString stringWithFormat:@"结束时间必须大于开始时间%@",c.date]];
            [alert runModal];
            [alert release];
            return;
        }
        chartView.isAnchorShow = NO;
        dprTo.dateValue = c.date;
        [dprFrom setEnabled:YES];
    }else{
        Candle *c = [candles objectAtIndex:chartView.rangeStart];
        chartView.isAnchorShow = YES;
        dprFrom.dateValue = c.date;
        [dprFrom setEnabled:NO];
    }
}

#pragma mark -
#pragma mark panel show

-(void)showResult:(id)sender{
    [sender setEnabled:NO];
    if (tc == nil) {
        tc = [TesterController sharedInstance];
    }
    [tc showPanel];
}
-(void)showRecognitionPattern:(id)sender{
    [sender setEnabled:NO];
    if (rc == nil) {
        rc = [RecognitionController sharedInstance];
    }
    rc.eventSender = sender;
    [rc showPanel];
}

-(void)showIndicator:(id)sender{
    [pnlIndicators makeKeyAndOrderFront:nil];
}



-(void)testIndicator:(id)sender{
    [sender setEnabled:NO];
    if (ac == nil) {
        ac = [AnalyzerController sharedInstance];
    }
    ac.eventSender = sender;
    [ac showPanel];
}

#pragma mark -
#pragma mark chart operation

-(void)cycleChange:(id)sender{
    int curCycle = sdrCycle.intValue;
    [txfCycle setTitleWithMnemonic:[NSString stringWithFormat:@"%d",curCycle]];
    chartView.pointWidth = chartView.bounds.size.width / curCycle;
}
-(void)moveChartTo:(NSNotification *)notify{
    if (notify == nil) {
        return;
    }
    sdrRange.intValue = [notify.object doubleValue];
    if (sdrRange.intValue > 10) {
        sdrRange.intValue -= 10;
    }
    [self moveChart:sdrRange];
}
-(void)moveChart:(id)sender{
    chartView.rangeStartX = sdrRange.intValue * chartView.pointWidth;
}

-(void)resetCycle:(id)sender{
    [sdrCycle setIntValue:DEFAULT_CYCLE];
    [self cycleChange:sdrCycle];
}

-(void)txfFactorChange:(id)sender{
    NSTextField *txf = sender;
    sprFactor.intValue = txf.doubleValue * 100;
    chartView.factor = txf.doubleValue;
}

-(void)sprFactorChange:(id)sender{
    NSStepper *spr = sender;
    txfFactor.doubleValue = spr.intValue/100.0;
    chartView.factor = txfFactor.doubleValue;
}

-(void)autoFit:(id)sender{
    NSButton * ckb = sender;
    chartView.autoFit = [ckb intValue];
    sprFactor.intValue = 100;
    txfFactor.intValue = 1;
    chartView.factor = 1;
}

#pragma mark -
#pragma mark combobox datasource

-(NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox{
    return [AnalysisEngine defaultEngine].symbols.count;
}
-(id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index{
    if(index>=0){
        Symbol *s = [[AnalysisEngine defaultEngine].symbols objectAtIndex:index];
        return s.name;
    }else{
        return @"";
    }
}

-(NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string{
    for (int i = 0; i < [AnalysisEngine defaultEngine].symbols.count; i++) {
        Symbol *s = [[AnalysisEngine defaultEngine].symbols objectAtIndex:i];
        if ([s.name isEqualToString:string]) {
            return i;
        }
    }
    return 0;
}

-(void)dealloc{
    [pgiLoad release];
    [cbxSymbols release];
    
    [txfStateDate release];
    [txfStateVolume release];
    [txfStateOpen release];
    [txfStateHigh release];
    [txfStateLow release];
    [txfStateClose release];
    [txfStateHeight release];
    [txfStateRectHeight release];
    
    [txfCycle release];
    [txfVerScale release];
    
    [dprFrom release];
    [dprTo release];
    [btnFilter release];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_MOVE_CHART_TO object:nil];
    
    [sdrCycle release];
    [sdrRange release];
    [chartView release];
    [super dealloc];
}
@end
