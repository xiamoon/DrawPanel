//
//  UkeDrawingPointParser.m
//  DrawPanel
//
//  Created by liqian on 2019/2/13.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkeDrawingPointParser.h"
#import "UkeDrawingPointGenerater.h"

@implementation UkeDrawingPointParser

- (void)parseWithPoints:(NSArray<NSArray *> *)points
             completion:(void(^)(UkeDrawingPointParser *parser))completionHandler {
    [self clearUpInfo];
    NSMutableArray<NSValue *> *drawingPoints = [NSMutableArray array];
    
    __block NSString *action = nil;
    __block NSString *drawType = nil;
    __block NSArray *drawInfo = nil; // 画笔信息，如粗细，颜色等
    __block NSValue *startPoint = nil;
    __block NSString *terminalFlag = nil;
    __block NSString *text = nil;
    
    [points enumerateObjectsUsingBlock:^(NSArray *singlePoint, NSUInteger index, BOOL * _Nonnull stop) {
        if (singlePoint.count < 2) {
            return; // 相当于for循环的continue
        }
        
        if (singlePoint.count >= 3) {
            action = singlePoint[2];
        }
        
        if (singlePoint.count <= 3) { // 中间点数据
            if (singlePoint.count >= 2) {
                NSValue *point = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue], [singlePoint[1] floatValue])];
                [drawingPoints addObject:point];
            }
        }else {
            drawType = singlePoint[3];
            if ([kUkeDrawingAllTypes containsObject:drawType]) { // 起始点数据
                NSValue *point = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue], [singlePoint[1] floatValue])];
                startPoint = point;
                
                if (singlePoint.count >= 5) {
                    drawInfo = singlePoint[4];
                }
                
                if (singlePoint.count >= 6) {
                    terminalFlag = singlePoint[5];
                    if ([terminalFlag isEqualToString:@"true"]) { // 终止点数据
                        if ([drawType isEqualToString:kUkeDrawingAllTypes[8]]) { // 三角形
                            // 三角形的剩下两个点在drawInfo里面
                            if (drawInfo.count >= 6) {
                                NSValue *point1 = [NSValue valueWithCGPoint:CGPointMake([drawInfo[2] floatValue], [drawInfo[3] floatValue])];
                                NSValue *point2 = [NSValue valueWithCGPoint:CGPointMake([drawInfo[4] floatValue], [drawInfo[5] floatValue])];
                                
                                [drawingPoints addObject:point1];
                                [drawingPoints addObject:point2];
                            }
                        } else if ([drawType isEqualToString:kUkeDrawingAllTypes[7]]) { // 箭头
                            // 箭头的终点在drawInfo里面
                            if (drawInfo.count >= 4) {
                                NSValue *endPoint = [NSValue valueWithCGPoint:CGPointMake([drawInfo[2] floatValue], [drawInfo[3] floatValue])];
                                [drawingPoints addObject:endPoint];
                            }
                        } else if ([drawType isEqualToString:kUkeDrawingAllTypes[4]]) { // 文字
                            if (singlePoint.count >= 7) {
                                text = singlePoint[6];
                            }
                        } else {
                            NSValue *point = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue], [singlePoint[1] floatValue])];
                            [drawingPoints addObject:point];
                        }
                    }else {
                        terminalFlag = nil;
                    }
                }
            }else {
                drawType = nil;
                terminalFlag = singlePoint[3];
                if ([terminalFlag isEqualToString:@"true"]) { // 终止点数据
                    NSValue *point = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue], [singlePoint[1] floatValue])];
                    [drawingPoints addObject:point];
                }else {
                    terminalFlag = nil;
                }
            }
        }
    }];
    
    
    CGFloat width = 0;
    UIColor *color = nil;
    if (drawInfo) {
        if (drawInfo.count >= 1) {
            width = [drawInfo[0] floatValue];
        }
        
        if (drawInfo.count >= 2) {
            NSString *hex = drawInfo[1];
            if ([drawType isEqualToString:kUkeDrawingAllTypes[2]] || // 圆
                [drawType isEqualToString:kUkeDrawingAllTypes[3]]) { // 框
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
    if (drawType) {
        drawingMode = (UkeDrawingMode)[kUkeDrawingAllTypes indexOfObject:drawType];
    }
    
    self.action = action;
    self.drawingMode = drawingMode;
    self.startPoint = startPoint;
    self.drawingPoints = drawingPoints;
    self.lineWidth = width;
    self.color = color;
    self.text = text;
    self.drawingState = terminalFlag?UkeDrawingStateEnd:UkeDrawingStateDrawing;
    
    __weak typeof(self)weakSelf = self;
    if (completionHandler) {
        completionHandler(weakSelf);
    }
}

- (void)clearUpInfo {
    self.action = nil;
    self.drawingMode = UkeDrawingModeUnKnown;
    self.startPoint = nil;
    self.drawingPoints = nil;
    self.lineWidth = 0;
    self.color = nil;
    self.drawingState = UkeDrawingStateUnknown;
}

- (NSInteger)numberWithHexString:(NSString *)hexString{
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}

@end
