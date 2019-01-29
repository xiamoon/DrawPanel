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
- (void)paintingLayer:(UkePaintingLayer *)layer
        didEndDrawingOneStrokeWithPath:(CGPathRef)path;
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
