//
//  CellViewController.m
//  Example
//
//  Created by Aaron Brethorst on 5/3/11.
//  Copyright 2011 Structlab LLC. All rights reserved.
//

#import "FunViewController.h"
#import "Utilities.h"
#import "Analyzer.h"
#import "Trend.h"
@interface FunViewController()
@property(nonatomic,retain) IBOutlet VE *ve;

@end
@implementation FunViewController
@synthesize txfTitle,txfDate,txfAct,txfFor,txfPre,chart,txvNews,viewDataContainer,sclNews,ve=_ve;

- (id)initWithType:(int)type
{
    NSString *nib = nil;
    if (type == FUN_VIEW_GRID) {
        nib = @"FunVViewController";
    }else if(type == FUN_VIEW_LINE){
        nib = @"FunViewController";
    }
	if ((self = [super initWithNibName:nib bundle:nil]))
	{
        engine = [AnalysisEngine defaultEngine];
        fmt = [[NSDateFormatter alloc] init];
	    [fmt setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
	return self;
}

-(void)setData:(FinanceData *)data{
    viewDataContainer.hidden = NO;
    sclNews.hidden = YES;
    [_data release];
    _data = [data retain];
    [txfTitle setTitleWithMnemonic:_data.title];
    [txfDate setTitleWithMnemonic:[fmt stringFromDate:_data.date]];
    [txfAct setTitleWithMnemonic:_data.actualValue];
    [txfPre setTitleWithMnemonic: _data.previousValue];
    [txfFor setTitleWithMnemonic:_data.forecastValue];
    chart.reload = YES;
    int index = [Utilities indexOfObject:engine.candles date:data.date];
    [chart setPointWidth:5];
    [chart setRangeStartX:(index - 10) * 5];
    if (self.ve == nil) {
        _ve = [[VE alloc] init];
        self.ve.fill = NO;
        self.ve.identity = (long)self.chart;
        self.ve.riseColor = CGColorCreateGenericRGB(0, 0, 0, 1);
        Trend* t = [[Trend alloc] init];
        t.end = index;
        _ve.data = [NSArray arrayWithObject:t];
        [engine addChart:self.ve];
        [t release];
    }else{
        ((Trend* )[_ve.data objectAtIndex:0]).end =index;
    }
}

-(void)setNews:(FinanceNews *)data{
    viewDataContainer.hidden = YES;
    sclNews.hidden = NO;
    [_news release];
    _news = [data retain];
    txvNews.string = [NSString stringWithFormat:@"%@\n\n%@\n\n%@",_news.title,[fmt stringFromDate:_news.date],_news.content];
    chart.reload = YES;
    int index = [Utilities indexOfObject:engine.candles date:data.date];
    [chart setPointWidth:5];
    [chart setRangeStartX:(index - 10) * 5];
    if (self.ve == nil) {
        _ve = [[VE alloc] init];
        self.ve.fill = NO;
        self.ve.identity = (long)self.chart;
        self.ve.keepColor = CGColorCreateGenericRGB(0, 0, 0, 1);
        Trend* t = [[Trend alloc] init];
        t.end = index;
        _ve.data = [NSArray arrayWithObject:t];
        [engine addChart:self.ve];
        [t release];
    }else{
        ((Trend* )[_ve.data objectAtIndex:0]).end =index;
    }
}

-(void)dealloc{
    [[AnalysisEngine defaultEngine] removeChart:self.ve];
    [chart release];
    [txfAct release];
    [txfDate release];
    [txfFor release];
    [txfPre release];
    [txfTitle release];
    [_ve release];
    [_data release];
    [_news release];
    [sclNews release];
    [txvNews release];
    [viewDataContainer release];
    [fmt release];
    _data = nil;
    [super dealloc];
}

@end
