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
@property (nonatomic, strong) UIBezierPath *currentPath;
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
    if (_currentDrawingMode == UkeDrawingModeLine) { //! 画曲线
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
    }else if (_currentDrawingMode == UkeDrawingModeSegment) { //! 画线段
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

- (void)setPoints:(CGPoint *)points {
    
}
    
@end
