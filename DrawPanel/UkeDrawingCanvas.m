//
//  UkeDrawingCanvas.m
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkeDrawingCanvas.h"
#import "UkePaintingLayer.h"

@interface UkeDrawingCanvas ()
//! 绘画的layer
@property (nonatomic, strong) UkePaintingLayer *paintingLayer;
// 手势状态
@property (nonatomic, assign) UIGestureRecognizerState state;

@end

@implementation UkeDrawingCanvas

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:pan];
        
        _paintingLayer = [[UkePaintingLayer alloc] init];
        [self.layer addSublayer:_paintingLayer];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        _paintingLayer.frame = self.frame;
    }
}

- (void)handlePanGesture:(UIGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self];
    
    _state = pan.state;
    
    CGPoint startPoint = CGPointZero;
    if (_state == UIGestureRecognizerStateBegan) {
        startPoint = point;
    }
    CGPoint currentPoint = point;
    
    [_paintingLayer setDrawingState:[self drawingStateFromGestureState:pan.state]];
    [_paintingLayer drawWithStartPoint:startPoint currentPoint:currentPoint];
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

- (CALayer *)currentPainting {
    return self.layer;
}

- (void)setCurrentPainting:(CALayer *)currentPainting {
    NSArray *sublayers = currentPainting.sublayers.copy;
    if (sublayers.count) {
        for (int i = 0; i < sublayers.count; i++) {
            CALayer *layer = sublayers[i];
//            [self.layer addSublayer:layer];
            [self.layer insertSublayer:layer below:_paintingLayer];

        }
    }
}

- (void)dealloc {
    NSLog(@"canvas销毁");
}

@end
