//
//  UkePathInfo.h
//  DrawPanel
//
//  Created by liqian on 2019/1/31.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UkePathInfo : NSObject
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, assign) CGBlendMode blendMode;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) CGPathDrawingMode drawingMode;
@end

NS_ASSUME_NONNULL_END
