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
@end

@implementation UkePaintingDisplayLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        _allStrokes = [NSMutableArray array];

        _paintingLayer = [[UkePaintingLayer alloc] init];
        _paintingLayer.drawingDelegate = self;
        [self addSublayer:_paintingLayer];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
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
        shapeLayer.fillColor = [UIColor whiteColor].CGColor;
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    }
    
    shapeLayer.path = path;
    
    [self insertSublayer:shapeLayer below:_paintingLayer];
    
    [_allStrokes addObject:shapeLayer];
}

- (void)dealloc {
    NSLog(@"paintingDisplayLayer销毁");
}

@end
