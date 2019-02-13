//
//  UkeDrawingCanvas.m
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkeDrawingCanvas.h"
#import "UkePaintingView.h"
#import "UkeDrawingPointGenerater.h"

@interface UkeDrawingCanvas ()
//! 绘画展示的layer
@property (nonatomic, strong) UkePaintingView *paintingView;
//! 绘画起始点
@property (nonatomic, assign) CGPoint startPoint;
@end

@implementation UkeDrawingCanvas

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _paintingView = [[UkePaintingView alloc] init];
        [self addSubview:_paintingView];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:pan];
        
        // 真实数据测试画线
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self generateAndParseLinePoints];
        });
    }
    return self;
}

- (void)generateAndParseLinePoints {
    
    NSMutableArray<NSValue *> *drawingPoints = [NSMutableArray array];
    
    __block NSString *action = nil;
    __block NSString *drawType = nil;
    __block NSArray *drawInfo = nil; // 画笔信息，如粗细，颜色等
    __block NSValue *startPoint = nil;
    __block NSString *terminalFlag = nil;
    
    NSArray<NSArray *> *points = [UkeDrawingPointGenerater linePoints];
    [points enumerateObjectsUsingBlock:^(NSArray *singlePoint, NSUInteger index, BOOL * _Nonnull stop) {
//        if (singlePoint.count >= 5) { // 一定为起始点数据
//            action = singlePoint[2];
//            drawType = singlePoint[3];
//            drawInfo = singlePoint[4];
//            startPoint = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue], [singlePoint[1] floatValue])];
//            if (singlePoint.count > 5) { // 一定既然起点又是终点数据
//                terminalFlag = singlePoint[5];
//                if ([drawType isEqualToString:@"triangle"]) { // 三角形
//
//                }else if ([drawType isEqualToString:@"linearrow"]) { // 箭头
//
//                }else if ([drawType isEqualToString:@"texttool"]) { // 文字
//
//                }
//            }
//        }else if (singlePoint.count == 3) { // 一定为中间点数据
//            NSValue *middlePoint = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue], [singlePoint[1] floatValue])];
//        }else if (singlePoint.count == 4) { // 一定为结束点数据
//            terminalFlag = singlePoint[3];
//            NSValue *middlePoint = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue], [singlePoint[1] floatValue])];
//        }
        
        
        if (singlePoint.count >= 3) {
            action = singlePoint[2];
        }
        
        if (singlePoint.count <= 3) { // 中间点数据
            if (singlePoint.count >= 2) {
                NSValue *point = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue], [singlePoint[1] floatValue])];
                [drawingPoints addObject:point];
            }
        }else {
            drawType = singlePoint[3];
            if ([[UkeDrawingPointGenerater allDrawTypes] containsObject:drawType]) { // 起始点数据
                NSValue *point = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue], [singlePoint[1] floatValue])];
                startPoint = point;
                
                if (singlePoint.count >= 5) {
                    drawInfo = singlePoint[4];
                }
                
                if (singlePoint.count >= 6) {
                    terminalFlag = singlePoint[5];
                    if ([terminalFlag isEqualToString:@"true"]) { // 终止点数据
                        NSValue *point = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue], [singlePoint[1] floatValue])];
                        [drawingPoints addObject:point];
                    }else {
                        terminalFlag = nil;
                    }
                }
            }else {
                terminalFlag = singlePoint[3];
                if ([terminalFlag isEqualToString:@"true"]) { // 终止点数据
                    NSValue *point = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue], [singlePoint[1] floatValue])];
                    [drawingPoints addObject:point];
                }else {
                    terminalFlag = nil;
                }
            }
        }
    }];
    
    
    CGFloat width = 0;
    UIColor *color = nil;
    if (drawInfo) {
        if (drawInfo.count >= 2) {
            width = [drawInfo[0] floatValue];
            NSString *hex = drawInfo[1];
            hex = [hex substringFromIndex:1];
            NSInteger _hex = [self numberWithHexString:hex];
            color = UIColorHex(_hex);
        }
    }
    
    [_paintingView drawWithStartPoint:startPoint otherPoints:drawingPoints width:width color:color drawingState:terminalFlag?UkeDrawingStateEnd:UkeDrawingStateDrawing];
}


- (NSInteger)numberWithHexString:(NSString *)hexString{
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        _paintingView.frame = self.frame;
    }
}

// 手势驱动绘画
- (void)handlePanGesture:(UIGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        _startPoint = point;
    }
    CGPoint currentPoint = point;
    
    [self setCurrentDrawingState:[self drawingStateFromGestureState:pan.state]];
    [self setPointWithStartPoint:_startPoint currentPoint:currentPoint];
}

- (void)setCurrentDrawingState:(UkeDrawingState)state {
    [_paintingView setDrawingState:state];
}

- (void)setPointWithStartPoint:(CGPoint)startPoint
                            currentPoint:(CGPoint)currentPoint {
    [_paintingView drawWithStartPoint:startPoint currentPoint:currentPoint];
}

- (void)setCurrentDrawingMode:(UkeDrawingMode)currentDrawingMode {
    _currentDrawingMode = currentDrawingMode;
    _paintingView.currentDrawingMode = currentDrawingMode;
}

- (UIImage *)currentContents {
    return _paintingView.currentContents;
}

- (void)setCurrentContents:(UIImage *)currentContents {
    [_paintingView setCurrentContents:currentContents];
}


- (UkeDrawingState)drawingStateFromGestureState:(UIGestureRecognizerState)state {
    UkeDrawingState drawingState = UkeDrawingStateUnknown;
    if (state == UIGestureRecognizerStateBegan) {
        drawingState = UkeDrawingStateStart;
    }else if (state == UIGestureRecognizerStateChanged) {
        drawingState = UkeDrawingStateDrawing;
    }else if (state == UIGestureRecognizerStateEnded ||
              state == UIGestureRecognizerStateCancelled ||
              state == UIGestureRecognizerStateFailed) {
        drawingState = UkeDrawingStateEnd;
    }
    return drawingState;
}

- (void)dealloc {
    NSLog(@"手绘板canvas销毁");
}

@end
