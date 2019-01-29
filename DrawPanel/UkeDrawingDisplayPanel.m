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
@property (nonatomic, strong) NSMutableArray<NSArray<CAShapeLayer *> *> *allPaintings;
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
    // 获取当前画布内容
    NSArray *currentPainting = [_currentCanvas currentStrokes];
    
    // 如果当前是最后一页
    if (_allPaintings.count==0 || _currentIndex >= _allPaintings.count-1) {
        if (_currentIndex == _allPaintings.count-1) {
            // 替换存储内容
            [_allPaintings replaceObjectAtIndex:_currentIndex withObject:currentPainting];
        }else {
            // 存储当前画布内容
            [_allPaintings addObject:currentPainting];
        }
        
        // 移除当前画布
        [_currentCanvas removeFromSuperview];
        _currentCanvas = nil;
        
        _currentIndex ++;
        // 创建新画布
        [self createCanvas];
    }
    // 如果当前不是最后一页
    else {
        // 替换存储内容
        [_allPaintings replaceObjectAtIndex:_currentIndex withObject:currentPainting];
        // 移除当前画布
        [_currentCanvas removeFromSuperview];
        _currentCanvas = nil;
        
        _currentIndex ++;
        // 创建新画布
        [self createCanvas];
        // 恢复缓存的画布内容
        NSArray *cachedPaintings = _allPaintings[_currentIndex];
        [_currentCanvas setCurrentStrokes:cachedPaintings];
    }
    _currentCanvas.currentDrawingMode = self.currentDrawingMode;
}

- (void)turnToPreviousPage {
    if (_currentIndex == 0) return;
    
    // 获取当前画布内容
    NSArray *currentPainting = [_currentCanvas currentStrokes];
    if (_currentIndex > _allPaintings.count-1) {
        // 存储当前内容
        [_allPaintings addObject:currentPainting];
    }else {
        // 替换存储内容
        [_allPaintings replaceObjectAtIndex:_currentIndex withObject:currentPainting];
    }

    // 移除当前画布
    [_currentCanvas removeFromSuperview];
    _currentCanvas = nil;
    
    _currentIndex --;
    // 创建新画布
    [self createCanvas];
    // 恢复缓存的画布内容
    NSArray *cachedPainting = _allPaintings[_currentIndex];
    [_currentCanvas setCurrentStrokes:cachedPainting];
    _currentCanvas.currentDrawingMode = self.currentDrawingMode;
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
