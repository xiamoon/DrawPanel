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
@property (nonatomic, assign) UkeDrawingMode currentDrawingMode;
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

//! 角度转弧度
static double radianFromDegree(double degree) {
    return (degree/180.0*M_PI);
}

//! 弧度转角度
static double degreeFromRadian(double radian) {
    return (radian*180.0/M_PI);
}


- (void)drawWithStartPoint:(CGPoint)startPoint
              currentPoint:(CGPoint)currentPoint
              drawingState:(UkeDrawingState)drawingState
               drawingMode:(UkeDrawingMode)drawingMode {
    if (drawingMode == UkeDrawingModeBrush) { //! 画曲线
        if (drawingState == UkeDrawingStateStart) {
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
    }else if (drawingMode == UkeDrawingModeLine) { //! 画线段
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:startPoint];
        [path addLineToPoint:currentPoint];
        _currentPath = path;
        
        if (drawingState == UkeDrawingStateStart) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor redColor].CGColor;
            layer.frame = self.frame;
            [self.layer addSublayer:layer];
            
            _currentLayer = layer;
        }else if (drawingState == UkeDrawingStateEnd) {
            UkePathInfo *pathInfo = [[UkePathInfo alloc] init];
            pathInfo.path = _currentPath;
            pathInfo.blendMode = kCGBlendModeNormal;
            
            [_paths addObject:pathInfo];
        }
        
        _currentLayer.path = _currentPath.CGPath;
    }else if (drawingMode == UkeDrawingModeEllipse) { //! 画圆
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(startPoint.x, startPoint.y, currentPoint.x-startPoint.x, currentPoint.y-startPoint.y)];
        _currentPath = path;
        
        if (drawingState == UkeDrawingStateStart) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor redColor].CGColor;
            layer.frame = self.frame;
            [self.layer addSublayer:layer];
            
            _currentLayer = layer;
        }else if (drawingState == UkeDrawingStateEnd) {
            UkePathInfo *pathInfo = [[UkePathInfo alloc] init];
            pathInfo.path = _currentPath;
            pathInfo.blendMode = kCGBlendModeNormal;
            
            [_paths addObject:pathInfo];
        }
        
        _currentLayer.path = _currentPath.CGPath;
    }else if (drawingMode == UkeDrawingModeRectangle) { //! 画框
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(startPoint.x, startPoint.y, currentPoint.x-startPoint.x, currentPoint.y-startPoint.y)];
        _currentPath = path;
        
        if (drawingState == UkeDrawingStateStart) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor redColor].CGColor;
            layer.frame = self.frame;
            [self.layer addSublayer:layer];
            
            _currentLayer = layer;
        }else if (drawingState == UkeDrawingStateEnd) {
            UkePathInfo *pathInfo = [[UkePathInfo alloc] init];
            pathInfo.path = _currentPath;
            pathInfo.blendMode = kCGBlendModeNormal;
            
            [_paths addObject:pathInfo];
        }
        
        _currentLayer.path = _currentPath.CGPath;
    }else if (drawingMode == UkeDrawingModeEraser) { //! 画橡皮擦
        if (drawingState == UkeDrawingStateStart) {
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
    }else if (drawingMode == UkeDrawingModeEraserRectangle) { //! 框选删除
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(startPoint.x, startPoint.y, currentPoint.x-startPoint.x, currentPoint.y-startPoint.y)];
        _currentPath = path;
        
        if (drawingState == UkeDrawingStateStart) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
            layer.strokeColor = [UIColor clearColor].CGColor;
            layer.frame = self.frame;
            [self.layer addSublayer:layer];
            
            _currentLayer = layer;
        }else if (drawingState == UkeDrawingStateEnd) {
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
    }else if (drawingMode == UkeDrawingModeLineArrow) { // 画箭头
        if (drawingState == UkeDrawingStateStart) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor redColor].CGColor;
            layer.frame = self.frame;
            [self.layer addSublayer:layer];
            _currentLayer = layer;
        }
        
        while (_currentLayer.sublayers.count) {
            [_currentLayer.sublayers.lastObject removeFromSuperlayer];
        }
        
        CGFloat a = currentPoint.x-startPoint.x;
        CGFloat b = startPoint.y-currentPoint.y;
        CGFloat c = sqrt(a*a+b*b);
        CGFloat degreeB = degreeFromRadian(asin(fabs(b)/c));
        
        CGFloat degreeRotate = 0;
        if (a>0 && b>=0) { // 第一象限
            degreeRotate = 360.0-degreeB;
        }else if (a<=0 && b>=0) { // 第二象限
            degreeRotate = 180.0+degreeB;
        }else if (a<=0 && b<0) { // 第三象限
            degreeRotate = 180.0-degreeB;
        }else if (a>0 && b<=0) {// 第四象限
            degreeRotate = degreeB;
        }
        
        // 箭头夹角（小于90度）
        CGFloat arrowDegree = 60.0;
        // 一半箭头的夹角
        CGFloat singleArrowDegree = arrowDegree*0.5;
        // 线宽
        CGFloat lineWidth = 5.0;
        // n决定箭头两边的长短。n越大，箭头两边越长，反之，越短
        CGFloat n = lineWidth;
        // 线加上箭头总体宽度，即下面lineLayer的宽度
        CGFloat lineLayerWidth = 2*n+2*lineWidth*cos(radianFromDegree(singleArrowDegree)) +lineWidth;
        
        // 线段
        CAShapeLayer *lineLayer = [[CAShapeLayer alloc] init];
        lineLayer.anchorPoint = CGPointMake(0, 0.5);
        lineLayer.position = startPoint;
        lineLayer.backgroundColor = [UIColor clearColor].CGColor;
        lineLayer.lineWidth = lineWidth;
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        lineLayer.strokeColor = [UIColor redColor].CGColor;
        [_currentLayer addSublayer:lineLayer];
        
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        [linePath moveToPoint:CGPointMake(0, lineLayerWidth*0.5)];
        [linePath addLineToPoint:CGPointMake(c-0.5*lineWidth/sin(radianFromDegree(singleArrowDegree)), lineLayerWidth*0.5)];
        lineLayer.path = linePath.CGPath;
        
        // 箭头
        CAShapeLayer *arrowLayer = [[CAShapeLayer alloc] init];
        arrowLayer.bounds = CGRectMake(0, 0, lineLayerWidth, lineLayerWidth);
        arrowLayer.position = CGPointMake(c-lineLayerWidth*0.5, lineLayerWidth*0.5);
        arrowLayer.backgroundColor = [UIColor clearColor].CGColor;
        arrowLayer.lineWidth = lineWidth;
        arrowLayer.fillColor = [UIColor clearColor].CGColor;
        arrowLayer.strokeColor = [UIColor redColor].CGColor;
        [lineLayer addSublayer:arrowLayer];
        
        UIBezierPath *arrowPath = [UIBezierPath bezierPath];
        [arrowPath moveToPoint:CGPointMake(0.5*lineWidth*sin(radianFromDegree(singleArrowDegree)), 0.5*lineWidth*cos(radianFromDegree(singleArrowDegree)))];
        [arrowPath addLineToPoint:CGPointMake(lineLayerWidth-0.5*lineWidth/sin(radianFromDegree(singleArrowDegree)), lineLayerWidth*0.5)];
        [arrowPath addLineToPoint:CGPointMake(0.5*lineWidth*sin(radianFromDegree(singleArrowDegree)), lineLayerWidth-0.5*lineWidth*cos(radianFromDegree(singleArrowDegree)))];
        arrowLayer.path = arrowPath.CGPath;
        
        // 整体拉长和旋转
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        lineLayer.bounds = CGRectMake(0, 0, c, lineLayerWidth);
        [lineLayer setAffineTransform:CGAffineTransformMakeRotation(degreeRotate/180.0*M_PI)];
        [CATransaction commit];
    }else if (drawingMode == UkeDrawingModeTriangle) { // 画三角形
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(startPoint.x, startPoint.y)];
        [path addLineToPoint:CGPointMake(currentPoint.x, currentPoint.y)];
        [path addLineToPoint:CGPointMake(2*startPoint.x-currentPoint.x, currentPoint.y)];
        [path closePath];
        _currentPath = path;
        
        if (drawingState == UkeDrawingStateStart) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor redColor].CGColor;
            layer.frame = self.frame;
            [self.layer addSublayer:layer];
            
            _currentLayer = layer;
        }else if (drawingState == UkeDrawingStateEnd) {
            UkePathInfo *pathInfo = [[UkePathInfo alloc] init];
            pathInfo.path = _currentPath;
            pathInfo.blendMode = kCGBlendModeNormal;
            
            [_paths addObject:pathInfo];
        }
        
        _currentLayer.path = _currentPath.CGPath;
    }else if (drawingMode == UkeDrawingModeStar) { // 五角星
        // 设O为圆心，A（上顶点）、B、C、D、E为外点(顺时针方向)，F（右上角内点）、G、H、I、J为内点（顺时针方向）。每个外角为36度
        // 大圆圆心
        CGPoint O = startPoint;
        // 大圆半径
        CGFloat radius_max = fabs(2*(currentPoint.x-O.x));
        
        CGPoint A = CGPointMake(O.x, O.y-radius_max);
        CGPoint B = CGPointMake(O.x+radius_max*cos(radianFromDegree(18.0)), O.y-radius_max*sin(radianFromDegree(18.0)));
        CGPoint C = CGPointMake(O.x+radius_max*sin(radianFromDegree(36.0)), O.y+radius_max*cos(radianFromDegree(36.0)));
        CGPoint D = CGPointMake(O.x-radius_max*sin(radianFromDegree(36.0)), C.y);
        CGPoint E = CGPointMake(O.x-radius_max*cos(radianFromDegree(18.0)), B.y);
        
        // 小圆半径
        CGFloat radius_min = radius_max*sin(radianFromDegree(18.0))/cos(radianFromDegree(36.0));
        
        CGPoint F = CGPointMake(O.x+radius_max*sin(radianFromDegree(18.0))*tan(radianFromDegree(36.0)), B.y);
        CGPoint G = CGPointMake(O.x+radius_min*cos(radianFromDegree(18.0)), O.y+radius_min*sin(radianFromDegree(18.0)));
        CGPoint H = CGPointMake(O.x, O.y+radius_min);
        CGPoint I = CGPointMake(O.x-radius_min*cos(radianFromDegree(18.0)), G.y);
        CGPoint J = CGPointMake(O.x-radius_max*sin(radianFromDegree(18.0))*tan(radianFromDegree(36.0)), F.y);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:A];
        [path addLineToPoint:F];
        [path addLineToPoint:B];
        [path addLineToPoint:G];
        [path addLineToPoint:C];
        [path addLineToPoint:H];
        [path addLineToPoint:D];
        [path addLineToPoint:I];
        [path addLineToPoint:E];
        [path addLineToPoint:J];
        [path addLineToPoint:A];

        _currentPath = path;
        
        if (drawingState == UkeDrawingStateStart) {
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.strokeColor = [UIColor redColor].CGColor;
            layer.fillRule = @"even-odd";
            layer.frame = self.frame;
            [self.layer addSublayer:layer];
            
            _currentLayer = layer;
        }else if (drawingState == UkeDrawingStateEnd) {
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
    
    if (startPoint && points.count == 0) {
        state = UkeDrawingStateStart;
    }
    
    if (startPoint) {
        _startPoint = startPoint.CGPointValue;
    }
    
    if (!_currentLayer && _currentDrawingMode != UkeDrawingModeEraser) {
        [self createLayerWithWidth:width color:color isEraserRectangle:(_currentDrawingMode == UkeDrawingModeEraserRectangle)];
    }
    
    if (_currentDrawingMode == UkeDrawingModeBrush) { // 线
        if (!_currentPath) {
            _currentPath = [UIBezierPath bezierPath];
            [_currentPath moveToPoint:_startPoint];
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
        if (points.count == 2) {
            CGPoint point1 = [points[0] CGPointValue];
            CGPoint point2 = [points[1] CGPointValue];
            
            _currentPath = [UIBezierPath bezierPath];
            [_currentPath moveToPoint:CGPointMake(_startPoint.x, _startPoint.y)];
            [_currentPath addLineToPoint:CGPointMake(point1.x, point1.y)];
            [_currentPath addLineToPoint:CGPointMake(point2.x, point2.y)];
            [_currentPath closePath];
        }
    }else if (_currentDrawingMode == UkeDrawingModeStar) { // 五角星
        [self drawStarWithStartPoint:_startPoint otherPoints:points];
    }else if (_currentDrawingMode == UkeDrawingModeLineArrow) { // 箭头
        [self drawLineArrowWithStartPoint:_startPoint otherPoints:points width:width color:color];
    }else if (_currentDrawingMode == UkeDrawingModeEraser) { // 橡皮擦
        if (!_currentPath) {
            _currentPath = [UIBezierPath bezierPath];
            [_currentPath moveToPoint:_startPoint];
        }
        
        if (points.count) {
            for (int i = 0; i < points.count; i ++) {
                CGPoint currentPoint = [points[i] CGPointValue];
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
        }
    }else if (_currentDrawingMode == UkeDrawingModeEraserRectangle) { // 框选删除
        if (points.count) {
            for (int i = 0; i < points.count; i ++) {
                CGPoint currentPoint = [points[i] CGPointValue];
                _currentPath = [UIBezierPath bezierPathWithRect:CGRectMake(_startPoint.x, _startPoint.y, currentPoint.x-_startPoint.x, currentPoint.y-_startPoint.y)];
            }
        }
        
        if (state == UkeDrawingStateEnd) {
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
        }
    }
    
    
    if (_currentDrawingMode != UkeDrawingModeEraser) {
        _currentLayer.path = _currentPath.CGPath;
    }
    
    if (state == UkeDrawingStateEnd) {
        _currentLayer = nil;
        _currentPath = nil;
    }
}

// 画五角星
- (void)drawStarWithStartPoint:(CGPoint)startPoint
                        otherPoints:(NSArray<NSValue *> *)points {
    // 设O为圆心，A（上顶点）、B、C、D、E为外点(顺时针方向)，F（右上角内点）、G、H、I、J为内点（顺时针方向）。每个外角为36度
    // 大圆圆心
    CGPoint O = startPoint;
    // 大圆半径
    if (points.count == 0) return;
    
    for (NSValue *value in points) {
        CGPoint currentPoint = value.CGPointValue;
        CGFloat radius_max = fabs(2*(currentPoint.x-O.x));
        
        CGPoint A = CGPointMake(O.x, O.y-radius_max);
        CGPoint B = CGPointMake(O.x+radius_max*cos(radianFromDegree(18.0)), O.y-radius_max*sin(radianFromDegree(18.0)));
        CGPoint C = CGPointMake(O.x+radius_max*sin(radianFromDegree(36.0)), O.y+radius_max*cos(radianFromDegree(36.0)));
        CGPoint D = CGPointMake(O.x-radius_max*sin(radianFromDegree(36.0)), C.y);
        CGPoint E = CGPointMake(O.x-radius_max*cos(radianFromDegree(18.0)), B.y);
        
        // 小圆半径
        CGFloat radius_min = radius_max*sin(radianFromDegree(18.0))/cos(radianFromDegree(36.0));
        
        CGPoint F = CGPointMake(O.x+radius_max*sin(radianFromDegree(18.0))*tan(radianFromDegree(36.0)), B.y);
        CGPoint G = CGPointMake(O.x+radius_min*cos(radianFromDegree(18.0)), O.y+radius_min*sin(radianFromDegree(18.0)));
        CGPoint H = CGPointMake(O.x, O.y+radius_min);
        CGPoint I = CGPointMake(O.x-radius_min*cos(radianFromDegree(18.0)), G.y);
        CGPoint J = CGPointMake(O.x-radius_max*sin(radianFromDegree(18.0))*tan(radianFromDegree(36.0)), F.y);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:A];
        [path addLineToPoint:F];
        [path addLineToPoint:B];
        [path addLineToPoint:G];
        [path addLineToPoint:C];
        [path addLineToPoint:H];
        [path addLineToPoint:D];
        [path addLineToPoint:I];
        [path addLineToPoint:E];
        [path addLineToPoint:J];
        [path addLineToPoint:A];
        
        _currentPath = path;
    }
}

// 画箭头
- (void)drawLineArrowWithStartPoint:(CGPoint)startPoint
                 otherPoints:(NSArray<NSValue *> *)points
                       width:(CGFloat)width
                       color:(UIColor *)color {
    if (points.count != 1) {
        return;
    }
    
    while (_currentLayer.sublayers.count) {
        [_currentLayer.sublayers.lastObject removeFromSuperlayer];
    }
    
    CGPoint endPoint = [points.lastObject CGPointValue];
    
    CGFloat a = endPoint.x-startPoint.x;
    CGFloat b = startPoint.y-endPoint.y;
    CGFloat c = sqrt(a*a+b*b);
    CGFloat degreeB = degreeFromRadian(asin(fabs(b)/c));
    
    CGFloat degreeRotate = 0;
    if (a>0 && b>=0) { // 第一象限
        degreeRotate = 360.0-degreeB;
    }else if (a<=0 && b>=0) { // 第二象限
        degreeRotate = 180.0+degreeB;
    }else if (a<=0 && b<0) { // 第三象限
        degreeRotate = 180.0-degreeB;
    }else if (a>0 && b<=0) {// 第四象限
        degreeRotate = degreeB;
    }
    
    // 箭头夹角（小于90度）
    CGFloat arrowDegree = 60.0;
    // 一半箭头的夹角
    CGFloat singleArrowDegree = arrowDegree*0.5;
    // 线宽
    CGFloat lineWidth = width;
    // n决定箭头两边的长短。n越大，箭头两边越长，反之，越短
    CGFloat n = lineWidth*0.8;
    // 线加上箭头总体宽度，即下面lineLayer的宽度
    CGFloat lineLayerWidth = 2*n+2*lineWidth*cos(radianFromDegree(singleArrowDegree)) +lineWidth;
    
    // 线段
    CAShapeLayer *lineLayer = [[CAShapeLayer alloc] init];
    lineLayer.anchorPoint = CGPointMake(0, 0.5);
    lineLayer.position = startPoint;
    lineLayer.backgroundColor = [UIColor clearColor].CGColor;
    lineLayer.lineWidth = lineWidth;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.strokeColor = color.CGColor;
    [_currentLayer addSublayer:lineLayer];
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointMake(0, lineLayerWidth*0.5)];
    [linePath addLineToPoint:CGPointMake(c-0.5*lineWidth/sin(radianFromDegree(singleArrowDegree)), lineLayerWidth*0.5)];
    lineLayer.path = linePath.CGPath;
    
    // 箭头
    CAShapeLayer *arrowLayer = [[CAShapeLayer alloc] init];
    arrowLayer.bounds = CGRectMake(0, 0, lineLayerWidth, lineLayerWidth);
    arrowLayer.position = CGPointMake(c-lineLayerWidth*0.5, lineLayerWidth*0.5);
    arrowLayer.backgroundColor = [UIColor clearColor].CGColor;
    arrowLayer.lineWidth = lineWidth;
    arrowLayer.fillColor = color.CGColor;
    arrowLayer.strokeColor = color.CGColor;
    [lineLayer addSublayer:arrowLayer];
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    [arrowPath moveToPoint:CGPointMake(0.5*lineWidth*sin(radianFromDegree(singleArrowDegree)), 0.5*lineWidth*cos(radianFromDegree(singleArrowDegree)))];
    [arrowPath addLineToPoint:CGPointMake(lineLayerWidth-0.5*lineWidth/sin(radianFromDegree(singleArrowDegree)), lineLayerWidth*0.5)];
    [arrowPath addLineToPoint:CGPointMake(0.5*lineWidth*sin(radianFromDegree(singleArrowDegree)), lineLayerWidth-0.5*lineWidth*cos(radianFromDegree(singleArrowDegree)))];
    [arrowPath closePath];
    arrowLayer.path = arrowPath.CGPath;
    
    // 整体拉长和旋转
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    lineLayer.bounds = CGRectMake(0, 0, c, lineLayerWidth);
    [lineLayer setAffineTransform:CGAffineTransformMakeRotation(degreeRotate/180.0*M_PI)];
    [CATransaction commit];
}

