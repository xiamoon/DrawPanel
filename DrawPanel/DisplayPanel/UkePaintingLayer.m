//
//  UkePaintingLayer.m
//  DrawPanel
//
//  Created by liqian on 2019/1/28.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkePaintingLayer.h"
#import <UIKit/UIKit.h>

@interface UkePaintingLayer ()
//! 落笔的第一点
@property (nonatomic, assign) CGPoint startPoint;
//! 当前点
@property (nonatomic, assign) CGPoint currentPoint;
//! 画笔路径
@property (nonatomic, assign) CGMutablePathRef path;
@end

@implementation UkePaintingLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor].CGColor;
    }
    return self;
}

- (void)drawWithStartPoint:(CGPoint)startPoint currentPoint:(CGPoint)currentPoint {
    _startPoint = startPoint;
    _currentPoint = currentPoint;
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    if (CGPointEqualToPoint(_currentPoint, CGPointZero)) return;
    
    CGContextRef context = ctx;
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetMiterLimit(context, 2.0);
    CGContextSetLineWidth(context, 4.0);
    
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    
    if (_path == NULL) {
        _path = CGPathCreateMutable();
    }
    
    if (_currentDrawingMode == UkeDrawingModeLine) { //! 画线
        if (_drawingState == UkeDrawingStateStart) {
            CGPathMoveToPoint(_path, NULL, _startPoint.x, _startPoint.y);
        }else {
            CGPathAddLineToPoint(_path, NULL, _currentPoint.x, _currentPoint.y);
        }
        CGContextAddPath(context, _path);
        CGContextDrawPath(context, kCGPathStroke);
        if (_drawingState == UkeDrawingStateEnd) {
            [self.drawingDelegate paintingLayer:self didEndDrawingOneStrokeWithPath:_path];
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
        if (_drawingState == UkeDrawingStateEnd) {
            [self.drawingDelegate paintingLayer:self didEndDrawingOneStrokeWithPath:segmentPath];
        }
        CGPathRelease(segmentPath);
    }
    else if (_currentDrawingMode == UkeDrawingModeEllipse) { //! 画椭圆
        CGMutablePathRef ellipsePath = CGPathCreateMutable();
        CGPathAddEllipseInRect(ellipsePath, NULL, CGRectMake(_startPoint.x, _startPoint.y, _currentPoint.x-_startPoint.x, _currentPoint.y-_startPoint.y));
        CGContextAddPath(context, ellipsePath);
        CGContextDrawPath(context, kCGPathStroke);
        if (_drawingState == UkeDrawingStateEnd) {
            [self.drawingDelegate paintingLayer:self didEndDrawingOneStrokeWithPath:ellipsePath];
        }
        CGPathRelease(ellipsePath);
    }else if (_currentDrawingMode == UkeDrawingModeRectangle) { //! 画框
        CGMutablePathRef rectanglePath = CGPathCreateMutable();
        CGPathAddRect(rectanglePath, NULL, CGRectMake(_startPoint.x, _startPoint.y, _currentPoint.x-_startPoint.x, _currentPoint.y-_startPoint.y));
        CGContextAddPath(context, rectanglePath);
        CGContextDrawPath(context, kCGPathStroke);
        if (_drawingState == UkeDrawingStateEnd) {
            [self.drawingDelegate paintingLayer:self didEndDrawingOneStrokeWithPath:rectanglePath];
        }
        CGPathRelease(rectanglePath);
    }else if (_currentDrawingMode == UkeDrawingModeEraser) { //! 画橡皮擦
        CGContextSetLineWidth(context, 10.0);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);

        if (_drawingState == UkeDrawingStateStart) {
            CGPathMoveToPoint(_path, NULL, _currentPoint.x, _currentPoint.y);
        }else {
            CGPathAddLineToPoint(_path, NULL, _currentPoint.x, _currentPoint.y);
        }
        CGContextAddPath(context, _path);
        CGContextDrawPath(context, kCGPathStroke);
        if (_drawingState == UkeDrawingStateEnd) {
            [self.drawingDelegate paintingLayer:self didEndDrawingOneStrokeWithPath:_path];
            CGPathRelease(_path);
            _path = NULL;
        }
    }else if (_currentDrawingMode == UkeDrawingModeEraserRectangle) { //! 框选删除
        CGContextSetLineWidth(context, 1.0);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);

        CGMutablePathRef rectanglePath = CGPathCreateMutable();
        CGPathAddRect(rectanglePath, NULL, CGRectMake(_startPoint.x, _startPoint.y, _currentPoint.x-_startPoint.x, _currentPoint.y-_startPoint.y));
        CGContextAddPath(context, rectanglePath);
        CGContextDrawPath(context, kCGPathFill);
        if (_drawingState == UkeDrawingStateEnd) {
            [self.drawingDelegate paintingLayer:self didEndDrawingOneStrokeWithPath:rectanglePath];
        }
        CGPathRelease(rectanglePath);
    }
}

- (void)dealloc {
    NSLog(@"paintingLayer销毁");
}

@end
