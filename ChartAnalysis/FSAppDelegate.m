//
//  FSAppDelegate.m
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-9-22.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import "FSAppDelegate.h"
@implementation FSAppDelegate
@synthesize mEngine;
@synthesize window = _window;


- (void)dealloc
{
    [super dealloc];
}
-(void)testAction:(id)sender{
}	
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    mEngine = [AnalysisEngine defaultEngine];
}

/**
    Returns the directory the application uses to store the Core Data store file. This code uses a directory named "ChartAnalysis" in the user's Library directory.
 */
- (NSURL *)applicationFilesDirectory {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *libraryURL = [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
    return [libraryURL URLByAppendingPathComponent:@"ChartAnalysis"];
}

-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag{
    if (flag) {
		return NO;
	}	
    else
	{
        [self.window makeKeyAndOrderFront:self];
        return YES;	
	}
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

 
    return NSTerminateNow;
}

@end
