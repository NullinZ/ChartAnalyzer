//
//  NSColorView.h
//  ChartAnalysis
//
//  Created by Sheng Zhao on 12-10-22.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColorView : NSView{
    CGColorRef _background;
}
-(void)setBackgroundColor:(NSColor*)color;
@end
