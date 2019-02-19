//
//  UkeDrawingPointParser.h
//  DrawPanel
//
//  Created by liqian on 2019/2/13.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UkeDrawingConstants.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UkeDrawingPointParser : NSObject

@property (nonatomic, assign) UkeDrawingMode drawingMode;
@property (nonatomic, assign, readonly) __block UkeDrawingState currentDrawingState;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong, nullable) UIColor *color;

@property (nonatomic, copy, nullable, readonly) NSString *currentText;

@property (nonatomic, strong, readonly) __block NSValue *currentStartPoint;
// 同一笔数据点，可能是完整的，也可能不完整，不包含起始点
@property (nonatomic, strong, readonly, nullable) __block NSMutableArray<NSValue *> *currentDrawPoints;

// 是否强制结束。当第二笔数据过来时，如果前一笔还没结束，则强制结束第一笔路径
@property (nonatomic, assign) __block BOOL forceEndLastPath;

//! x坐标缩放比
@property (nonatomic, assign) CGFloat scaleX;
//! y坐标缩放比
@property (nonatomic, assign) CGFloat scaleY;

- (void)parseWithPoints:(NSArray<NSArray *> *)points
             completion:(void(^)(UkeDrawingPointParser *parser))completionHandler;

@end

NS_ASSUME_NONNULL_END
