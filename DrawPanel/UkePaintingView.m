//
//  UkePaintingView.m
//  DrawPanel
//
//  Created by liqian on 2019/1/31.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkePaintingView.h"
#import "UkePathInfo.h"

@interface UkePaintingView ()
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, strong) UIBezierPath *currentPath;
@property (nonatomic, strong) UkePathInfo *currentPathInfo;
@property (nonatomic, strong) CAShapeLayer *currentLayer;
@property (nonatomic, strong) NSMutableArray<UkePathInfo *> *paths;
@end

@implementation UkePaintingView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _paths = [NSMutableArray array];
    }
    return self;
}

- (UIImage *)currentContents {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)setCurrentContents:(UIImage *)currentContents {
    self.layer.contents = (id)currentContents.CGImage;
}

- (void)drawWithStartPoint:(CGPoint)startPoint currentPoint:(CGPoint)currentPoint {
    if (_currentDrawingMode == UkeDrawingModeBrush) { //! 画曲线
        if (_drawingState == UkeDrawingStateStart) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor redColor].CGColor;
            layer.frame = self.frame;
            [self.layer addSublayer:layer];
            
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:startPoint];
            
            UkePathInfo *pathInfo = [[UkePathInfo alloc] init];
            pathInfo.path = path;
            pathInfo.blendMode = kCGBlendModeNormal;
            
            _currentLayer = layer;
            _currentPath = path;
            [_paths addObject:pathInfo];
        }else {
            [_currentPath addLineToPoint:currentPoint];
            _currentLayer.path = _currentPath.CGPath;
        }
    }else if (_currentDrawingMode == UkeDrawingModeLine) { //! 画线段
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:startPoint];
        [path addLineToPoint:currentPoint];
        _currentPath = path;
        
        if (_drawingState == UkeDrawingStateStart) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor redColor].CGColor;
            layer.frame = self.frame;
            [self.layer addSublayer:layer];
            
            _currentLayer = layer;
        }else if (_drawingState == UkeDrawingStateEnd) {
            UkePathInfo *pathInfo = [[UkePathInfo alloc] init];
            pathInfo.path = _currentPath;
            pathInfo.blendMode = kCGBlendModeNormal;
            
            [_paths addObject:pathInfo];
        }
        
        _currentLayer.path = _currentPath.CGPath;
    }else if (_currentDrawingMode == UkeDrawingModeEllipse) { //! 画圆
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(startPoint.x, startPoint.y, currentPoint.x-startPoint.x, currentPoint.y-startPoint.y)];
        _currentPath = path;
        
        if (_drawingState == UkeDrawingStateStart) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor redColor].CGColor;
            layer.frame = self.frame;
            [self.layer addSublayer:layer];
            
            _currentLayer = layer;
        }else if (_drawingState == UkeDrawingStateEnd) {
            UkePathInfo *pathInfo = [[UkePathInfo alloc] init];
            pathInfo.path = _currentPath;
            pathInfo.blendMode = kCGBlendModeNormal;
            
            [_paths addObject:pathInfo];
        }
        
        _currentLayer.path = _currentPath.CGPath;
    }else if (_currentDrawingMode == UkeDrawingModeRectangle) { //! 画框
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(startPoint.x, startPoint.y, currentPoint.x-startPoint.x, currentPoint.y-startPoint.y)];
        _currentPath = path;
        
        if (_drawingState == UkeDrawingStateStart) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor redColor].CGColor;
            layer.frame = self.frame;
            [self.layer addSublayer:layer];
            
            _currentLayer = layer;
        }else if (_drawingState == UkeDrawingStateEnd) {
            UkePathInfo *pathInfo = [[UkePathInfo alloc] init];
            pathInfo.path = _currentPath;
            pathInfo.blendMode = kCGBlendModeNormal;
            
            [_paths addObject:pathInfo];
        }
        
        _currentLayer.path = _currentPath.CGPath;
    }else if (_currentDrawingMode == UkeDrawingModeEraser) { //! 画橡皮擦
        if (_drawingState == UkeDrawingStateStart) {
            UIBezierPath *erasePath = [UIBezierPath bezierPath];
            [erasePath moveToPoint:startPoint];
            
            UkePathInfo *pathInfo = [[UkePathInfo alloc] init];
            pathInfo.path = erasePath;
            pathInfo.blendMode = kCGBlendModeClear;
            
            _currentPath = erasePath;
            [_paths addObject:pathInfo];
        }else {
            [_currentPath addLineToPoint:currentPoint];
            
            UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [self.layer renderInContext:context];

            while (self.layer.sublayers.count) {
                [self.layer.sublayers.lastObject removeFromSuperlayer];
            }

            CGContextSetLineWidth(context, 10);
            CGContextSetBlendMode(context, kCGBlendModeClear);
            CGContextAddPath(context, _currentPath.CGPath);
            CGContextDrawPath(context, kCGPathStroke);
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            self.layer.contents = (id)image.CGImage;
            UIGraphicsEndImageContext();
        }
    }else if (_currentDrawingMode == UkeDrawingModeEraserRectangle) { //! 框选删除
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(startPoint.x, startPoint.y, currentPoint.x-startPoint.x, currentPoint.y-startPoint.y)];
        _currentPath = path;
        
        if (_drawingState == UkeDrawingStateStart) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
            layer.strokeColor = [UIColor clearColor].CGColor;
            layer.frame = self.frame;
            [self.layer addSublayer:layer];
            
            _currentLayer = layer;
        }else if (_drawingState == UkeDrawingStateEnd) {
            UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
            CGContextRef context = UIGraphicsGetCurrentContext();
            [self.layer renderInContext:context];
            
            while (self.layer.sublayers.count) {
                [self.layer.sublayers.lastObject removeFromSuperlayer];
            }
            
            CGContextSetLineWidth(context, 1.0);
            CGContextSetBlendMode(context, kCGBlendModeClear);
            CGContextAddPath(context, _currentPath.CGPath);
            CGContextDrawPath(context, kCGPathFill);
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            self.layer.contents = (id)image.CGImage;
            UIGraphicsEndImageContext();
            
            UkePathInfo *pathInfo = [[UkePathInfo alloc] init];
            pathInfo.path = _currentPath;
            pathInfo.blendMode = kCGBlendModeClear;
            
            [_paths addObject:pathInfo];
        }
        _currentLayer.path = _currentPath.CGPath;
    }else if (_currentDrawingMode == UkeDrawingModeEraserArrow) {
        
    }else if (_currentDrawingMode == UkeDrawingModeTriangle) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
        [path addLineToPoint:CGPointMake(currentPoint.x, currentPoint.y)];
        [path addLineToPoint:CGPointMake(2*startPoint.x-currentPoint.x, currentPoint.y)];
        [path closePath];
        _currentPath = path;
        
        if (_drawingState == UkeDrawingStateStart) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor redColor].CGColor;
            layer.frame = self.frame;
            [self.layer addSublayer:layer];
            
            _currentLayer = layer;
        }else if (_drawingState == UkeDrawingStateEnd) {
            UkePathInfo *pathInfo = [[UkePathInfo alloc] init];
            pathInfo.path = _currentPath;
            pathInfo.blendMode = kCGBlendModeNormal;
            
            [_paths addObject:pathInfo];
        }
        
        _currentLayer.path = _currentPath.CGPath;
    }
}


