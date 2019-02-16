//
//  UkeDrawingConstants.h
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#ifndef UkeDrawingConstants_h
#define UkeDrawingConstants_h

// Color.
#ifndef UIColorRGBA
    #define UIColorRGBA(r, g, b, a) \
            [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

    #define UIColorRGB(r, g, b)     UIColorRGBA(r, g, b, 1.f)

    #define UIRandomColor \
            UIColorRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#endif

#ifndef UIColorHexA
    #define UIColorHexA(_hex_, a) \
            UIColorRGBA((((_hex_) & 0xFF0000) >> 16), (((_hex_) & 0xFF00) >> 8), ((_hex_) & 0xFF), a)

    #define UIColorHex(_hex_)   UIColorHexA(_hex_, 1.0)
#endif

// 所有的绘画类型
#define kUkeDrawingAllTypes  @[@"brush", @"line", @"ellipse", @"rectangle", @"texttool", @"eraser", @"eraserrectangle", @"linearrow", @"triangle", @"star"]

typedef NS_ENUM(NSInteger, UkeDrawingMode) {
    UkeDrawingModeUnKnown = -1,
    UkeDrawingModeBrush = 0, //! 线
    UkeDrawingModeLine, //! 线段
    UkeDrawingModeEllipse, //! 椭圆
    UkeDrawingModeRectangle, //! 矩形框
    UkeDrawingModeText, //! 文字
    UkeDrawingModeEraser, //! 橡皮擦
    UkeDrawingModeEraserRectangle, //! 框选删除
    UkeDrawingModeLineArrow, //! 箭头
    UkeDrawingModeTriangle, //! 三角形
    UkeDrawingModeStar, //! 五角星
};

//TODO: 优化为Options
typedef NS_ENUM(NSInteger, UkeDrawingState) {
    UkeDrawingStateUnknown = -1,
    UkeDrawingStateStart = 0,
    UkeDrawingStateDrawing,
    UkeDrawingStateEnd
};

#endif /* UkeDrawingConstants_h */
