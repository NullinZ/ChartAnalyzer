//
//  OptionsController.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-4.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "OptionsController.h"
#import "ConstDef.h"
@interface OptionsController(Private){
}
-(void)loadSymbolsInThread;
-(void)loadCandlesInThread;
-(void)loadFinanceDataInThread:(id)sender;
-(void)refreshProgressMsg:(NSString *)msg;
@end
@implementation OptionsController
@synthesize txfPath,tbvSymbols,pgiImport,btnImport,rdgPlatform,dprTo,dprFrom,rdgFinanceDataType,pgiImportFinance,txfProgressMsg,dprDelFrom,dprDelTo,pgiDelFinance,rdgFinanceDataDelType;
@synthesize symbols;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self performSelectorInBackground:@selector(loadSymbolsInThread) withObject:nil];
    }
    
    return self;
}

-(void)setView:(NSView *)view{
    [super setView:view];
    dprTo.dateValue = [NSDate date];
    dprFrom.dateValue =  [[AnalysisEngine defaultEngine] lastDataDate];
    dprDelTo.dateValue = [NSDate date];
    dprDelFrom.dateValue =  [[AnalysisEngine defaultEngine] lastDataDate];  

}

-(void)loadSymbolsInThread{
    NSAutoreleasePool *autoPool = [[NSAutoreleasePool alloc] init];
    self.symbols = [AnalysisEngine defaultEngine].symbols;
    [tbvSymbols performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [autoPool release];
}

-(void)pickFile:(id)sender{
    NSOpenPanel *oPanel = [NSOpenPanel openPanel];
    [oPanel setCanChooseDirectories:NO]; 
    [oPanel setAllowsMultipleSelection:NO];
    [oPanel setCanChooseFiles:YES];    
    if ([oPanel runModalForTypes:[NSArray arrayWithObject:@"csv"]] == NSOKButton) 
    {  
        [txfPath setTitleWithMnemonic:[[[oPanel URLs] objectAtIndex:0] path]];
    }
    else {
        [txfPath setTitleWithMnemonic:@""];
    }

}

-(void)changeFinanceType:(id)sender{
    NSInteger index = [rdgFinanceDataType selectedTag];
    if (index == MAT_DATA) {
        dprFrom.dateValue =  [[AnalysisEngine defaultEngine] lastDataDate];
    }else if(index == MAT_NEWS){
        dprFrom.dateValue =  [[AnalysisEngine defaultEngine] lastNewsDate];
    }else{
        dprFrom.dateValue =  [[AnalysisEngine defaultEngine] lastDataDate];
    }
}

-(void)importData:(id)sender{
    [btnImport setEnabled:NO];
    [pgiImport startAnimation:self];
    [self performSelectorInBackground:@selector(loadCandlesInThread) withObject:nil];
}

-(void)loadCandlesInThread{
    NSAutoreleasePool *autoPool = [[NSAutoreleasePool alloc] init];
    NSString *path = [txfPath stringValue];
    NSString *type;
    if ([rdgPlatform selectedTag] == 0) {
        type = FILE_TYPE_MT4;
    }else if([rdgPlatform selectedTag] == 1){
        type = FILE_TYPE_TS2;
    }else{
        type = FILE_TYPE_TS2;
    }
    AnalysisEngine *engine = [AnalysisEngine defaultEngine];
    [engine importWithPath:path type:type];
    self.symbols = engine.symbols;

    [pgiImport performSelectorOnMainThread:@selector(stopAnimation:) withObject:self waitUntilDone:YES];
    [btnImport performSelectorOnMainThread:@selector(setEnabled:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    [tbvSymbols reloadData];
    [autoPool release];
    
}

-(void)refreshProgressMsg:(NSNotification *)msg{
    [txfProgressMsg setTitleWithMnemonic:msg.object];
}

-(void)importFinanceData:(id)sender{
    [sender setEnabled:NO];
    [pgiImportFinance startAnimation:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshProgressMsg:)
                                                 name:NOTIFY_DATA_IMPORT_PROGRESS
                                               object:nil];
    [self performSelectorInBackground:@selector(loadFinanceDataInThread:) withObject:sender];
    

}



-(void)loadFinanceDataInThread:(id)sender{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSDate *start = dprFrom.dateValue;
    NSDate *end = dprTo.dateValue;
    
    [[AnalysisEngine defaultEngine] importFunDataWithType:(int)[rdgFinanceDataType selectedTag] start:start end:end];

    [sender performSelectorOnMainThread:@selector(setEnabled:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:YES];
    [pgiImportFinance performSelectorOnMainThread:@selector(stopAnimation:) withObject:self waitUntilDone:YES];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_DATA_IMPORT_PROGRESS object:nil];
    [pool release];
    
}

-(void)deleteFinanceData:(id)sender{
    NSAlert *alert = [NSAlert alertWithMessageText:@"确认要删除?" defaultButton:@"确定" alternateButton:@"取消" otherButton:nil informativeTextWithFormat:@""];
    if ([alert runModal]) {
        DBService* db = [[DBService alloc] init];
        if ([rdgFinanceDataDelType selectedTag] == MAT_DATA) {
            [db deleteDataWithStart:dprDelFrom.dateValue end:dprDelTo.dateValue];
        }else if([rdgFinanceDataDelType selectedTag] == MAT_NEWS){
            [db deleteNewsWithStart:dprDelFrom.dateValue end:dprDelTo.dateValue];
        }else{
            [db deleteDataWithStart:dprDelFrom.dateValue end:dprDelTo.dateValue];
            [db deleteNewsWithStart:dprDelFrom.dateValue end:dprDelTo.dateValue];

        }
        [db release];
    }    

}

-(void)mergeSymbols:(id)sender{
    NSIndexSet * indexSet = [tbvSymbols selectedRowIndexes];
    if (indexSet.count <2) {
        [NSAlert alertWithMessageText:@"请选择至少两个要合并的记录" defaultButton:@"确定" alternateButton:@"取消" otherButton:nil informativeTextWithFormat:@""];
        return;   
    }
    NSMutableArray *symbolsWillMerge = [[NSMutableArray alloc] initWithCapacity:indexSet.count];
    for (NSInteger i = [indexSet firstIndex];i != NSNotFound; i = [indexSet indexGreaterThanIndex:i]) {
        [symbolsWillMerge addObject:[symbols objectAtIndex:i]];
    }
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"合并操作会删除以前的表，操作不可逆，是否继续?" defaultButton:@"确定" alternateButton:@"取消" otherButton:nil informativeTextWithFormat:@""];
    if ([alert runModal]) {
        DBService* db = [[DBService alloc] init];
        NSMutableArray *result = [[NSMutableArray alloc] init];
        Symbol *symBase,*symTmp;
        symBase = [db getCandlesBySymbol:[symbolsWillMerge objectAtIndex:0]];
        for (int i = 1;i < symbolsWillMerge.count;i++) {
            
        }     
        [db release];
    }
   

}

-(void)deleteSymbols:(id)sender{
    NSInteger index = [tbvSymbols selectedRow];
    if(index < symbols.count&& index > 0){
        Symbol *s = [symbols objectAtIndex:index];
        if (s.name != nil) {
            NSAlert *alert = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"确认要删除%@记录?",s.name] defaultButton:@"确定" alternateButton:@"取消" otherButton:nil informativeTextWithFormat:@""];
            if ([alert runModal]) {
                DBService* db = [[DBService alloc] init];
                NSLog(@"%@",s.name);
                [db deleteSymbolByName:s.name];
                [db dropCandleSheet:s.name];
                [AnalysisEngine defaultEngine].symbols = [db getAllSymbols];
                self.symbols = [AnalysisEngine defaultEngine].symbols;
                [tbvSymbols reloadData];

                [db release];
            }
        }
    }
}

