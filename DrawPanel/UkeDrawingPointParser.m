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

- (void)parseWithPoints:(NSArray<NSArray *> *)points {
    NSMutableArray<NSValue *> *drawingPoints = [NSMutableArray array];
    
    __block NSString *action = nil;
    __block NSString *drawType = nil;
    __block NSArray *drawInfo = nil; // 画笔信息，如粗细，颜色等
    __block NSValue *startPoint = nil;
    __block NSString *terminalFlag = nil;
    
    [points enumerateObjectsUsingBlock:^(NSArray *singlePoint, NSUInteger index, BOOL * _Nonnull stop) {
        
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
            if ([[UkeDrawingPointGenerater allDrawTypes] containsObject:drawType]) { // 起始点数据
                NSValue *point = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue], [singlePoint[1] floatValue])];
                startPoint = point;
                
                if (singlePoint.count >= 5) {
                    drawInfo = singlePoint[4];
                }
                
                if (singlePoint.count >= 6) {
                    terminalFlag = singlePoint[5];
                    if ([terminalFlag isEqualToString:@"true"]) { // 终止点数据
                        NSValue *point = [NSValue valueWithCGPoint:CGPointMake([singlePoint[0] floatValue], [singlePoint[1] floatValue])];
                        [drawingPoints addObject:point];
                    }else {
                        terminalFlag = nil;
                    }
                }
            }else {
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
        if (drawInfo.count >= 2) {
            width = [drawInfo[0] floatValue];
            NSString *hex = drawInfo[1];
            if ([drawType isEqualToString:[UkeDrawingPointGenerater allDrawTypes][2]]) { // 圆
                hex = drawInfo[2];
            }
            hex = [hex substringFromIndex:1];
            NSInteger _hex = [self numberWithHexString:hex];
            color = UIColorHex(_hex);
        }
    }
    
    UkeDrawingMode drawingMode = UkeDrawingModeUnKnown;
    if (drawType) {
        drawingMode = (UkeDrawingMode)[[UkeDrawingPointGenerater allDrawTypes] indexOfObject:drawType];
    }
    
    
    self.drawingMode = drawingMode;
    self.startPoint = startPoint;
    self.drawingPoints = drawingPoints;
    self.lineWidth = width;
    self.color = color;
    self.drawingState = terminalFlag?UkeDrawingStateEnd:UkeDrawingStateDrawing;
}

- (NSInteger)numberWithHexString:(NSString *)hexString{
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}

@end
