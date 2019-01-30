//
//  UkeDrawingConstants.h
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#ifndef UkeDrawingConstants_h
#define UkeDrawingConstants_h

typedef NS_ENUM(NSInteger, UkeDrawingMode) {
    UkeDrawingModeLine = 0, //! 线
    UkeDrawingModeSegment, //! 线段
    UkeDrawingModeEllipse, //! 椭圆
    UkeDrawingModeRectangle, //! 矩形框
    UkeDrawingModeWords, //! 文字
    UkeDrawingModeEraser, //! 橡皮擦
    UkeDrawingModeEraserRectangle, //! 框选删除
    UkeDrawingModeArrow, //! 箭头
    UkeDrawingModeTriangle, //! 三角形
};

typedef NS_ENUM(NSInteger, UkeDrawingState) {
    UkeDrawingStateUnknown = -1,
    UkeDrawingStateStart = 0,
    UkeDrawingStateDrawing,
    UkeDrawingStateEnd
};

#endif /* UkeDrawingConstants_h */
