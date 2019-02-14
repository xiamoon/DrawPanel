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
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:pan];
        
        // 画笔
        [self testDrawWithPoints:[UkeDrawingPointGenerater startPoints:UkeDrawingModeLine]];
        [self testDrawWithPoints:[UkeDrawingPointGenerater points2]];
        [self testDrawWithPoints:[UkeDrawingPointGenerater points3]];
        [self testDrawWithPoints:[UkeDrawingPointGenerater points4]];
        [self testDrawWithPoints:[UkeDrawingPointGenerater endPoints]];
        // 三角形
        [self testDrawWithPoints:[UkeDrawingPointGenerater triangleWholePoints]];
        // 文字
        [self testDrawWithPoints:[UkeDrawingPointGenerater textWholePoints]];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self testDrawWithPoints:[UkeDrawingPointGenerater startPoints:UkeDrawingModeEraserRectangle]];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self testDrawWithPoints:[UkeDrawingPointGenerater points2]];
        });

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableArray *points = [NSMutableArray array];
            NSArray *end = @[@"302",@"190",@"14",@"true"];
            [points addObject:end];
            [self testDrawWithPoints:points];
        });

//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self testDrawWithPoints:[UkeDrawingPointGenerater endPoints]];
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
        if (parser.drawingMode == UkeDrawingModeText) {
            [weakSelf.paintingView drawTextWithText:parser.text startPoint:parser.startPoint fontSize:parser.lineWidth color:parser.color drawingState:parser.drawingState];
        }else {
            [weakSelf.paintingView drawWithMode:parser.drawingMode startPoint:parser.startPoint otherPoints:parser.drawingPoints width:parser.lineWidth color:parser.color drawingState:parser.drawingState];
        }
    }];
}


#pragma mark - 手势驱动绘画

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

 
- (void)dealloc {
    NSLog(@"手绘板canvas销毁");
}

@end
