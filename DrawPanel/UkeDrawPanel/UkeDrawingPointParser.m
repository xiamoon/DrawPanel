//
//  UkeDrawingPointParser.m
//  DrawPanel
//
//  Created by liqian on 2019/2/13.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkeDrawingPointParser.h"

@interface UkeDrawingPointParser ()
// 同一笔数据点，可能是完整的，也可能不完整
@property (nonatomic, strong) __block NSMutableArray<NSValue *> *currentDrawPoints;
@property (nonatomic, strong) __block NSValue *currentStartPoint;
@property (nonatomic, copy, nullable) __block NSString *currentActionId;
@property (nonatomic, copy, nullable) __block NSString *currentDrawType;
@property (nonatomic, assign) __block UkeDrawingState currentDrawingState;
@property (nonatomic, copy, nullable) __block NSString *currentText;
@end

@implementation UkeDrawingPointParser

- (instancetype)init {
    self = [super init];
    if (self) {
        _scaleX = 1.0;
        _scaleY = 1.0;
        _currentDrawPoints = [NSMutableArray array];
        _currentDrawingState = UkeDrawingStateUnknown;
    }
    return self;
}

- (void)parseWithPoints:(NSArray<NSArray *> *)points
             completion:(void(^)(UkeDrawingPointParser *parser))completionHandler {
    [self clearUpInfo];
    
    __block NSString *action = nil;
    __block NSArray *drawInfo = nil; // 画笔信息，如粗细，颜色等
    __block NSString *terminalFlag = nil;
    
    [points enumerateObjectsUsingBlock:^(NSArray *singlePoint, NSUInteger index, BOOL * _Nonnull stop) {
        if (singlePoint.count < 2) {
            return; // 相当于for循环的continue
        }
        
        if (singlePoint.count >= 3) {
            action = singlePoint[2];
        }
        
#pragma mark - 中间点数据
        if (singlePoint.count <= 3) {
            // 如果当前actionId不等于该点actionId，则强制结束前一个路径
            if (self.currentActionId && self.currentActionId.integerValue != action.integerValue) {
                // 强制结束上一个路径
                [self outputPathDataWithDrawInfo:drawInfo isForceEnd:YES completion:completionHandler];
            }
            
            if (!self.currentDrawType) {
                return;
            }
            
            if (singlePoint.count >= 2) {
                NSValue *point = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue]*self.scaleX, [singlePoint[1] floatValue]*self.scaleY)];
                [self.currentDrawPoints addObject:point];
                self.currentDrawingState = self.currentDrawingState|UkeDrawingStateDrawing;
            }
        }else if (singlePoint.count >= 5) {
            NSString *drawType = singlePoint[3];
            if ([drawType isKindOfClass:NSString.class]&&[drawType isEqualToString:@"publisherTime"]) {
                return;
            }
#pragma mark - 起始点数据
            if ([kUkeDrawingAllTypes containsObject:drawType]) {
                // 表示上一个点还没结束就来了下一个起始点
                if (self.currentActionId && self.currentActionId.integerValue != action.integerValue) {
                    // 强制结束上一个路径
                    [self outputPathDataWithDrawInfo:drawInfo isForceEnd:YES completion:completionHandler];
                }
                
                self.currentDrawType = drawType;
                self.currentActionId = action;
                self.currentDrawingState = UkeDrawingStateUnknown;
                
                NSValue *point = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue]*self.scaleX, [singlePoint[1] floatValue]*self.scaleY)];
                self.currentStartPoint = point;
                self.currentDrawingState = self.currentDrawingState|UkeDrawingStateStart;
                
                if (singlePoint.count >= 5) {
                    drawInfo = singlePoint[4];
                }
                
                if (singlePoint.count >= 6) {
                    terminalFlag = singlePoint[5];
                    if ([terminalFlag isKindOfClass:NSString.class]&&[terminalFlag isEqualToString:@"publisherTime"]) {
                        return;
                    }
#pragma mark - 结束点数据
                    if (terminalFlag.boolValue == YES) { // 终止点数据
                        if (!self.currentDrawType) {
                            return;
                        }
                        
                        if ([self.currentDrawType isEqualToString:kUkeDrawingAllTypes[8]]) { // 三角形
                            // 三角形的剩下两个点在drawInfo里面
                            if (drawInfo.count >= 6) {
                                NSValue *point1 = [NSValue valueWithCGPoint:CGPointMake([drawInfo[2] floatValue]*self.scaleX, [drawInfo[3] floatValue]*self.scaleY)];
                                NSValue *point2 = [NSValue valueWithCGPoint:CGPointMake([drawInfo[4] floatValue]*self.scaleX, [drawInfo[5] floatValue]*self.scaleY)];
                                
                                [self.currentDrawPoints addObject:point1];
                                [self.currentDrawPoints addObject:point2];
                            }
                        } else if ([self.currentDrawType isEqualToString:kUkeDrawingAllTypes[7]]) { // 箭头
                            // 箭头的终点在drawInfo里面
                            if (drawInfo.count >= 4) {
                                NSValue *endPoint = [NSValue valueWithCGPoint:CGPointMake([drawInfo[2] floatValue]*self.scaleX, [drawInfo[3] floatValue]*self.scaleY)];
                                [self.currentDrawPoints addObject:endPoint];
                            }
                        } else if ([self.currentDrawType isEqualToString:kUkeDrawingAllTypes[4]]) { // 文字
                            if (singlePoint.count >= 7) {
                                self.currentText = singlePoint[6];
                            }
                        } else {
                            NSValue *point = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue]*self.scaleX, [singlePoint[1] floatValue]*self.scaleY)];
                            [self.currentDrawPoints addObject:point];
                        }
                        
                        // 结束当前路径
                        self.currentDrawingState = self.currentDrawingState | UkeDrawingStateEnd;
                        [self outputPathDataWithDrawInfo:drawInfo isForceEnd:NO completion:completionHandler];
                    }
                }
            }
        }else {
            terminalFlag = singlePoint[3];
            if ([terminalFlag isKindOfClass:NSString.class]&&[terminalFlag isEqualToString:@"publisherTime"]) {
                return;
            }
#pragma mark - 结束点数据
            if (terminalFlag.boolValue == YES) {
                // 如果当前actionId不等于该点actionId，则强制结束前一个路径
                if (self.currentActionId && self.currentActionId.integerValue != action.integerValue) {
                    // 强制结束上一个路径
                    [self outputPathDataWithDrawInfo:drawInfo isForceEnd:YES completion:completionHandler];
                }
                
                if (!self.currentDrawType) {
                    return;
                }
                
                NSValue *point = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue]*self.scaleX, [singlePoint[1] floatValue]*self.scaleY)];
                [self.currentDrawPoints addObject:point];
                
                // 结束当前路径
                self.currentDrawingState = self.currentDrawingState | UkeDrawingStateEnd;
                [self outputPathDataWithDrawInfo:drawInfo isForceEnd:NO completion:completionHandler];
            }
        }
    }];
    
    // 开始绘画第一个点 或 绘画中
    if (self.currentDrawingState > UkeDrawingStateUnknown) {
        [self outputPathDataWithDrawInfo:drawInfo isForceEnd:NO completion:completionHandler];
    }
}

