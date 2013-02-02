//
//  RecognitionController.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-12-30.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "RecognitionController.h"
#import "AnalysisEngine.h"
@interface RecognitionController()
-(void)log:(NSString *)msg;
@end
@implementation RecognitionController
@synthesize resultTableView,codeTableView,txvPattern,logView,txvName,codeArray;
@synthesize ve = _ve;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        prAnalysis = [[PatternAnalyzer alloc] init];
        format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        codeArray = [[NSMutableArray alloc] init];
        
        AnalysisEngine *engine = [AnalysisEngine defaultEngine];
        _ve = [[VE alloc] init];
        self.ve.fill = YES;

        self.ve.keepColor = CGColorCreateGenericRGB(1, 0, 0, .1);
       
        _ve.data = [[NSMutableArray alloc] init];
        [engine addChart:self.ve];
        
        DBService *db = [[DBService alloc] init];
        [codeArray addObjectsFromArray:[db getAllCode]];
        [db release];
    }
    
    return self;
}
+ (RecognitionController *)sharedInstance
{
    static RecognitionController	*sharedInstance = nil;
    
    if (sharedInstance == nil)
    {
        sharedInstance = [[self alloc] init];
        [NSBundle loadNibNamed:@"RecognitionController.nib" owner:sharedInstance];
    }
    
    return sharedInstance;
}

-(void)setView:(NSView *)view{
    [txvPattern setString:@"r:#start\nf:o < [$0 c]&h < [$0 h 0.3]\nf:o < [$1 c]&h < [$0 h 0.3]\nf:o < [$2 c]&h < [$0 h] - [$1 h] - [$2 h]"];
    [super setView:view];
}

-(void)savePattern:(id)sender{
    if(txvName.stringValue){
        NSString *name = [txvName.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![@"" isEqualToString:name]) {
            
            for (NSDictionary * dic in codeArray) {
                if([[dic objectForKey:@"name"] isEqual:name]){
                    [[NSAlert alertWithMessageText:@"同名代码片段已存在!" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"同名代码片段已存在!"] runModal];
                    return;
                }
            }
            DBService *db = [[DBService alloc] init];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[NSString stringWithString:txvName.stringValue] forKey:@"name"];
            [dic setObject:[NSString stringWithString:txvPattern.string] forKey:@"code"];
            [db insertCode:dic];  
            [codeArray addObject:dic];

            [dic release];
            [db release];
            [codeTableView reloadData];
            return;   
        }
    }
    
    [[NSAlert alertWithMessageText:@"代码片段名称不能为空!" defaultButton:@"确定" alternateButton:nil otherButton:nil informativeTextWithFormat:@"代码片段名称不能为空!"] runModal];
}

-(void)deletePattern:(id)sender{
    int selectedRow = (int)codeTableView.selectedRow;
    NSString *name = [[codeArray objectAtIndex:selectedRow] objectForKey:@"name"];
    
    NSAlert *alert = [NSAlert alertWithMessageText:@"确认要删除?" defaultButton:@"确定" alternateButton:@"取消" otherButton:nil informativeTextWithFormat:@""];

    if ([alert runModal]&&name) {
        DBService *db = [[DBService alloc] init];
        [db deleteCode:name];
        [db release];       
        [codeArray removeObjectAtIndex:selectedRow];
        [codeTableView reloadData];
    }

}

-(void)analysis:(id)sender{
    prAnalysis.check = NO;
    [prAnalysis parseMain:[txvPattern string]];
    [self.ve.data removeAllObjects];
    [self log:[NSString stringWithFormat:@"共检索出%d条匹配记录！\n",prAnalysis.queryResults.count]];
    Trend *t;
    for (DataDate* dd in prAnalysis.queryResults) {
        t = [[Trend alloc] init];
        t.start = dd.position;
        t.end = dd.position + prAnalysis.patternLength - 1;
        [self.ve.data addObject:t];
        [t release];
    }
    [resultTableView reloadData];
    [resultTableView setNeedsDisplay];
    [[AnalysisEngine defaultEngine] refreshChartViews];

}

-(void)check:(id)sender{
    prAnalysis.check = YES;
    @try {
        [prAnalysis analysisFragment:[txvPattern string]];
    }
    @catch (NSException *exception) {
        [self log:exception.reason];
        return;
    }
    @finally {
        
    }
    [self log:@"编译通过！\n"];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if (tableView.tag == 0) {
        NSDictionary * code = [codeArray objectAtIndex:row];
        if (code) {
            return [code objectForKey:tableColumn.identifier];
        }
    }else if(tableView.tag == 1){
        DataDate *date = [prAnalysis.queryResults objectAtIndex:row];
        if ([tableColumn.identifier isEqualToString:@"index"]) {
            return [NSString stringWithFormat:@"%d",row + 1];
        }else if([tableColumn.identifier isEqualToString:@"date"]){
            return [format stringFromDate:date.date];
        }else if([tableColumn.identifier isEqualToString:@"position"]){
            return [NSString stringWithFormat:@"%d",date.position];
        }
    }
    return @"";
}
-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    if (notification&&notification.object) {
        NSTableView* tableView = notification.object;
        if (tableView.selectedRow <0) {
            return;
        }
        if (tableView.tag == 0) {
            txvPattern.string = [[codeArray objectAtIndex:tableView.selectedRow] objectForKey:@"code"];
        }else if(tableView.tag == 1){
            DataDate *date = [prAnalysis.queryResults objectAtIndex:[tableView selectedRow]];
            int position = date.position;
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MOVE_CHART_TO object:[NSNumber numberWithInt:position]];
        }
       
    }
    
}

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    if (tableView.tag == 0) {
        return codeArray.count;
    }else if(tableView.tag == 1){
        return prAnalysis.queryResults.count;
    }
    return 0;
}

-(void)showPanel{
    [super showPanel];
    self.ve.identity = [[AnalysisEngine defaultEngine] getMainChart]?(long)[[AnalysisEngine defaultEngine] getMainChart]:0;
    [self.eventSender setEnabled:YES];
}

-(void)log:(NSString *)msg{
    NSAttributedString * as = [[NSAttributedString alloc] initWithString:msg];
    NSTextStorage *storage = [logView textStorage];
    [storage beginEditing];
    [storage appendAttributedString:as];
    [storage endEditing];
    [as release];
    NSRange range = NSMakeRange ([[logView string] length], 0);
    [logView scrollRangeToVisible: range];

}

-(void)dealloc{
    [prAnalysis release];
    [_ve release];
    [format release];
    [codeArray release];
    [super dealloc];
}
@end
