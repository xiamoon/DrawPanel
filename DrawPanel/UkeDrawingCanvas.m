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
#import "UkeDrawingPointParser.h"

@interface UkeDrawingCanvas ()
@property (nonatomic, strong) UkeDrawingPointParser *pointParser;
//! 绘画展示的layer
@property (nonatomic, strong) UkePaintingView *paintingView;
//! 绘画起始点
@property (nonatomic, assign) CGPoint startPoint;

//! 当前actionId
@property (nonatomic, copy) NSString *currentAction;

@end

@implementation UkeDrawingCanvas

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _pointParser = [[UkeDrawingPointParser alloc] init];
        
        _paintingView = [[UkePaintingView alloc] init];
        [self addSubview:_paintingView];
        
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
//        [self addGestureRecognizer:pan];
        
        // 真实数据测试画线
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 测试画线
//            [self drawLineWithPoints:[UkeDrawingPointGenerater linePoints]];
            
            // 测试画圆
//            [self testDrawWithPoints:[UkeDrawingPointGenerater ellipsePoints1]];
            
            // 画三角形
            [self testDrawWithPoints:[UkeDrawingPointGenerater trianglePoint]];
        });
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self testDrawWithPoints:[UkeDrawingPointGenerater ellipsePoints2]];
//        });
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self testDrawWithPoints:[UkeDrawingPointGenerater ellipsePoints3]];
//        });
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self testDrawWithPoints:[UkeDrawingPointGenerater ellipsePoints4]];
//        });
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self testDrawWithPoints:[UkeDrawingPointGenerater ellipsePoints5]];
//        });
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        _paintingView.frame = self.frame;
    }
}

- (UIImage *)currentContents {
    return _paintingView.currentContents;
}

- (void)setCurrentContents:(UIImage *)currentContents {
    [_paintingView setCurrentContents:currentContents];
}


#pragma mark - 数据点驱动绘画
- (void)testDrawWithPoints:(NSArray<NSArray *> *)points {
    __weak typeof(self)weakSelf = self;
    [_pointParser parseWithPoints:points completion:^(UkeDrawingPointParser * _Nonnull parser) {
        [weakSelf.paintingView drawWithMode:weakSelf.pointParser.drawingMode startPoint:weakSelf.pointParser.startPoint otherPoints:weakSelf.pointParser.drawingPoints width:weakSelf.pointParser.lineWidth color:weakSelf.pointParser.color drawingState:weakSelf.pointParser.drawingState];
    }];
}


#pragma mark - 手势驱动绘画
/*
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
*/

 
- (void)dealloc {
    NSLog(@"手绘板canvas销毁");
}

@end
