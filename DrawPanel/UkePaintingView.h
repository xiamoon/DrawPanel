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

- (void)drawWithStartPoint:(CGPoint)startPoint
              currentPoint:(CGPoint)currentPoint;


- (void)drawWithPoints:(NSArray<NSValue *> *)points
                 width:(CGFloat)width
                 color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
