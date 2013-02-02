//
//  FundamentalController.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-16.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "FundamentalController.h"
@interface FundamentalController(Private)
- (void)addColumn:(NSString*)newid withTitle:(NSString*)title withWidth:(double)width;
- (void)initTableHeader:(NSTableView*)tableView;
- (void)getDataInThread:(id)sender;
@end
@implementation FundamentalController
@synthesize dprEnd,dprStart,txfNation,txfKeywords,tbvData,tbvAnaData,pgiLoad,tabView;
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        dataType = 0;
    }
    
    return self;
}

-(void)query:(id)sender{
    [sender setEnabled:NO];
    [pgiLoad startAnimation:self];
    [self performSelectorInBackground:@selector(getDataInThread:) withObject:sender];
    if (dataType == NEWS) {
//       NSTabViewItem *item = [tabView.tabViewItems objectAtIndex:2];
//        [[item view] setHidden:YES];
    }else if(dataType == DATA){
//        NSTabViewItem *item = [tabView.tabViewItems objectAtIndex:2];
//        [[item view] setHidden:NO];
    }
}

-(void)getDataInThread:(id)sender{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [[AnalysisEngine defaultEngine] loadFunDataWithType:dataType start:dprStart.dateValue end:dprEnd.dateValue nation:[txfNation stringValue]  keywords:[txfKeywords stringValue]];
    [tbvData performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [tbvAnaData performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [sender performSelectorOnMainThread:@selector(setEnabled:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    [pgiLoad performSelectorOnMainThread:@selector(stopAnimation:) withObject:self waitUntilDone:YES];
    [pool release];
}

-(void)toAnalysis:(id)sender{
    [tabView selectTabViewItemAtIndex:2];
}

-(void)changeType:(id)sender{
    NSSegmentedControl *seg = sender;
    dataType = (int)[seg selectedSegment];
    [self initTableHeader:tbvAnaData];
    [self initTableHeader:tbvData];
 }

- (void)addColumn:(NSString*)newid withTitle:(NSString*)title withWidth:(double)width
{
	NSTableColumn *column=[[NSTableColumn alloc] initWithIdentifier:newid];
	[[column headerCell] setStringValue:title];
	[[column headerCell] setAlignment:NSCenterTextAlignment];
	[column setWidth:width];
	[column setMinWidth:20];
	[column setEditable:NO];
	[column setResizingMask:NSTableColumnAutoresizingMask | NSTableColumnUserResizingMask];
	[tbvData addTableColumn:column];
	[tbvAnaData addTableColumn:column];
	[column release];
}
-(void)initTableHeader:(NSTableView *)tableView{
    NSArray *columns = [tableView tableColumns];
    
    while ([columns count]) {
        [tableView removeTableColumn:[columns objectAtIndex:0]];
    }
    
    if (dataType == NEWS) {
        [self addColumn:@"date" withTitle:@"时间" withWidth:140];
        [self addColumn:@"title" withTitle:@"标题" withWidth:400];
        [self addColumn:@"content" withTitle:@"详情" withWidth:1000];
    }else if (dataType == 2) {
        [self addColumn:@"date" withTitle:@"时间" withWidth:140];
        [self addColumn:@"title" withTitle:@"标题" withWidth:300];
        [self addColumn:@"content" withTitle:@"详情" withWidth:1000];
    }else if(dataType == DATA){
        
        [self addColumn:@"date" withTitle:@"时间" withWidth:130];
        [self addColumn:@"level" withTitle:@"级别" withWidth:30];
        [self addColumn:@"title" withTitle:@"标题" withWidth:350];
        [self addColumn:@"previousValue" withTitle:@"前值" withWidth:100];
        [self addColumn:@"forecastValue" withTitle:@"预期" withWidth:100];
        [self addColumn:@"actualValue" withTitle:@"实际值" withWidth:100];
        [self addColumn:@"content" withTitle:@"解释" withWidth:1000];
    }
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [[[AnalysisEngine defaultEngine] funData] count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if (dataType == DATA) {
        id obj = [[[AnalysisEngine defaultEngine] funData] objectAtIndex:row];
        if (![obj isKindOfClass:[FinanceData class]]) {
            return @"";
        }
        FinanceData *data =obj;
        NSString * key = tableColumn.identifier;
        id column = [data valueForKey:key];
        if ([column isKindOfClass:NSDate.class]) {
            return [format stringFromDate:column];
        }else {
            return column;
        }
    }else if(dataType == NEWS){
        FinanceNews *news = [[[AnalysisEngine defaultEngine] funData] objectAtIndex:row];
        id column = [news valueForKey:tableColumn.identifier];
        if ([column isKindOfClass:NSDate.class]) {
            return [format stringFromDate:column];
        }else {
            return column;
        }
    }
    return @"";
}
-(void)setView:(NSView *)view{
    [super setView:view];
    [self initTableHeader:tbvAnaData];
    [self initTableHeader:tbvData];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setDay:-10];
    dprEnd.dateValue = date;
    dprStart.dateValue = [calendar dateByAddingComponents:comp toDate:date options:0];
    [comp release];
}
-(void)dealloc{
    [pgiLoad release];
    [dprStart release];
    [dprEnd release];
    [txfNation release];
    [txfKeywords release];
    [tbvData release];
    [tbvAnaData release];
    [format release];
    [super dealloc];
}
@end
