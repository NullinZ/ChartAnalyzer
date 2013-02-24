//
//  OptionsController.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-4.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AnalysisEngine.h"
@interface OptionsController : NSViewController<NSTabViewDelegate,NSTableViewDataSource>

@property (retain,nonatomic) IBOutlet NSTextField *txfPath;
@property (retain,nonatomic) IBOutlet NSTextField *txfProgressMsg;
@property (retain,nonatomic) IBOutlet NSProgressIndicator *pgiImport;
@property (retain,nonatomic) IBOutlet NSProgressIndicator *pgiImportFinance;
@property (retain,nonatomic) IBOutlet NSProgressIndicator *pgiDelFinance;
@property (retain,nonatomic) IBOutlet NSTableView *tbvSymbols;
@property (retain,nonatomic) IBOutlet NSButton *btnImport;
@property (retain,nonatomic) IBOutlet NSDatePicker *dprFrom;
@property (retain,nonatomic) IBOutlet NSDatePicker *dprTo;
@property (retain,nonatomic) IBOutlet NSDatePicker *dprDelFrom;
@property (retain,nonatomic) IBOutlet NSDatePicker *dprDelTo;
@property (retain,nonatomic) IBOutlet NSMatrix *rdgPlatform;
@property (retain,nonatomic) IBOutlet NSMatrix *rdgFinanceDataType;
@property (retain,nonatomic) IBOutlet NSMatrix *rdgFinanceDataDelType;
@property (strong,nonatomic) NSArray *symbols;
-(IBAction)pickFile:(id)sender;
-(IBAction)importData:(id)sender;
-(IBAction)importFinanceData:(id)sender;
-(IBAction)deleteFinanceData:(id)sender;
-(IBAction)zeroingSymbols:(id)sender;
-(IBAction)changeFinanceType:(id)sender;
-(IBAction)test:(id)sender;
-(IBAction)mergeSymbols:(id)sender;
-(IBAction)deleteSymbols:(id)sender;

@end
