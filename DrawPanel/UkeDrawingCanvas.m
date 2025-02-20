//
//  UkeDrawingCanvas.m
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkeDrawingCanvas.h"
#import "UkePaintingDisplayLayer.h"

@interface UkeDrawingCanvas ()
//! 绘画展示的layer
@property (nonatomic, strong) UkePaintingDisplayLayer *displayLayer;
//! 绘画起始点
@property (nonatomic, assign) CGPoint startPoint;
@end

@implementation UkeDrawingCanvas

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _displayLayer = [[UkePaintingDisplayLayer alloc] init];
        [self.layer addSublayer:_displayLayer];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        _displayLayer.frame = self.frame;
    }
}

- (void)setCurrentDrawingMode:(UkeDrawingMode)currentDrawingMode {
    _currentDrawingMode = currentDrawingMode;
    _displayLayer.currentDrawingMode = currentDrawingMode;
}

- (void)handlePanGesture:(UIGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        _startPoint = point;
    }
    CGPoint currentPoint = point;
    
    [_displayLayer setDrawingState:[self drawingStateFromGestureState:pan.state]];
    [_displayLayer drawWithStartPoint:_startPoint currentPoint:currentPoint];
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

- (NSArray<CAShapeLayer *> *)currentStrokes {
    return _displayLayer.currentStrokes;
}

- (void)setCurrentStrokes:(NSArray<CAShapeLayer *> *)currentStrokes {
    [_displayLayer setCurrentStrokes:currentStrokes];
}

- (void)dealloc {
    NSLog(@"canvas销毁");
}

@end
