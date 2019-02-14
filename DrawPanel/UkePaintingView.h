//
//  UkePaintingView.h
//  DrawPanel
//
//  Created by liqian on 2019/1/31.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UkeDrawingConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface UkePaintingView : UIView

@property (nonatomic, assign) UkeDrawingMode currentDrawingMode;
@property (nonatomic, assign) UkeDrawingState drawingState;

//! 当前绘画内容
@property (nonatomic, strong) UIImage *currentContents;

//! 手绘时调用这个方法
- (void)drawWithStartPoint:(CGPoint)startPoint
              currentPoint:(CGPoint)currentPoint;


//! 服务端数据驱动绘制时调用这个接口
- (void)drawWithMode:(UkeDrawingMode)drawingMode
          startPoint:(NSValue *)startPoint
               otherPoints:(NSArray<NSValue *> *)points
                     width:(CGFloat)width
                     color:(UIColor *)color
              drawingState:(UkeDrawingState)state;

@end

NS_ASSUME_NONNULL_END
