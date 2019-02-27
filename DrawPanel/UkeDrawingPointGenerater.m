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

+ (NSArray<NSArray *> *)startPoints:(UkeDrawingMode)mode {
    NSMutableArray *points = [NSMutableArray array];
    NSArray *start;
    if (mode == UkeDrawingModeBrush) {
        start = @[@"252.5",@"130.83333333333334",@"14",@"brush",@[@"2",@"#EF4C4F"]];
    }else if (mode == UkeDrawingModeEllipse) {
        start = @[@"252.5",@"130.83333333333334",@"14",@"ellipse",@[@"2",@"0",@"#EF4C4F",@"0"]];
    }else if (mode == UkeDrawingModeRectangle) {
        start = @[@"252.5",@"130.83333333333334",@"14",@"rectangle",@[@"2",@"0",@"#EF4C4F",@"0"]];
    }else if (mode == UkeDrawingModeLine) {
        start = @[@"252.5",@"130.83333333333334",@"14",@"line",@[@"2",@"#EF4C4F",@"0"]];
    }else if (mode == UkeDrawingModeEraserRectangle) {
        start = @[@"90.83333333333334",@"100.83333333333334",@"14",@"eraserrectangle",@[]];
    }else if (mode == UkeDrawingModeStar) {
        start = @[@"252.5",@"130.83333333333334",@"14",@"star",@[@"2",@"#EF4C4F",@"0"]];
    }else if (mode == UkeDrawingModeEraser) {
        start = @[@"252.5",@"130.83333333333334",@"14",@"eraser",@[@(40)]];
    }
    
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

+ (NSArray<NSArray *> *)points2 {
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

+ (NSArray<NSArray *> *)points3 {
    NSMutableArray *points = [NSMutableArray array];
    NSArray *point1 = @[@"317",@"202",@"14"];
    [points addObject:point1];
    return points.copy;
}

+ (NSArray<NSArray *> *)points4 {
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

+ (NSArray<NSArray *> *)endPoints {
    NSMutableArray *points = [NSMutableArray array];
    NSArray *end = @[@"345",@"202",@"14",@"true"];
    [points addObject:end];
    return points.copy;
}


+ (NSArray<NSArray *> *)triangleWholePoints {
    NSMutableArray *points = [NSMutableArray array];
    NSArray *point = @[@"423.33333333333337",@"176.66666666666669",@"14",@"triangle",@[@"2",@"#ef4c4f",@"486.6666666666667", @"244.16666666666669", @"360",@"244.16666666666669",@"0",@"0"],@"true"];
    [points addObject:point];
    return points.copy;
}

+ (NSArray<NSArray *> *)textWholePoints {
    NSMutableArray *points = [NSMutableArray array];
    NSArray *point = @[@"260",@"185",@"14",@"texttool",@[@"15",@"#ef4c4f"],@"true",@"看空间"];
    [points addObject:point];
    return points.copy;
}

+ (NSArray<NSArray *> *)lineArrowWholePoints {
    NSMutableArray *points = [NSMutableArray array];
    NSArray *point = @[@"310",@"220",@"14",@"linearrow",@[@"2",@"#ef4c4f",@"410",@"285"],@"true"];
    [points addObject:point];
    return points.copy;
}






+ (NSArray<NSArray *> *)S1M1E1S2M2 {
    NSMutableArray *points = [NSMutableArray array];
    
    [points addObject:@[@"100",@"160",@"11",@"brush",@[@"2",@"#EF4C4F"]]];
    [points addObject:@[@"110",@"240",@"11"]];
    [points addObject:@[@"120",@"200",@"11"]];
    [points addObject:@[@"130",@"100",@"11",@"true"]];

    [points addObject:@[@"400",@"160",@"12",@"brush",@[@"2",@"#EF4C4F"]]];
    [points addObject:@[@"410",@"240",@"12"]];
    
    return points.copy;
}


+ (NSArray<NSArray *> *)S1M1 {
    NSMutableArray *points = [NSMutableArray array];
    
    [points addObject:@[@"100",@"160",@"11",@"brush",@[@"2",@"#EF4C4F"]]];
    [points addObject:@[@"110",@"240",@"11"]];
    
    return points.copy;
}

+ (NSArray<NSArray *> *)M1E1S2M2 {
    NSMutableArray *points = [NSMutableArray array];
    
    [points addObject:@[@"120",@"200",@"11"]];
    [points addObject:@[@"130",@"100",@"11",@"true"]];
    
    [points addObject:@[@"400",@"160",@"12",@"brush",@[@"2",@"#EF4C4F"]]];
    [points addObject:@[@"410",@"240",@"12"]];
    
    return points.copy;
}

+ (NSArray<NSArray *> *)M2E2 {
    NSMutableArray *points = [NSMutableArray array];

    [points addObject:@[@"420",@"200",@"12"]];
    [points addObject:@[@"430",@"100",@"12",@"true"]];
    
    return points.copy;
}

+ (NSArray<NSArray *> *)eraser {
    NSMutableArray *points = [NSMutableArray array];

    NSArray *start = @[@"100",@"160",@"13",@"eraser",@[@(40)]];
    [points addObject:start];
    [points addObject:@[@"110",@"240",@"13"]];
    [points addObject:@[@"120",@"200",@"13"]];
    [points addObject:@[@"130",@"100",@"13",@"true"]];
    
    return points.copy;
}

@end
