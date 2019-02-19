//
//  UkeDrawingPointGenerater.h
//  DrawPanel
//
//  Created by liqian on 2019/2/13.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UkeDrawingConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface UkeDrawingPointGenerater : NSObject

// 画线
+ (NSArray<NSArray *> *)linePoints;

// 画圆
+ (NSArray<NSArray *> *)startPoints:(UkeDrawingMode)mode;
+ (NSArray<NSArray *> *)points2;
+ (NSArray<NSArray *> *)points3;
+ (NSArray<NSArray *> *)points4;
+ (NSArray<NSArray *> *)endPoints;

// 画三角形
+ (NSArray<NSArray *> *)triangleWholePoints;

// 文字
+ (NSArray<NSArray *> *)textWholePoints;

// 箭头
+ (NSArray<NSArray *> *)lineArrowWholePoints;



+ (NSArray<NSArray *> *)S1M1E1S2M2;
+ (NSArray<NSArray *> *)M2E2;

@end

NS_ASSUME_NONNULL_END
