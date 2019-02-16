//
//  UkeDrawingDisplayPanel.h
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UkeDrawingConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface UkeDrawingDisplayPanel : UIView

// 翻到下一页
- (void)turnToNextPage;
// 翻到上一页
- (void)turnToPreviousPage;


#pragma mark - 数据点驱动绘画
//! 服务器数据点驱动绘画
- (void)drawWithPoints:(NSArray<NSArray *> *)points;


#pragma mark - 手势驱动绘画
//! 手绘时调用这个方法
- (void)drawWithStartPoint:(CGPoint)startPoint
              currentPoint:(CGPoint)currentPoint
              drawingState:(UkeDrawingState)drawingState
               drawingMode:(UkeDrawingMode)drawingMode;

@end

NS_ASSUME_NONNULL_END
