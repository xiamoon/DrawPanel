//
//  UkePaintingLayer.h
//  DrawPanel
//
//  Created by liqian on 2019/1/28.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UkeDrawingConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class UkePaintingLayer;
@protocol UkePaintingLayerDelegate <NSObject>
/*!
 正在画时调用，用于实时橡皮擦功能
 */
- (void)paintingLayer:(UkePaintingLayer *)layer
drawingOneStrokeWithPath:(CGPathRef)path;

/*!
 一笔画完之后调用
 */
- (void)paintingLayer:(UkePaintingLayer *)layer
        didEndDrawingOneStrokeWithPath:(CGPathRef)path;

/*!
 画文字时调用
 */
- (void)paintingLayer:(UkePaintingLayer *)layer
    didEndDrawingText:(NSAttributedString *)attributedString
             position:(CGPoint)position;
@end

@interface UkePaintingLayer : CALayer
@property (nonatomic, weak) id<UkePaintingLayerDelegate> drawingDelegate;
@property (nonatomic, assign) UkeDrawingMode currentDrawingMode;
@property (nonatomic, assign) UkeDrawingState drawingState;

- (void)drawWithStartPoint:(CGPoint)startPoint
              currentPoint:(CGPoint)currentPoint;

@end

NS_ASSUME_NONNULL_END