// 画文字
- (void)drawTextWithText:(NSString *)text
              startPoint:(NSValue *)startPoint
                   fontSize:(CGFloat)fontSize
                   color:(UIColor *)color
            drawingState:(UkeDrawingState)state {
    if (![text isKindOfClass:[NSString class]] || !text.length) {
        return;
    }
    
    CGPoint point = startPoint.CGPointValue;
    
    CATextLayer *textLayer = [[CATextLayer alloc] init];
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:text];
    [attri addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, text.length)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold] range:NSMakeRange(0, text.length)];
    CGSize textSize = [attri boundingRectWithSize:self.bounds.size options:0 context:NULL].size;
    textLayer.frame = CGRectMake(point.x, point.y, textSize.width, textSize.height);
    textLayer.string = attri;
    [self.layer addSublayer:textLayer];
}

- (void)createLayerWithWidth:(CGFloat)width
                                      color:(UIColor *)color
           isEraserRectangle:(BOOL)isEraserRectangle {
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.backgroundColor = [UIColor clearColor].CGColor;
    if (isEraserRectangle) {
        layer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
        layer.strokeColor = [UIColor clearColor].CGColor;
    }else {
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = color.CGColor;
    }
    layer.frame = self.frame;
    layer.lineWidth = width;
    [self.layer addSublayer:layer];
    
    _currentLayer = layer;
}

- (void)dealloc {
    NSLog(@"paintingView销毁");
}
    
@end
