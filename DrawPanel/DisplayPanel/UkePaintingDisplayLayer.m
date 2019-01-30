//
//  UkePaintingDisplayLayer.m
//  DrawPanel
//
//  Created by liqian on 2019/1/29.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkePaintingDisplayLayer.h"
#import <UIKit/UIKit.h>
#import "UkePaintingLayer.h"

@interface UkePaintingDisplayLayer () <UkePaintingLayerDelegate>
//! 通过制定坐标点来绘画的layer
@property (nonatomic, strong) UkePaintingLayer *paintingLayer;
//! 作为线条容器的layer
@property (nonatomic, strong) CALayer *containerLayer;

//! 所有的笔画
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *allStrokes;

@property (nonatomic, assign) CGMutablePathRef path;

@end

@implementation UkePaintingDisplayLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        _allStrokes = [NSMutableArray array];
        
        _containerLayer = [[CALayer alloc] init];
        [self addSublayer:_containerLayer];

        _paintingLayer = [[UkePaintingLayer alloc] init];
        _paintingLayer.drawingDelegate = self;
        [self addSublayer:_paintingLayer];
        
        _path = CGPathCreateMutable();
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _containerLayer.frame = self.frame;
    _paintingLayer.frame = self.frame;
}

- (void)setCurrentDrawingMode:(UkeDrawingMode)currentDrawingMode {
    _currentDrawingMode = currentDrawingMode;
    _paintingLayer.currentDrawingMode = currentDrawingMode;
}

- (void)setDrawingState:(UkeDrawingState)drawingState {
    _drawingState = drawingState;
    _paintingLayer.drawingState = drawingState;
}

- (NSArray<CAShapeLayer *> *)currentStrokes {
    return _allStrokes.copy;
}

- (void)setCurrentStrokes:(NSArray<CAShapeLayer *> *)currentStrokes {
    [currentStrokes enumerateObjectsUsingBlock:^(CAShapeLayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.containerLayer addSublayer:obj];
        [self.allStrokes addObject:obj];
    }];
}

- (void)drawWithStartPoint:(CGPoint)startPoint
              currentPoint:(CGPoint)currentPoint {
    [_paintingLayer drawWithStartPoint:startPoint currentPoint:currentPoint];
}

#pragma mark - UkePaintingLayerDelegate
- (void)paintingLayer:(UkePaintingLayer *)layer didEndDrawingOneStrokeWithPath:(CGPathRef)path {
    if (_currentDrawingMode == UkeDrawingModeEraser) return;
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_containerLayer renderInContext:context];
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetMiterLimit(context, 2.0);
    CGContextSetLineWidth(context, 4.0);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddPath(context, path);
    
    if (_currentDrawingMode == UkeDrawingModeEraserRectangle) {
        CGContextSetLineWidth(context, 1.0);
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGContextFillPath(context);
    } else {
        CGContextSetBlendMode(context, kCGBlendModeNormal);
        CGContextStrokePath(context);
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    _containerLayer.contents = (id)image.CGImage;
    UIGraphicsEndImageContext();
    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.lineCap = @"round";
//    shapeLayer.lineJoin = @"round";
//    shapeLayer.frame = self.bounds;
//    shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer.strokeColor = [UIColor redColor].CGColor;
//    shapeLayer.lineWidth = 4.0;
//
//    if (_currentDrawingMode == UkeDrawingModeEraser) {
//        shapeLayer.lineWidth = 10.0;
//        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
//    }else if (_currentDrawingMode == UkeDrawingModeEraserRectangle) {
//        shapeLayer.lineWidth = 1.0;
//        shapeLayer.fillColor = nil;
//        shapeLayer.strokeColor = nil;
//    }
//
//    shapeLayer.path = path;
//
//    [self insertSublayer:shapeLayer below:_paintingLayer];
//
//    [_allStrokes addObject:shapeLayer];
}

- (void)paintingLayer:(UkePaintingLayer *)layer drawingOneStrokeWithPath:(CGPathRef)path {
    if (_currentDrawingMode != UkeDrawingModeEraser) return;
    
    UIGraphicsBeginImageContext(self.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
//    [_containerLayer renderInContext:context];
    
//    UIImage *originContens = [UIImage imageWithCGImage:(CGImageRef)_containerLayer.contents];
//    if (originContens) {
//        [originContens drawInRect:self.frame];
//    }
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetMiterLimit(context, 2.0);
    CGContextSetLineWidth(context, 10.0);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddPath(context, path);
    
    CGContextSetBlendMode(context, kCGBlendModeClear);
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    _containerLayer.contents = (id)image.CGImage;
    UIGraphicsEndImageContext();
}

- (void)paintingLayer:(UkePaintingLayer *)layer
    didEndDrawingText:(NSAttributedString *)attributedString
             position:(CGPoint)position {
    if (_currentDrawingMode != UkeDrawingModeWords) return;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    CGSize textSize = [attributedString boundingRectWithSize:CGSizeMake(375, 667) options:NSStringDrawingUsesLineFragmentOrigin context:NULL].size;
    
    CATextLayer *textLayer = [[CATextLayer alloc] init];
    textLayer.string = attributedString;
    textLayer.frame = CGRectMake(position.x, position.y, textSize.width, textSize.height);
    [shapeLayer addSublayer:textLayer];
    
    [self insertSublayer:shapeLayer below:_paintingLayer];
    
    [_allStrokes addObject:shapeLayer];
}

- (void)dealloc {
    NSLog(@"paintingDisplayLayer销毁");
}

@end