-(void)zeroingSymbols:(id)sender{
    DBService* db = [[DBService alloc] init];
    [db zeroingSymbols];
    [AnalysisEngine defaultEngine].symbols = [db getAllSymbols];
    self.symbols = [AnalysisEngine defaultEngine].symbols;
    [db release];
    [tbvSymbols reloadData];

}

#pragma mark -
#pragma mark NSTableViewDataSource Delegate

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    Symbol *s = [symbols objectAtIndex:row];
    switch ([tableColumn.identifier intValue]) {
        case 0:
            return s.name;
        case 1:
            return s.importDate;
        case 2:
           return [NSNumber numberWithInt:s.count];
        case 3:
            return s.dateSpan;
        case 4:
            return [NSNumber numberWithInt:s.loadCount];
        default:
            return @"";
    }
}
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if (symbols) {
        return [symbols count];
    }else{
        return 0;
    }
}

-(void)test:(id)sender{
//    NSDateFormatter * f = [[NSDateFormatter alloc] init ];
//    [f setDateFormat:@"yyyy-MM-dd HH:mm"];
//    NSDate *d = [f dateFromString:@"2012-10-11 01:08"];
//   NSTimeInterval a = [d timeIntervalSince1970];
//    DBService *db = [[DBService alloc] init];

//    NSLog(@"%@ %@",[db lastDataDate],[db lastNewsDate]);
    //    NSMutableArray *result = [[NSMutableArray alloc] init];
//    [db getNewsWithStart:nil end:nil nation:nil key:nil inArr:result];
//    NSDateFormatter *f = [[NSDateFormatter alloc] init];
//    [f setDateFormat:@"yyyy-MM-dd HH:mm"];
//    for (FinanceNews *d in result) {
//        BOOL a = [db.mDatabaseHandler update:@"update finance_news set date = ? where id = ?",d.date,d._id];
//        BOOL b= a;
//    }
}
-(void)dealloc{
    [symbols release];
    [tbvSymbols release];
    [pgiImport release];
    [txfPath release];
    [txfPath release];
    [btnImport release];
    [rdgPlatform release];
    [dprTo release];
    [dprFrom release];
    [rdgFinanceDataType release];
    [pgiImportFinance release];
    [super dealloc];
}

@end
