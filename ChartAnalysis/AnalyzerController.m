//
//  TesterController.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-26.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "AnalyzerController.h"
#import "AnalysisEngine.h"
#import "Log.h"
@interface AnalyzerController()
-(void)refreshLog:(NSNotification*)notify;
-(void)analysisCandle;
-(void)analysisCallback:(NSNotification*)notify;
-(void)analysisTrend;
-(void)analysisCurve;
@end
@implementation AnalyzerController

@synthesize chart,txfLog,pgiProgress,matAnalysisType,txvParams;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(refreshLog:) 
                                                     name:NOTIFY_ANALYSIS_LOG object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(analysisCallback:)
                                                     name:NOTIFY_ANALYSIS_CALLBACK
                                                   object:nil];
        first = YES;
    }
    
    return self;
}

-(void)setView:(NSView *)view{
    [super setView:view];
    chart.candleNeedDraw = NO;
}

-(void)analysisCallback:(NSNotification *)notify{
    if (notify&&notify.object) {
        [self addHistogram:notify.object];
    }
    [self.eventSender setEnabled:YES];
    [pgiProgress stopAnimation:self];
    [pgiProgress setHidden:YES];
    [[AnalysisEngine defaultEngine] refreshChartViews];
    [matAnalysisType setEnabled:YES];


}

-(void)addHistogram:(BaseIndicator*)indicator{
    AnalysisEngine *engine = [AnalysisEngine defaultEngine];
    if (indicator) {
        if([indicator isKindOfClass:[Histrogram class]]){
            int cycle = (int)indicator.data.count;
            indicator.identity = (long)chart;
            [engine removeChartWithId:(long)chart];
            [chart setCycle:cycle];
        }
        
        if (![engine.charts containsObject:indicator]) {
            [engine addChart:indicator];
        }

    }
 }

-(void)typeChaged:(id)sender{
    int type = (int)[matAnalysisType selectedRow];
    switch (type) {
        case 0:
            if(!analyzer){
                analyzer = [[Analyzer alloc] init];
            }
            [txvParams setString:[analyzer paramString]];
            break;
        case 1:
            if (!tAnalyzer) {
                tAnalyzer = [[TrendAnalyzer alloc] init];
            }
            [txvParams setString:[tAnalyzer paramString]];
            break;
        case 5:
            if (!cAnalyzer) {
                cAnalyzer = [[CurveAnalyzer alloc] init];
            }       
            [txvParams setString:[cAnalyzer paramString]];
            break;
            
        default:
            break;
    }

}

-(void)analysisByType:(id)sender{
    if (sender) {
        self.eventSender = sender;
        [sender setEnabled:NO];
    }

    [matAnalysisType setEnabled:NO];
    int type = (int)[matAnalysisType selectedRow];
    switch (type) {
        case 0:
            [self analysisCandle];
            break;
        case 1:
            [self analysisTrend];
            break;
        case 5:
            [self analysisCurve];
            break;
            
        default:
            break;
    }
}

-(void)analysisCurve{
    [cAnalyzer analyze:[txvParams string]];
    [cAnalyzer performSelectorInBackground:@selector(curveAnalysis) withObject:nil];
}
-(void)analysisTrend{
    [tAnalyzer analyze:[txvParams string]];
    [tAnalyzer performSelectorInBackground:@selector(trendAnalysis) withObject:nil];
}

-(void)analysisCandle{
    [analyzer analyze:[txvParams string]];

    [pgiProgress setHidden:NO];
    [pgiProgress startAnimation:self];
    [analyzer performSelectorInBackground:@selector(prepareAnalysis) 
                                         withObject:nil];
}

#pragma mark PUBLIC CLASS METHODS

+ (AnalyzerController *)sharedInstance
{
    static AnalyzerController	*sharedInstance = nil;
    
    if (sharedInstance == nil)
    {
        sharedInstance = [[self alloc] init];
        [NSBundle loadNibNamed:@"AnalyzerController.nib" owner:sharedInstance];
    }
    
    return sharedInstance;
}

-(void)refreshLog:(NSNotification *)notify{
    if ( notify&&notify.object) {
        NSAttributedString * as = [[NSAttributedString alloc] initWithString:notify.object];
        NSTextStorage *storage = [txfLog textStorage];
        [storage performSelectorOnMainThread:@selector(beginEditing) withObject:nil waitUntilDone:YES];
        [storage performSelectorOnMainThread:@selector(appendAttributedString:) withObject:as waitUntilDone:YES];
        [storage performSelectorOnMainThread:@selector(endEditing) withObject:nil waitUntilDone:YES];
        [as release];
        NSRange range;
        
        range = NSMakeRange ([[txfLog string] length], 0);
        [txfLog scrollRangeToVisible: range];
    }	
}

-(void)showPanel{
    [super showPanel];
    if (first) {
        [self typeChaged:nil];
        [self analysisByType:nil];
        first = NO;
    }
    [self.eventSender setEnabled:YES];
}
-(void)hidePanel{
    [super hidePanel];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ANALYSIS_LOG object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_ANALYSIS_CALLBACK object:nil];
}

-(void)dealloc{
    [tAnalyzer release];
    [analyzer release];
    [super dealloc];
}
@end
