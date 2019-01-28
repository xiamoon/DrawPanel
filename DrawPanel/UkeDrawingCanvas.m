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
@property (nonatomic, assign) CGPoint firstPoint;
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
        _firstPoint = point;
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
        }else if (_state == UIGestureRecognizerStateChanged) {
            CGPathAddLineToPoint(_path, NULL, _currentPoint.x, _currentPoint.y);
        }else if (_state == UIGestureRecognizerStateEnded) {
            CGPathAddLineToPoint(_path, NULL, _currentPoint.x, _currentPoint.y);
        }
        CGContextAddPath(context, _path);
        CGContextDrawPath(context, kCGPathStroke);
        if (_state == UIGestureRecognizerStateEnded) {
            [self didEndDrawingOneStroke:_path];
            CGPathRelease(_path);
            _path = NULL;
        }
    }else if (_currentDrawingMode == UkeDrawingModeEllipse) { //! 画椭圆
        CGMutablePathRef ellipsePath = CGPathCreateMutable();
        CGPathAddEllipseInRect(ellipsePath, NULL, CGRectMake(_firstPoint.x, _firstPoint.y, _currentPoint.x-_firstPoint.x, _currentPoint.y-_firstPoint.y));
        CGContextAddPath(context, ellipsePath);
        CGContextDrawPath(context, kCGPathStroke);
        if (_state == UIGestureRecognizerStateEnded) {
            [self didEndDrawingOneStroke:ellipsePath];
        }
        CGPathRelease(ellipsePath);
    }
}

- (void)didEndDrawingOneStroke:(CGPathRef)path {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineCap = @"round";
    shapeLayer.lineJoin = @"round";
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 4.0;
    shapeLayer.path = path;
    [self.layer addSublayer:shapeLayer];
    
    [_allStrokes addObject:shapeLayer];
}

- (CALayer *)currentPainting {
    return self.layer;
}

- (void)setCurrentPainting:(CALayer *)currentPainting {
    NSArray *sublayers = currentPainting.sublayers;
    if (sublayers.count) {
        [sublayers enumerateObjectsUsingBlock:^(CAShapeLayer *shapeLayer, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.layer addSublayer:shapeLayer];
            [self.allStrokes addObject:shapeLayer];
        }];
    }
}

- (void)dealloc {
    NSLog(@"canvas销毁");
}

@end
