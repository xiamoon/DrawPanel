//
//  UkeDrawingDisplayPanel.m
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkeDrawingDisplayPanel.h"
#import "UkeDrawingCanvas.h"

@interface UkeDrawingDisplayPanel ()
@property (nonatomic, assign) UkeDrawingMode currentDrawingMode;
@property (nonatomic, strong) UkeDrawingCanvas *currentCanvas;
//! 所有的绘画内容
@property (nonatomic, strong) NSMutableArray<CALayer *> *allPaintings;
//! 当前索引
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation UkeDrawingDisplayPanel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _allPaintings = [NSMutableArray array];
        _currentIndex = 0;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        // 创建画布
        [self createCanvas];
    }
}

- (void)switchDrawingMode:(UkeDrawingMode)drawingMode {
    if (_currentDrawingMode == drawingMode) {
        return;
    }
    _currentDrawingMode = drawingMode;
    _currentCanvas.currentDrawingMode = drawingMode;
}

- (void)turnToNextPage {
    // 移除当前画布
    [_currentCanvas removeFromSuperview];
    _currentCanvas = nil;
    
    _currentIndex ++;
    // 创建新画布
    [self createCanvas];
    // 恢复画布内容
    if (_currentIndex < _allPaintings.count) {
        CALayer *painting = _allPaintings[_currentIndex];
        [_currentCanvas setCurrentPainting:painting];
    }
}

- (void)turnToPreviousPage {
    // 移除当前画布
    [_currentCanvas removeFromSuperview];
    _currentCanvas = nil;
    
    _currentIndex --;
    if (_currentIndex < 0) return;
    // 创建新画布
    [self createCanvas];
    CALayer *painting = _allPaintings[_currentIndex];
    [_currentCanvas setCurrentPainting:painting];
}

- (UkeDrawingCanvas *)createCanvas {
    if (!_currentCanvas) {
        UkeDrawingCanvas *canvas = [[UkeDrawingCanvas alloc] init];
        canvas.frame = self.bounds;
        [self addSubview:canvas];
        _currentCanvas = canvas;
        
    }
    return _currentCanvas;
}

@end
