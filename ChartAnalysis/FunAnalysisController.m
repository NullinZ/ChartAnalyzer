//
//  FundamentalAnalysisController.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-16.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "FunAnalysisController.h"
#import "AnalysisEngine.h"
#import "NSColorView.h"

@interface FunAnalysisController(Private)
- (void)addColumn:(NSString*)newid withTitle:(NSString*)title withWidth:(double)width;
@end
@implementation FunAnalysisController
@synthesize cbxSymbols,clvCharts,tbvData,segViewType,tabView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _dark = [[NSColor colorWithDeviceRed:0.0 green:0.0 blue:1.0 alpha:0.1] retain];//(0, 0, 1, 0.1);
        _light =[[NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:1.0] retain];// CGColorCreateGenericRGB(1, 1, 1, 1);
    }
    
    return self;
}

-(void)setView:(NSView *)view{
    [super setView:view];
//    clvCharts.backgroundColor = [NSColor textBackgroundColor];
//    charts = [[NSArray alloc] initWithObjects:chart1,chart2,chart3,chart4,chart5, nil];
//    [charts makeObjectsPerformSelector:@selector(setPointWidth:) withObject:(id)3];
}

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
    [self performSelectorInBackground:@selector(loadCandleInThread:) withObject:sender];
}

-(void)changeViewType:(id)sender{
   	[clvCharts reloadDataWithItems:[AnalysisEngine defaultEngine].funData emptyCaches:YES]; 
}
-(void)changeCondition:(id)sender{
    [tabView selectTabViewItemAtIndex:1];
}
-(void)loadCandleInThread:(id)sender{
    NSAutoreleasePool *pool =[[NSAutoreleasePool alloc] init];
    NSString *symbol = [cbxSymbols stringValue];
   
    [[AnalysisEngine defaultEngine] loadCandles:symbol start:nil end:nil];
    [self performSelectorOnMainThread:@selector(loadCandleInThreadSucc:) withObject:sender waitUntilDone:YES];
    [pool release];
}
-(void)loadCandleInThreadSucc:(id)sender{
//    [charts makeObjectsPerformSelector:@selector(setReload:) withObject:[NSNumber numberWithBool:YES]];
//    [charts makeObjectsPerformSelector:@selector(setPointWidth:) withObject:(id)3];
    [sender setEnabled:YES];
   	[clvCharts reloadDataWithItems:[AnalysisEngine defaultEngine].funData emptyCaches:YES]; 
}

-(void)dealloc{
    [_dark release];
    [_light release];
    [super dealloc];
}
#pragma mark -
#pragma mark BCCollectionViewDelegate

//CollectionView assumes all cells are the same size and will resize its subviews to this size.
- (NSSize)cellSizeForCollectionView:(BCCollectionView *)collectionView
{
    if ([segViewType selectedSegment] == FUN_VIEW_LINE) {
        return NSMakeSize(1148, 150);
    } else if(segViewType.selectedSegment == FUN_VIEW_GRID){
        return NSMakeSize(189, 272);
    }else{
        return NSMakeSize(189, 272);
    }
}

//Return an empty ViewController, this might not be visible to the user immediately
- (NSViewController *)reusableViewControllerForCollectionView:(BCCollectionView *)collectionView
{
    if (segViewType.selectedSegment == FUN_VIEW_LINE) {
        return [[[FunViewController alloc] initWithType:FUN_VIEW_LINE] autorelease];
    } else if(segViewType.selectedSegment == FUN_VIEW_GRID){
        return [[[FunViewController alloc] initWithType:FUN_VIEW_GRID] autorelease];
    }else{
        return [[[FunViewController alloc] initWithType:FUN_VIEW_GRID] autorelease];
    }
}
int cellIndex = 0;
//The CollectionView is about to display the ViewController. Use this method to populate the ViewController with data
- (void)collectionView:(BCCollectionView *)collectionView willShowViewController:(NSViewController *)viewController forItem:(id)anItem
{
	FunViewController *fc = (FunViewController*)viewController;
    if ([anItem isKindOfClass:[FinanceData class]]) {
        [fc setData:anItem];
    }else{
        [fc setNews:anItem];
    }
    if (cellIndex == 100000) {
        cellIndex = 0;
    }
    if (cellIndex++%2) {
        [((NSColorView*)fc.view) setBackgroundColor:_dark];
    }else{
        [((NSColorView*)fc.view) setBackgroundColor:_light];
    }
 	
}

@end
