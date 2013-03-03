//
//  ChartView.m
//  FinacialSSI
//
//  Created by Sheng Zhao on 12-7-29.
//  Copyright (c) 2012年 Innovation Workshop. All rights reserved.
//
#define hide 0
#import "ChartView.h"
#import "ConstDef.h"
#import "ChartController.h"
#import "Histrogram.h"
#import "Trend.h"
#import "VE.h"
@interface ChartView(Private)
-(void)bindEvent;
-(void)refreshK;
-(void)refreshFactor;
-(void)drawCandles:(CGContextRef)context withCandles:(NSArray*)candles;
-(void)drawHistogram:(CGContextRef)context withIndicator:(BaseIndicator<IIndicator> *)indicator;
-(void)drawCurve:(CGContextRef)context withIndicator:(BaseIndicator<IIndicator> *)indicator;
//x1 index,y1 value,x2 index,y2 value
-(void)drawLine:(CGContextRef)context withIndicator:(BaseIndicator<IIndicator> *)indicator;
-(void)drawArea:(CGContextRef)context withIndicator:(BaseIndicator<IIndicator> *)indicator;//
-(void)nsImageToCGImageRef:(NSImage*)image imgRef:(CGImageRef*)ref;
@end
@implementation ChartView
@synthesize controller,pointWidth,rangeStartX,rangeEnd,rangeStart,isAnchorShow,curCandle = _curCandle;
@synthesize candleNeedDraw,cycle = _cycle;
@synthesize factor = _factor;
@synthesize autoFit = _autoFit;
@synthesize reload = _reload;

