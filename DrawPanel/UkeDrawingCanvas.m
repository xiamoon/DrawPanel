//
//  UkeDrawingCanvas.m
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkeDrawingCanvas.h"

@interface UkeDrawingCanvas ()
@property (nonatomic, assign) CGMutablePathRef path;
@property (nonatomic, assign) UIGestureRecognizerState state;
@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint currentPoint;
@end

@implementation UkeDrawingCanvas

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
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
    }else if (_currentDrawingMode == UkeDrawingModeEllipse) { //! 画
        CGMutablePathRef ellipsePath = CGPathCreateMutable();
        CGPathAddEllipseInRect(ellipsePath, NULL, CGRectMake(_firstPoint.x, _firstPoint.y, _currentPoint.x-_firstPoint.x, _currentPoint.y-_firstPoint.y));
        CGContextAddPath(context, ellipsePath);
        CGContextDrawPath(context, kCGPathStroke);
        if (_state == UIGestureRecognizerStateEnded) {
            [_delegate canvas:self didEndDrawing:ellipsePath];
        }
//        CGPathRelease(ellipsePath);
    }
}

- (void)dealloc {
    NSLog(@"canvas销毁");
}

@end
