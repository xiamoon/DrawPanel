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

+ (NSArray<NSArray *> *)ellipsePoints1 {
    NSMutableArray *points = [NSMutableArray array];
//    NSArray *start = @[@"252.5",@"130.83333333333334",@"14",@"brush",@[@"2",@"#EF4C4F"]];
//    NSArray *start = @[@"252.5",@"130.83333333333334",@"14",@"ellipse",@[@"2",@"0",@"#EF4C4F",@"0"]];
//    NSArray *start = @[@"252.5",@"130.83333333333334",@"14",@"rectangle",@[@"2",@"0",@"#EF4C4F",@"0"]];
    NSArray *start = @[@"252.5",@"130.83333333333334",@"14",@"line",@[@"2",@"#EF4C4F",@"0"]];

    NSArray *point1 = @[@"254.16666666666669",@"133.33333333333334",@"14"];
    NSArray *point2 = @[@"255.83333333333334",@"138.33333333333334",@"14"];
    NSArray *point3 = @[@"260",@"141",@"14"];
    NSArray *point4 = @[@"263",@"144",@"14"];
    NSArray *point5 = @[@"267",@"148",@"14"];
    NSArray *point6 = @[@"270",@"153",@"14"];
    NSArray *point7 = @[@"273",@"157",@"14"];
    NSArray *point8 = @[@"277",@"159",@"14"];
    NSArray *point9 = @[@"278",@"163",@"14"];
    NSArray *point10 = @[@"282",@"166",@"14"];
    NSArray *point11 = @[@"283",@"168",@"14"];
    NSArray *point12 = @[@"285",@"168",@"14"];
    NSArray *point13 = @[@"293",@"180",@"14"];

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
    [points addObject:point13];
    
    return points.copy;
}

+ (NSArray<NSArray *> *)ellipsePoints2 {
    NSMutableArray *points = [NSMutableArray array];
    
    NSArray *point1 = @[@"295",@"182",@"14"];
    NSArray *point2 = @[@"297",@"183",@"14"];
    NSArray *point3 = @[@"297",@"184",@"14"];
    NSArray *point4 = @[@"298",@"186",@"14"];
    NSArray *point5 = @[@"299",@"186",@"14"];
    NSArray *point6 = @[@"302",@"190",@"14"];
    
    [points addObject:point1];
    [points addObject:point2];
    [points addObject:point3];
    [points addObject:point4];
    [points addObject:point5];
    [points addObject:point6];
    
    return points.copy;
}

+ (NSArray<NSArray *> *)ellipsePoints3 {
    NSMutableArray *points = [NSMutableArray array];
    NSArray *point1 = @[@"317",@"202",@"14"];
    [points addObject:point1];
    return points.copy;
}

+ (NSArray<NSArray *> *)ellipsePoints4 {
    NSMutableArray *points = [NSMutableArray array];
    
    NSArray *point1 = @[@"317",@"202",@"14"];
    NSArray *point2 = @[@"320",@"202",@"14"];
    NSArray *point3 = @[@"322",@"202",@"14"];
    NSArray *point4 = @[@"326",@"202",@"14"];
    NSArray *point5 = @[@"339",@"202",@"14"];
    NSArray *point6 = @[@"345",@"202",@"14"];
    
    [points addObject:point1];
    [points addObject:point2];
    [points addObject:point3];
    [points addObject:point4];
    [points addObject:point5];
    [points addObject:point6];
    
    return points.copy;
}

+ (NSArray<NSArray *> *)ellipsePoints5 {
    NSMutableArray *points = [NSMutableArray array];
    NSArray *end = @[@"345",@"202",@"14",@"true"];
    [points addObject:end];
    return points.copy;
}

@end
