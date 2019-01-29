//
//  UkePaintingDisplayLayer.h
//  DrawPanel
//
//  Created by liqian on 2019/1/29.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UkeDrawingConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface UkePaintingDisplayLayer : CALayer
@property (nonatomic, assign) UkeDrawingMode currentDrawingMode;
@property (nonatomic, assign) UkeDrawingState drawingState;

//! 当前绘画内容
@property (nonatomic, strong) NSArray<CAShapeLayer *> *currentStrokes;

- (void)drawWithStartPoint:(CGPoint)startPoint
              currentPoint:(CGPoint)currentPoint;
@end

NS_ASSUME_NONNULL_END
