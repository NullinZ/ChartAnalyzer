//
//  FundamentalAnalysisController.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-16.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChartView.h"
#import "BCCollectionView.h"
#import "FunViewController.h"
@interface FunAnalysisController : NSViewController<BCCollectionViewDelegate>{
    NSColor* _dark;
    NSColor* _light;
}

@property (nonatomic,retain) IBOutlet NSTabView *tabView;
@property (retain,nonatomic) IBOutlet NSComboBox *cbxSymbols;
@property (retain,nonatomic) IBOutlet BCCollectionView *clvCharts;
@property (retain,nonatomic) IBOutlet NSTableView *tbvData;
@property (retain,nonatomic) IBOutlet NSSegmentedControl *segViewType;

-(IBAction)loadCandleSource:(id)sender;
-(IBAction)changeViewType:(id)sender;
-(IBAction)changeCondition:(id)sender;

@end
