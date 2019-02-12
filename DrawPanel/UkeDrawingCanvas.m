//
//  UkeDrawingCanvas.m
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkeDrawingCanvas.h"
#import "UkePaintingView.h"

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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *points = @[[NSValue valueWithCGPoint:CGPointMake(287.5,272.5)],
                                [NSValue valueWithCGPoint:CGPointMake(288.33333333333337,272.5)],
                                [NSValue valueWithCGPoint:CGPointMake(290,273.33333333333337)],
                                [NSValue valueWithCGPoint:CGPointMake(292.5,274.1666666666667)],
                                [NSValue valueWithCGPoint:CGPointMake(296.6666666666667,276.6666666666667)],
                                [NSValue valueWithCGPoint:CGPointMake(300,278.33333333333337)],
                                [NSValue valueWithCGPoint:CGPointMake(303.33333333333337,280)],
                                [NSValue valueWithCGPoint:CGPointMake(306.6666666666667,281.6666666666667)],
                                [NSValue valueWithCGPoint:CGPointMake(309.1666666666667,281.6666666666667)],
                                [NSValue valueWithCGPoint:CGPointMake(312.5,282.5)],
                                [NSValue valueWithCGPoint:CGPointMake(313.33333333333337,282.5)],
                                [NSValue valueWithCGPoint:CGPointMake(315,283.33333333333337)],
                                [NSValue valueWithCGPoint:CGPointMake(316.6666666666667,284.1666666666667)],
                                [NSValue valueWithCGPoint:CGPointMake(316.6666666666667,284.1666666666667)]];
            [self.paintingView setDrawingState:UkeDrawingStateEnd];
            [self.paintingView drawWithPoints:points width:2 color:[UIColor redColor]];
        });
    }
    return self;
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
