//
//  UkeDrawingCanvas.m
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkeDrawingCanvas.h"
#import "UkePaintingView.h"
#import "UkeDrawingPointParser.h"

@interface UkeDrawingCanvas ()
@property (nonatomic, strong) UkeDrawingPointParser *pointParser;
//! 绘画展示的layer
@property (nonatomic, strong) UkePaintingView *paintingView;
//! 绘画起始点
@property (nonatomic, assign) CGPoint startPoint;
//! 当前actionId
@property (nonatomic, copy) NSString *currentAction;

@end

@implementation UkeDrawingCanvas

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _pointParser = [[UkeDrawingPointParser alloc] init];
        
        _paintingView = [[UkePaintingView alloc] init];
        [self addSubview:_paintingView];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        _paintingView.frame = self.frame;
    }
}

- (UIImage *)currentContents {
    return _paintingView.currentContents;
}

- (void)setCurrentContents:(UIImage *)currentContents {
    [_paintingView setCurrentContents:currentContents];
}

- (void)drawWithPoints:(NSArray<NSArray *> *)points {
    __weak typeof(self)weakSelf = self;
    [_pointParser parseWithPoints:points completion:^(UkeDrawingPointParser * _Nonnull parser) {
        if (parser.drawingMode == UkeDrawingModeText) {
            [weakSelf.paintingView drawTextWithText:parser.text startPoint:parser.startPoint fontSize:parser.lineWidth color:parser.color drawingState:parser.drawingState];
        }else {
            [weakSelf.paintingView drawWithMode:parser.drawingMode startPoint:parser.startPoint otherPoints:parser.drawingPoints width:parser.lineWidth color:parser.color drawingState:parser.drawingState];
        }
    }];
}

- (void)drawWithStartPoint:(CGPoint)startPoint
              currentPoint:(CGPoint)currentPoint
              drawingState:(UkeDrawingState)drawingState
               drawingMode:(UkeDrawingMode)drawingMode {
    [_paintingView drawWithStartPoint:startPoint currentPoint:currentPoint drawingState:drawingState drawingMode:drawingMode];
}

- (void)dealloc {
    NSLog(@"手绘板canvas销毁");
}

@end
