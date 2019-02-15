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

@property (nonatomic, copy, nullable) NSString *action;
@property (nonatomic, assign) UkeDrawingMode drawingMode;
@property (nonatomic, assign) UkeDrawingState drawingState;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong, nullable) UIColor *color;

@property (nonatomic, copy, nullable) NSString *text;

@property (nonatomic, strong, nullable) NSValue *startPoint;
@property (nonatomic, strong, nullable) NSArray<NSValue *> *drawingPoints; // 不包含起始点

//! x坐标缩放比
@property (nonatomic, assign) CGFloat scaleX;
//! y坐标缩放比
@property (nonatomic, assign) CGFloat scaleY;

- (void)parseWithPoints:(NSArray<NSArray *> *)points
             completion:(void(^)(UkeDrawingPointParser *parser))completionHandler;

@end

NS_ASSUME_NONNULL_END
