//
//  UkeDrawingPointGenerater.m
//  DrawPanel
//
//  Created by liqian on 2019/2/13.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "UkeDrawingPointGenerater.h"

@implementation UkeDrawingPointGenerater

+ (NSArray<NSArray *> *)linePoints {
    NSMutableArray *points = [NSMutableArray array];
    NSArray *start = @[@"287.5",@"272.5",@"11",@"brush",@[@"2",@"#EF4C4F"]];
    
    NSArray *point1 = @[@"288.33333333333337",@"272.5",@"11"];
    NSArray *point2 = @[@"290",@"273.33333333333337",@"11"];
    NSArray *point3 = @[@"292.5",@"274.1666666666667",@"11"];
    NSArray *point4 = @[@"296.6666666666667",@"276.6666666666667",@"11"];
    NSArray *point5 = @[@"300",@"278.33333333333337",@"11"];
    NSArray *point6 = @[@"303.33333333333337",@"280",@"11"];
    NSArray *point7 = @[@"306.6666666666667",@"281.6666666666667",@"11"];
    NSArray *point8 = @[@"309.1666666666667",@"281.6666666666667",@"11"];
    NSArray *point9 = @[@"312.5",@"282.5",@"11"];
    NSArray *point10 = @[@"313.33333333333337",@"282.5",@"11"];
    NSArray *point11 = @[@"315",@"283.33333333333337",@"11"];
    NSArray *point12 = @[@"316.6666666666667",@"284.1666666666667",@"11"];
    
    NSArray *end = @[@"316.6666666666667",@"284.1666666666667",@"11",@"true"];
    
    [points addObject:start];
    [points addObject:point1];
    [points addObject:point2];
    [points addObject:point3];
    [points addObject:point4];
    [points addObject:point5];
    [points addObject:point6];
    [points addObject:point7];
    [points addObject:point8];
    [points addObject:point9];
    [points addObject:point10];
    [points addObject:point11];
    [points addObject:point12];
    [points addObject:end];
    
    return points.copy;
}

+ (NSArray *)allDrawTypes {
    return @[@"brush", @"eraser", @"ellipse", @"rectangle", @"triangle", @"star", @"line", @"linearrow", @"texttool", @"eraserrectangle"];
}


@end
