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
