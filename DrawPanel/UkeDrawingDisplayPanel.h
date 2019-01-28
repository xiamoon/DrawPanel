//
//  UkeDrawingDisplayPanel.h
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UkeDrawingConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface UkeDrawingDisplayPanel : UIView

- (void)switchDrawingMode:(UkeDrawingMode)drawingMode;

- (void)turnToNextPage;
- (void)turnToPreviousPage;

@end

NS_ASSUME_NONNULL_END