#pragma mark -
#pragma mark init&dealloc
- (id)initWithFrame:(NSRect)rect
{
    self= [super initWithFrame:rect];
    if (self)
    {
        //初始化变量
        pointWidth = -1;
        _cycle = -1;
        _reload = YES;
        width = self.bounds.size.width;
        height = self.bounds.size.height;
        rangeStartY = 0;
        _factor = 1;
        _autoFit = NO;
        self.candleNeedDraw = YES;
        [self bindEvent];
        [[AnalysisEngine defaultEngine] addChartView:self];
        fmt = [[NSDateFormatter alloc] init];
        [fmt setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    return self;
}

- (void)dealloc
{
    [fmt release];
    [_curCandle release];
    [controller release];
    [super dealloc];
}

-(void)resizeSubviewsWithOldSize:(NSSize)oldSize{
    width = self.bounds.size.width;
    height = self.bounds.size.height;
    [self setCycle:_cycle];
}

#pragma mark -
#pragma mark draw method
- (void)drawRect:(NSRect)dirtyRect
{
    CGContextRef c= [[NSGraphicsContext currentContext] graphicsPort];
    //背景
    CGContextSetRGBFillColor(c, 1, 1, 1, 1);
    CGContextFillRect(c, [self bounds]);
    AnalysisEngine *engine = [AnalysisEngine defaultEngine];
    //筛选时段
    if (candleNeedDraw&&engine.candles != nil&& engine.candles.count) {
        [self drawCandles:c withCandles:engine.candles];
        if (isAnchorShow) {
            CGImageRef imgRef;
            [self nsImageToCGImageRef:[NSImage imageNamed:@"anchor.png"] imgRef:&imgRef];
            CGContextDrawImage(c, CGRectMake(-anchorStartX - dragDeltaX, 10, 25, 25),imgRef );
            CGImageRelease(imgRef);
        }
    }
    if (engine.charts.count) {
        for (BaseIndicator<IIndicator> *chart in engine.charts) {
            if (chart.identity != (long)self) {
                continue;
            }else if(chart.chartType == CHART_CURVE){
                [self drawCurve:c withIndicator:chart];
//            } else if(chart.chartType == CHART_HISTOGRAM){
//                [self drawHistogram:c withIndicator:chart];
            } else if(chart.chartType == CHART_LINE){
                [self drawLine:c withIndicator:chart];
//            } else if(chart.chartType == CHART_AREA){
//                [self drawArea:c withIndicator:chart];
            } else {
                [chart doDraw:c withPointWidth:pointWidth rangeStart:rangeStart rangeEnd:rangeEnd rangeStartY:rangeStartY deltaY:dragDeltaX width:width height:height k:k h:h px:px];
            }
        }
    }
}


//-(void)drawHistogram:(CGContextRef)context withIndicator:(Histrogram *)indicator{
//    NSArray * indices = indicator.data;
//    if (!indices||indices.count<=0) {
//        return;
//    }
//    CGContextSetFillColorWithColor(context, indicator.color);
//    double volume;
//    int start = indicator.span?0:rangeStart;
//    int end = indicator.span?indicator.span:rangeEnd;
//    for (int i = start; i < end && i < indices.count; i++) {
//        volume = [[indices objectAtIndex:i] doubleValue];
//        int cx = (i - start) * pointWidth;
//        double cy = indicator.heightFactor * height * volume / indicator.maxHeight;
//        CGContextFillRect(context, CGRectMake(cx, 0, pointWidth - 1, cy));
//    }
//    int index = px * indicator.span/ width;
//    int key = indicator.keys&&indicator.keys.count?[[indicator.keys objectAtIndex:index] intValue]:index+1;
//    const char * tip = [[NSString stringWithFormat:@"i:%d v:%f", key, [[indices objectAtIndex:MIN(index ,indices.count-1)] doubleValue]] UTF8String];
//    CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, -1.0, 0.0);
//    CGContextSetTextMatrix(context, xform);
//    CGContextSelectFont(context, "Arial", 10, kCGEncodingMacRoman);
//    CGContextSetTextDrawingMode(context, kCGTextFill);
//    CGContextSetTextPosition(context, width-80, height-10);
//    CGContextShowText(context, tip, strlen(tip));
//    
//}
//x1 index,y1 value,x2 index,y2 value
-(void)drawLine:(CGContextRef)context withIndicator:(BaseIndicator<IIndicator> *)indicator{
    NSArray * indices = indicator.data;
    if (!indices||indices.count<=0) {
        return;
    }
    int start = [[indices objectAtIndex:0] intValue];
    int end = [[indices objectAtIndex:2] intValue];
    
    double xs1 = (start - rangeStart) * pointWidth + pointWidth / 2 - 1;
    double ys1 = [[indices objectAtIndex:1] doubleValue] * k - h - rangeStartY - dragDeltaY;
    double xs2 = (end - rangeStart) * pointWidth + pointWidth / 2 - 1;
    double ys2 = [[indices objectAtIndex:3] doubleValue] * k - h - rangeStartY - dragDeltaY;
    double lineK = (start == end) ? 0:(ys2 - ys1) / (xs2 - xs1);
    double lineB = ys1 - xs1 * lineK;
    double y2 = lineK * width + lineB;
    CGContextMoveToPoint(context, 0,lineB);
    CGContextAddLineToPoint(context, width, y2);
    CGContextSetStrokeColorWithColor(context, indicator.color);
    CGContextStrokePath(context);
}

//-(void)drawArea:(CGContextRef)context withIndicator:(VE *)indicator{
//    NSArray * indices = indicator.data;
//    if (!indices||indices.count<=0) {
//        return;
//    }
//    Trend *t;
//    int cx;
//    for (int i = 0;i < indices.count;i++) {
//        t = [indices objectAtIndex:i];
//        cx = ((indicator.fill?t.start : t.end) - rangeStart) * pointWidth + (indicator.fill?0:pointWidth);
//        switch (t.type) {
//            case RISE:
//                CGContextSetFillColorWithColor(context, indicator.riseColor);
//                break;
//            case KEEP:
//                CGContextSetFillColorWithColor(context, indicator.keepColor);
//                break;
//            case FALL:
//                CGContextSetFillColorWithColor(context, indicator.fallColor);
//                break;
//            default:
//                NSLog(@"bad trend type for setColor");
//         
//        }
//        CGContextFillRect(context, CGRectMake(cx, 0, indicator.fill?(t.span+1) * pointWidth:1, height));
//    }
//}

-(void)drawCurve:(CGContextRef)context withIndicator:(BaseIndicator<IIndicator> *)indicator{
    NSArray * indices = indicator.data;
    if (!indices||indices.count<=0) {
        return;
    }
    double c;
    CGContextBeginPath(context);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    int curveStart = rangeStart;
    for (int i = rangeStart; i < rangeEnd; i++) {
        c = [[indices objectAtIndex:i] doubleValue];
        if (c >= 0 ) {
            int cx = (i - rangeStart) * pointWidth + pointWidth / 2 - 1 ;
            int cy = c * k - h - rangeStartY - dragDeltaY;

            if (i == curveStart) {
                CGContextMoveToPoint(context, cx, cy);
            }else{
                CGContextAddLineToPoint(context, cx, cy);
            }
        }else{
            curveStart++;
        }
    }
    //    CGContextClosePath(context);
    CGContextSetStrokeColorWithColor(context, indicator.color);
    CGContextDrawPath(context,kCGPathStroke);
}

-(void)drawCandles:(CGContextRef)c withCandles:(NSArray *)candleArr{
    Candle *candle;
    for (int i = rangeStart; i < rangeEnd ; i++) {
        candle = ([candleArr objectAtIndex:i]);
        if(candle.open > candle.close){
            CGContextSetRGBFillColor(c, 1, 0, 0, hide?.1*hide:1);
        }else{
            CGContextSetRGBFillColor(c, 0, 0, 1,  hide?.1*hide:1);
        }
        //画candles
        int cx = (i - rangeStart) * pointWidth;
        int oy = h + rangeStartY + dragDeltaY;
        CGContextFillRect(c, CGRectMake(cx, 
                                        MIN(candle.open, candle.close) * k -  oy,
                                        pointWidth - 1, 
                                        MAX(1,ABS(candle.open - candle.close)*k)));
        CGContextFillRect(c, CGRectMake(cx + pointWidth / 2 - 1, 
                                        candle.low * k - oy, 
                                        1, 
                                        ABS(candle.high - candle.low) * k));
    }
    CGContextSetRGBFillColor(c, 0, 0, 1, 1);
    //鼠标当前值
    const char * tip = [[NSString stringWithFormat:@"%.5f",(py + rangeStartY + dragDeltaY) / k + min] UTF8String];
    CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, -1.0, 0.0);
    CGContextSetTextMatrix(c, xform);
    CGContextSelectFont(c, "Arial", 10, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(c, kCGTextFill);
    CGContextSetTextPosition(c, width-50, py);
    CGContextShowText(c, tip, strlen(tip));
    const char * date = self.curCandle?[[fmt stringFromDate:self.curCandle.date] UTF8String]:nil;
    CGContextSetTextPosition(c, width-90, py-10);
    CGContextShowText(c, date, date?strlen(date):0);
    
    //坐标标尺
    CGContextSetRGBFillColor(c, 0,0,1,0.05);
    CGContextFillRect(c, CGRectMake(px / pointWidth * pointWidth, 0, pointWidth, height));
    CGContextSetRGBFillColor(c, 0,0,0,0.2);
    CGContextFillRect(c, CGRectMake(0, py, width, 1));
}

- (void)nsImageToCGImageRef:(NSImage*)image imgRef:(CGImageRef *)ref;
{
    NSData * imageData = [image TIFFRepresentation];

    if(imageData)
    {
        CGImageSourceRef imageSource = 
        CGImageSourceCreateWithData((CFDataRef)imageData,  NULL);
        *ref = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
        CFRelease(imageSource);
    }

}
#pragma mark -
#pragma mark status
-(void)setIsAnchorShow:(BOOL)isShow{
    if (isShow) {
        anchorStartX = 0;
    }
    isAnchorShow = isShow;
    [self setNeedsDisplayInRect:CGRectMake(-anchorStartX - dragDeltaX, 10, 25, 25)];
}
-(void)setPointWidth:(int)ptWidth{
    AnalysisEngine *engine = [AnalysisEngine defaultEngine];
    if (!_reload) {
        rangeStartX *=(ptWidth*1.0f / pointWidth);
    }else if(engine.candles.count){
        pointWidth = ptWidth;
        rangeStartX = (int)(engine.candles.count * pointWidth - width - pointWidth);
        [self refreshK];
        _reload = NO;
    }    
    pointWidth = ptWidth;
//    _cycle = width / pointWidth;
    [self setNeedsDisplay:YES];
}

-(void)setCycle:(int)cycle{
    _cycle = cycle;
    [self setPointWidth:MAX(1, width / cycle)];
}

-(void)setRangeStartX:(int)startX{
    rangeStartX = startX;
    [self refreshK];
}

-(void)setAutoFit:(BOOL)autoFit{
    _autoFit = autoFit;    
    if(autoFit){
        rangeStartY = 0;
        [self refreshFactor];
    }
}
-(void)setFactor:(double)factor{
    k /=_factor;
    _factor = factor;
    k*= _factor;
    h = min *k;
    [self setNeedsDisplay:YES];
}
-(void)refreshK{
    BOOL tmp = _autoFit;
    _autoFit = YES;
    [self refreshFactor];
    _autoFit = tmp;
}

-(void)refreshFactor{
    NSArray* candles = [AnalysisEngine defaultEngine].candles;
    if (candles.count) {
        rangeStart = MAX(0, (rangeStartX+dragDeltaX) / pointWidth);
        rangeEnd =(int)MIN(candles.count - 1,(rangeStartX + dragDeltaX + width) / pointWidth);
        controller.sdrRange.intValue = rangeStart;
        if(self.autoFit){
            max = 0;
            min = 655350;
            Candle *candle;
            //确定范围找到最大最小值
            for (int i = rangeStart; i < rangeEnd ; i++) {
                candle = [candles objectAtIndex:i];
                if (min > candle.low) {
                    min = candle.low;
                }
                if(max < candle.high){
                    max = candle.high;
                }
            }
            
            k = height  / (max - min) * self.factor;
            h = min * k;
        }
    }
    [self setNeedsDisplay:YES];
}
#pragma mark -
#pragma mark event method
-(void)mouseDown:(NSEvent *)theEvent{
    dragStartX = [self convertPoint:theEvent.locationInWindow fromView:nil].x;
    dragStartY = [self convertPoint:theEvent.locationInWindow fromView:nil].y;
}
-(void)mouseUp:(NSEvent *)theEvent{
    rangeStartX += dragDeltaX;
    if (isAnchorShow) {
        anchorStartX+= dragDeltaX;
    }
    dragDeltaX = 0;
    rangeStartY += dragDeltaY;
    dragDeltaY = 0;
    [self setNeedsDisplay:YES];
}
-(void)mouseEntered:(NSEvent *)theEvent{
    px = [self convertPoint:theEvent.locationInWindow fromView:nil].x;
    py = [self convertPoint:theEvent.locationInWindow fromView:nil].y;
    [self setNeedsDisplay:YES];
}
-(void)mouseMoved:(NSEvent *)theEvent{
    px = [self convertPoint:theEvent.locationInWindow fromView:nil].x;
    py = [self convertPoint:theEvent.locationInWindow fromView:nil].y;
    int count = (int)[AnalysisEngine defaultEngine].candles.count;
    if (count) {
        self.curCandle = [[AnalysisEngine defaultEngine].candles objectAtIndex:MAX(0,MIN((px + rangeStartX - pointWidth/2) / pointWidth,count - 1))];
        if(controller){
            controller.curCandle = _curCandle;
        }
    }
    [self setNeedsDisplay:YES];

}

-(void)mouseDragged:(NSEvent *)theEvent{
    px = [self convertPoint:theEvent.locationInWindow fromView:nil].x;
    py = [self convertPoint:theEvent.locationInWindow fromView:nil].y;
    int ddx = rangeStartX + dragStartX - px;
    if (ddx > 0 && (ddx < [AnalysisEngine defaultEngine].candles.count * pointWidth - width / 2 ||dragStartX < px)) {
        dragDeltaX = dragStartX - px;
    }
    [self refreshFactor];
    dragDeltaY = dragStartY - py;
    [self setNeedsDisplay:YES];
}

-(void)bindEvent{
    //添加事件
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds] 
                                                                options: (NSTrackingMouseEnteredAndExited 
                                                                          | NSTrackingMouseMoved 
                                                                          | NSTrackingActiveInKeyWindow ) 
                                                                  owner:self 
                                                               userInfo:nil]; 
    [self addTrackingArea:trackingArea]; 
    [trackingArea release];
    [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];  
    [self setAcceptsTouchEvents:YES];
}
@end
