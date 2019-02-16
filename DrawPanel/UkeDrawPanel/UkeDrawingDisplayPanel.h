//
//  UkeDrawingDisplayPanel.h
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UkeDrawingConstants.h"
#import "UkeDrawingCanvas.h"

NS_ASSUME_NONNULL_BEGIN

@interface UkeDrawingDisplayPanel : UIView

// 翻到下一页
- (void)turnToNextPage;
// 翻到上一页
- (void)turnToPreviousPage;

//! 当前画布。每一页都对应一个单独的画布
@property (nonatomic, strong) UkeDrawingCanvas *currentDrawingCanvas;

@end

NS_ASSUME_NONNULL_END