- (void)drawWithMode:(UkeDrawingMode)drawingMode
          startPoint:(NSValue *)startPoint
         otherPoints:(NSArray<NSValue *> *)points
               width:(CGFloat)width
               color:(UIColor *)color
        drawingState:(UkeDrawingState)state {
    if (drawingMode != UkeDrawingModeUnKnown) {
        _currentDrawingMode = drawingMode;
    }
    
    _drawingState = state;
    if (startPoint && points.count == 0) {
        _drawingState = UkeDrawingStateStart;
    }
    
    if (startPoint) {
        _startPoint = startPoint.CGPointValue;
    }
    
    if (!_currentLayer) {
        [self createLayerWithWidth:width color:color startPoint:startPoint];
    }
    
    if (_currentDrawingMode == UkeDrawingModeBrush) { // 线
        if (!_currentPath) {
            _currentPath = [UIBezierPath bezierPath];
            [_currentPath moveToPoint:startPoint.CGPointValue];
        }
        
        if (points.count) {
            for (int i = 0; i < points.count; i ++) {
                CGPoint currentPoint = [points[i] CGPointValue];
                [_currentPath addLineToPoint:currentPoint];
            }
        }
    }else if (_currentDrawingMode == UkeDrawingModeEllipse || // 椭圆
              _currentDrawingMode == UkeDrawingModeRectangle || // 矩形框
              _currentDrawingMode == UkeDrawingModeLine) { // 线段
        if (points.count) {
            for (int i = 0; i < points.count; i ++) {
                CGPoint currentPoint = [points[i] CGPointValue];
                if (_currentDrawingMode == UkeDrawingModeEllipse) {
                    _currentPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_startPoint.x, _startPoint.y, currentPoint.x-_startPoint.x, currentPoint.y-_startPoint.y)];
                }else if (_currentDrawingMode == UkeDrawingModeRectangle) {
                    _currentPath = [UIBezierPath bezierPathWithRect:CGRectMake(_startPoint.x, _startPoint.y, currentPoint.x-_startPoint.x, currentPoint.y-_startPoint.y)];
                }else if (_currentDrawingMode == UkeDrawingModeLine) {
                    _currentPath = [UIBezierPath bezierPath];
                    [_currentPath moveToPoint:_startPoint];
                    [_currentPath addLineToPoint:currentPoint];
                }
            }
        }
    }else if (_currentDrawingMode == UkeDrawingModeTriangle) { // 三角形
        CGPoint point1 = [points[0] CGPointValue];
        CGPoint point2 = [points[1] CGPointValue];

        _currentPath = [UIBezierPath bezierPath];
        [_currentPath moveToPoint:CGPointMake(_startPoint.x, _startPoint.y)];
        [_currentPath addLineToPoint:CGPointMake(point1.x, point1.y)];
        [_currentPath addLineToPoint:CGPointMake(point2.x, point2.y)];
        [_currentPath closePath];
    }
    
    _currentLayer.path = _currentPath.CGPath;
    
    if (_drawingState == UkeDrawingStateEnd) {
        _currentLayer = nil;
        _currentPath = nil;
    }
}


- (void)createLayerWithWidth:(CGFloat)width
                                      color:(UIColor *)color
                                 startPoint:(NSValue *)startPoint {
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = color.CGColor;
    layer.frame = self.frame;
    layer.lineWidth = width;
    [self.layer addSublayer:layer];
    
    _currentLayer = layer;
//
//    UkePathInfo *pathInfo = [[UkePathInfo alloc] init];
//    pathInfo.lineWidth = width;
//    pathInfo.lineColor = color;
//    pathInfo.blendMode = kCGBlendModeNormal;
//    [_paths addObject:pathInfo];
//
//    _currentPathInfo = pathInfo;
}
    
@end
