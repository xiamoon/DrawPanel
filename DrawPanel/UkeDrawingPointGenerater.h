//
//  UkeDrawingPointGenerater.h
//  DrawPanel
//
//  Created by liqian on 2019/2/13.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UkeDrawingPointGenerater : NSObject

// 画线
+ (NSArray<NSArray *> *)linePoints;

// 画圆
+ (NSArray<NSArray *> *)ellipsePoints1;
+ (NSArray<NSArray *> *)ellipsePoints2;
+ (NSArray<NSArray *> *)ellipsePoints3;
+ (NSArray<NSArray *> *)ellipsePoints4;
+ (NSArray<NSArray *> *)ellipsePoints5;

@end

NS_ASSUME_NONNULL_END
