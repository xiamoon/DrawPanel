//
//  UkeDrawingDisplayPanel.m
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkeDrawingDisplayPanel.h"
#import "UkeDrawingCanvas.h"

@interface UkeDrawingDisplayPanel () <UkeDrawingCanvasDelegate>
@property (nonatomic, assign) UkeDrawingMode currentDrawingMode;
@property (nonatomic, strong) UkeDrawingCanvas *canvas;
@property (nonatomic, strong) NSMutableArray *allCanvas;
@end

@implementation UkeDrawingDisplayPanel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _allCanvas = [NSMutableArray array];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self canvas];
    }
}

- (void)switchDrawingMode:(UkeDrawingMode)drawingMode {
    if (_currentDrawingMode == drawingMode) {
        return;
    }
    _currentDrawingMode = drawingMode;
    self.canvas.currentDrawingMode = drawingMode;
}

#pragma mark - UkeDrawingCanvasDelegate
- (void)canvas:(UkeDrawingCanvas *)canvas didEndDrawing:(CGPathRef)path {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.lineCap = @"round";
    shapeLayer.lineJoin = @"round";
    shapeLayer.frame = self.bounds;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 4.0;
    shapeLayer.path = path;
    [self.layer addSublayer:shapeLayer];
    
    [_allCanvas addObject:shapeLayer];
    
    [self.canvas removeFromSuperview];
    self.canvas = nil;
    // 重新生成一个新的画布
    [self canvas].currentDrawingMode = self.currentDrawingMode;
}

- (UkeDrawingCanvas *)canvas {
    if (!_canvas) {
        UkeDrawingCanvas *canvas = [[UkeDrawingCanvas alloc] init];
        canvas.frame = self.bounds;
        canvas.delegate = self;
        [self addSubview:canvas];
        _canvas = canvas;
    }
    return _canvas;
}

@end