// 输出数据点供绘图使用
- (void)outputPathDataWithDrawInfo:(NSArray *)drawInfo
                        isForceEnd:(BOOL)isForcedEnd
                            completion:(void(^)(UkeDrawingPointParser *parser))completionHandler {
    CGFloat width = 0;
    UIColor *color = nil;
    if (drawInfo) {
        if (drawInfo.count >= 1) {
            width = [drawInfo[0] floatValue];
        }
        
        if (drawInfo.count >= 2) {
            NSString *hex = drawInfo[1];
            if ([self.currentDrawType isEqualToString:kUkeDrawingAllTypes[2]] || // 圆
                [self.currentDrawType isEqualToString:kUkeDrawingAllTypes[3]]) { // 框
                if (drawInfo.count >= 3) {
                    hex = drawInfo[2];
                }
            }
            hex = [hex substringFromIndex:1];
            NSInteger _hex = [self numberWithHexString:hex];
            color = UIColorHex(_hex);
        }
    }
    
    UkeDrawingMode drawingMode = UkeDrawingModeUnKnown;
    if (self.currentDrawType) {
        drawingMode = (UkeDrawingMode)[kUkeDrawingAllTypes indexOfObject:self.currentDrawType];
    }
    
    self.drawingMode = drawingMode;
    self.lineWidth = width;
    self.color = color;
    
    if (isForcedEnd) {
        self.forceEndLastPath = YES;
    }
    
    // 数据点优化，画线段、椭圆、矩形框、框选删除、箭头、三角形、五角星等不需要每个点都画，在同一个currentDrawPoints中，只需要取最后一个点即可。
    if (self.currentDrawPoints.count>1) {
        if (drawingMode == UkeDrawingModeBrush ||
            drawingMode == UkeDrawingModeText ||
            drawingMode == UkeDrawingModeEraser) {
        }else {
            self.currentDrawPoints = [NSMutableArray arrayWithObject:self.currentDrawPoints.lastObject];
        }
    }
    
    __weak typeof(self)weakSelf = self;
    if (completionHandler) {
        completionHandler(weakSelf);
    }
    
    self.currentDrawingState = UkeDrawingStateUnknown;
    self.currentDrawPoints = [NSMutableArray array];
    self.forceEndLastPath = NO;

    if (self.currentDrawingState&UkeDrawingStateEnd) {
        self.currentActionId = nil;
        self.currentDrawType = nil;
        self.currentStartPoint = nil;
    }
}

- (void)clearUpInfo {
    self.forceEndLastPath = NO;
    self.currentDrawPoints = [NSMutableArray array];
    self.lineWidth = 0;
    self.color = nil;
    self.currentDrawingState = UkeDrawingStateUnknown;
    self.currentText = nil;
}

- (NSInteger)numberWithHexString:(NSString *)hexString{
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}

@end
