//
//  UkeDrawingCanvas.h
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UkeDrawingConstants.h"

NS_ASSUME_NONNULL_BEGIN

@class UkeDrawingCanvas;
@protocol UkeDrawingCanvasDelegate <NSObject>
- (void)canvas:(UkeDrawingCanvas *)canvas didEndDrawing:(CGPathRef)path;
@end

@interface UkeDrawingCanvas : UIView
@property (nonatomic, assign) UkeDrawingMode currentDrawingMode;
@property (nonatomic, weak) id<UkeDrawingCanvasDelegate> delegate;

//! 当前画布内容
@property (nonatomic, strong) CALayer *currentPainting;

@end

NS_ASSUME_NONNULL_END
