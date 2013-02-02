//
//  PanelController.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-27.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PanelController : NSViewController{
    id eventSender;
}

@property (nonatomic,retain) IBOutlet NSPanel *panel;
@property (nonatomic,retain) id eventSender;


//	Show the panel, starting the text at the top with the animation going
- (void)showPanel;

//	Stop scrolling and hide the panel.
- (void)hidePanel;
@end
