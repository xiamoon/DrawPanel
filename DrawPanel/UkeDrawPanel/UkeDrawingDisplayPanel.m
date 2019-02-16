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
//! 当前画布。每一页都对应一个单独的画布
@property (nonatomic, strong) UkeDrawingCanvas *currentCanvas;
//! 所有的绘画内容
@property (nonatomic, strong) NSMutableArray<UIImage *> *allCanvas;
//! 当前索引
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation UkeDrawingDisplayPanel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _allCanvas = [NSMutableArray array];
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

- (void)turnToNextPage {
    // 获取当前画布内容
    UIImage *currentDrawedContents = [_currentCanvas currentContents];
    
    // 如果当前是最后一页
    if (_allCanvas.count==0 || _currentIndex >= _allCanvas.count-1) {
        if (_currentIndex == _allCanvas.count-1) {
            // 替换存储内容
            [_allCanvas replaceObjectAtIndex:_currentIndex withObject:currentDrawedContents];
        }else {
            // 存储当前画布内容
            [_allCanvas addObject:currentDrawedContents];
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
        [_allCanvas replaceObjectAtIndex:_currentIndex withObject:currentDrawedContents];
        // 移除当前画布
        [_currentCanvas removeFromSuperview];
        _currentCanvas = nil;
        
        _currentIndex ++;
        // 创建新画布
        [self createCanvas];
        // 恢复缓存的画布内容
        UIImage *cachedDrawedContents = _allCanvas[_currentIndex];
        [_currentCanvas setCurrentContents:cachedDrawedContents];
    }
}

- (void)turnToPreviousPage {
    if (_currentIndex == 0) return;
    
    // 获取当前画布内容
    UIImage *currentDrawedContents = [_currentCanvas currentContents];
    if (_currentIndex > _allCanvas.count-1) {
        // 存储当前内容
        [_allCanvas addObject:currentDrawedContents];
    }else {
        // 替换存储内容
        [_allCanvas replaceObjectAtIndex:_currentIndex withObject:currentDrawedContents];
    }

    // 移除当前画布
    [_currentCanvas removeFromSuperview];
    _currentCanvas = nil;
    
    _currentIndex --;
    // 创建新画布
    [self createCanvas];
    // 恢复缓存的画布内容
    UIImage *cachedDrawedContents = _allCanvas[_currentIndex];
    [_currentCanvas setCurrentContents:cachedDrawedContents];
}

- (void)drawWithPoints:(NSArray<NSArray *> *)points {
    [_currentCanvas drawWithPoints:points];
}

- (void)drawWithStartPoint:(CGPoint)startPoint currentPoint:(CGPoint)currentPoint drawingState:(UkeDrawingState)drawingState drawingMode:(UkeDrawingMode)drawingMode {
    [_currentCanvas drawWithStartPoint:startPoint currentPoint:currentPoint drawingState:drawingState drawingMode:drawingMode];
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
