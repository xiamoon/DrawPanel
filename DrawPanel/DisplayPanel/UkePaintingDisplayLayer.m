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
//! 所有的笔画
@property (nonatomic, strong) NSMutableArray<CAShapeLayer *> *allStrokes;

@property (nonatomic, assign) CGMutablePathRef allPaths;
@property (nonatomic, strong) CALayer *containerLayer;

@end

@implementation UkePaintingDisplayLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        _allStrokes = [NSMutableArray array];
        
        _allPaths = CGPathCreateMutable();
        _containerLayer = [[CALayer alloc] init];
        [self addSublayer:_containerLayer];
        
        _paintingLayer = [[UkePaintingLayer alloc] init];
        _paintingLayer.drawingDelegate = self;
        [self addSublayer:_paintingLayer];
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
        [self insertSublayer:obj below:self.paintingLayer];
        [self.allStrokes addObject:obj];
    }];
}

- (void)drawWithStartPoint:(CGPoint)startPoint
              currentPoint:(CGPoint)currentPoint {
    [_paintingLayer drawWithStartPoint:startPoint currentPoint:currentPoint];
}

#pragma mark - UkePaintingLayerDelegate
- (void)paintingLayer:(UkePaintingLayer *)layer didEndDrawingOneStrokeWithPath:(CGPathRef)path {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineCap = @"round";
    shapeLayer.lineJoin = @"round";
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 4.0;

    if (_currentDrawingMode == UkeDrawingModeEraser) {
        shapeLayer.lineWidth = 10.0;
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    }else if (_currentDrawingMode == UkeDrawingModeEraserRectangle) {
        shapeLayer.lineWidth = 1.0;
        shapeLayer.fillColor = nil;
        shapeLayer.strokeColor = nil;
    }

    shapeLayer.path = path;

    [self insertSublayer:shapeLayer below:_paintingLayer];

    [_allStrokes addObject:shapeLayer];
//
//    CGPathAddPath(_allPaths, NULL, path);
//
//    UIGraphicsBeginImageContext(self.frame.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    if (_currentDrawingMode == UkeDrawingModeEraser) {
//
//    }else {
//
//    }
//
//
//    CGContextSetLineWidth(context, 4.0);
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    CGContextAddPath(context, _allPaths);
//    CGContextDrawPath(context, kCGPathStroke);
//
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    _containerLayer.contents = (id)image.CGImage;
//    UIGraphicsEndImageContext();
}

- (void)paintingLayer:(UkePaintingLayer *)layer
    didEndDrawingText:(NSAttributedString *)attributedString
             position:(CGPoint)position {
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
