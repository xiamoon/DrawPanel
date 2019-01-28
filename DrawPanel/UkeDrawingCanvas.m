//
//  UkeDrawingCanvas.m
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkeDrawingCanvas.h"

@interface UkeDrawingCanvas ()
//! 画笔路径
@property (nonatomic, assign) CGMutablePathRef path;
// 手势状态
@property (nonatomic, assign) UIGestureRecognizerState state;
//! 落笔的第一点
@property (nonatomic, assign) CGPoint startPoint;
//! 当前点
@property (nonatomic, assign) CGPoint currentPoint;
//! 所有的笔画
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *allStrokes;

@end

@implementation UkeDrawingCanvas

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _allStrokes = [NSMutableArray array];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)handlePanGesture:(UIGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:self];
    
    _state = pan.state;
    _currentPoint = point;
    if (_state == UIGestureRecognizerStateBegan) {
        _startPoint = point;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (CGPointEqualToPoint(_currentPoint, CGPointZero)) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetMiterLimit(context, 2.0);
    CGContextSetLineWidth(context, 4.0);

    [[UIColor redColor] setStroke];
    
    if (_path == NULL) {
        _path = CGPathCreateMutable();
    }
    
    if (_currentDrawingMode == UkeDrawingModeLine) { //! 画线
        if (_state == UIGestureRecognizerStateBegan) {
            CGPathMoveToPoint(_path, NULL, _currentPoint.x, _currentPoint.y);
        }else {
            CGPathAddLineToPoint(_path, NULL, _currentPoint.x, _currentPoint.y);
        }
        CGContextAddPath(context, _path);
        CGContextDrawPath(context, kCGPathStroke);
        if (_state == UIGestureRecognizerStateEnded) {
            [self didEndDrawingOneStroke:_path];
            CGPathRelease(_path);
            _path = NULL;
        }
    }
    else if (_currentDrawingMode == UkeDrawingModeSegment) { //! 画线段
        CGMutablePathRef segmentPath = CGPathCreateMutable();
        CGPathMoveToPoint(segmentPath, NULL, _startPoint.x, _startPoint.y);
        CGPathAddLineToPoint(segmentPath, NULL, _currentPoint.x, _currentPoint.y);
        CGContextAddPath(context, segmentPath);
        CGContextDrawPath(context, kCGPathStroke);
        if (_state == UIGestureRecognizerStateEnded) {
            [self didEndDrawingOneStroke:segmentPath];
        }
        CGPathRelease(segmentPath);
    }
    else if (_currentDrawingMode == UkeDrawingModeEllipse) { //! 画椭圆
        CGMutablePathRef ellipsePath = CGPathCreateMutable();
        CGPathAddEllipseInRect(ellipsePath, NULL, CGRectMake(_startPoint.x, _startPoint.y, _currentPoint.x-_startPoint.x, _currentPoint.y-_startPoint.y));
        CGContextAddPath(context, ellipsePath);
        CGContextDrawPath(context, kCGPathStroke);
        if (_state == UIGestureRecognizerStateEnded) {
            [self didEndDrawingOneStroke:ellipsePath];
        }
        CGPathRelease(ellipsePath);
    }else if (_currentDrawingMode == UkeDrawingModeRectangle) { //! 画框
        CGMutablePathRef rectanglePath = CGPathCreateMutable();
        CGPathAddRect(rectanglePath, NULL, CGRectMake(_startPoint.x, _startPoint.y, _currentPoint.x-_startPoint.x, _currentPoint.y-_startPoint.y));
        CGContextAddPath(context, rectanglePath);
        CGContextDrawPath(context, kCGPathStroke);
        if (_state == UIGestureRecognizerStateEnded) {
            [self didEndDrawingOneStroke:rectanglePath];
        }
        CGPathRelease(rectanglePath);
    }else if (_currentDrawingMode == UkeDrawingModeEraser) { //! 画橡皮擦
        [[UIColor whiteColor] setStroke];
        
        if (_state == UIGestureRecognizerStateBegan) {
            CGPathMoveToPoint(_path, NULL, _currentPoint.x, _currentPoint.y);
        }else {
            CGPathAddLineToPoint(_path, NULL, _currentPoint.x, _currentPoint.y);
        }
        CGContextAddPath(context, _path);
        CGContextDrawPath(context, kCGPathStroke);
        if (_state == UIGestureRecognizerStateEnded) {
            [self didEndDrawingOneStroke:_path];
            CGPathRelease(_path);
            _path = NULL;
        }
    }
}

- (void)didEndDrawingOneStroke:(CGPathRef)path {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineCap = @"round";
    shapeLayer.lineJoin = @"round";
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    if (_currentDrawingMode == UkeDrawingModeEraser) {
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    shapeLayer.lineWidth = 4.0;
    shapeLayer.path = path;
    [self.layer addSublayer:shapeLayer];
    
    [_allStrokes addObject:shapeLayer];
}

- (CALayer *)currentPainting {
    return self.layer;
}

- (void)setCurrentPainting:(CALayer *)currentPainting {
    NSArray *sublayers = currentPainting.sublayers.copy;
    if (sublayers.count) {
        for (int i = 0; i < sublayers.count; i++) {
            CAShapeLayer *shapeLayer = sublayers[i];
            [self.layer addSublayer:shapeLayer];
            [self.allStrokes addObject:shapeLayer];
        }
    }
}

- (void)dealloc {
    NSLog(@"canvas销毁");
}

@end
