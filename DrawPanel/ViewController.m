//
//  ViewController.m
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "ViewController.h"
#import "UkeDrawingDisplayPanel.h"
#import "UkeDrawingPointGenerater.h"

@interface ViewController ()
@property (nonatomic, strong) UkeDrawingDisplayPanel *panel;
//! 手绘起始点
@property (nonatomic, assign) CGPoint panStartPoint;
//! 手绘绘制模式
@property (nonatomic, assign) UkeDrawingMode panDrawingMode;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"线", @"线段", @"圆", @"框", @"文字", @"橡皮", @"框选删除", @"箭头", @"三角"]];
    seg.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 44.0);
    [seg addTarget:self action:@selector(handleSegAction:) forControlEvents:UIControlEventValueChanged];
    [seg setSelectedSegmentIndex:0];
//    [self.view addSubview:seg];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1000;
    [button setTitle:@"上一页" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(40, 0, 100, 44.0);
    button.layer.cornerRadius = 4;
    button.layer.borderColor = [UIColor blueColor].CGColor;
    button.layer.borderWidth = 1.0;
    [button addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = 1001;
    [button2 setTitle:@"下一页" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button2.frame = CGRectMake(CGRectGetWidth(self.view.frame)-100-40, 0, 100, 44.0);
    button2.layer.cornerRadius = 4;
    button2.layer.borderColor = [UIColor blueColor].CGColor;
    button2.layer.borderWidth = 1.0;
    [button2 addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    bgView.layer.masksToBounds = YES;
    bgView.frame = CGRectMake(40, CGRectGetMaxY(button.frame), CGRectGetWidth(self.view.bounds)-80, CGRectGetHeight(self.view.bounds)-CGRectGetMaxY(button.frame));
    bgView.image = [UIImage imageNamed:@"test.jpeg"];
    [self.view addSubview:bgView];
    
    UkeDrawingDisplayPanel *panel = [[UkeDrawingDisplayPanel alloc] init];
    panel.frame = bgView.frame;
    [self.view addSubview:panel];
    _panel = panel;
    [self drawingByServer];

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panel addGestureRecognizer:pan];
}

- (void)handleSegAction:(UISegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    _panDrawingMode = index;
}

- (void)handleButtonAction:(UIButton *)button {
    if (button.tag == 1000) { // 翻到下一页
        [_panel turnToPreviousPage];
    }else if (button.tag == 1001) { // 翻到上一页
        [_panel turnToNextPage];
    }
}

#pragma mark - 服务器数据驱动绘画
- (void)drawingByServer {
    // 画笔
    [_panel.currentDrawingCanvas drawWithPoints:[UkeDrawingPointGenerater startPoints:UkeDrawingModeLine]];
    [_panel.currentDrawingCanvas drawWithPoints:[UkeDrawingPointGenerater points2]];
    [_panel.currentDrawingCanvas drawWithPoints:[UkeDrawingPointGenerater points3]];
    [_panel.currentDrawingCanvas drawWithPoints:[UkeDrawingPointGenerater points4]];
    [_panel.currentDrawingCanvas drawWithPoints:[UkeDrawingPointGenerater endPoints]];
    // 三角形
    [_panel.currentDrawingCanvas drawWithPoints:[UkeDrawingPointGenerater triangleWholePoints]];
    // 文字
    [_panel.currentDrawingCanvas drawWithPoints:[UkeDrawingPointGenerater textWholePoints]];
    // 箭头
    [_panel.currentDrawingCanvas drawWithPoints:[UkeDrawingPointGenerater lineArrowWholePoints]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.panel.currentDrawingCanvas drawWithPoints:[UkeDrawingPointGenerater startPoints:UkeDrawingModeStar]];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.panel.currentDrawingCanvas drawWithPoints:[UkeDrawingPointGenerater points2]];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.panel.currentDrawingCanvas drawWithPoints:[UkeDrawingPointGenerater points3]];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.panel.currentDrawingCanvas drawWithPoints:[UkeDrawingPointGenerater points4]];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.panel.currentDrawingCanvas drawWithPoints:[UkeDrawingPointGenerater endPoints]];
    });
}

#pragma mark - 手势驱动绘画
- (void)handlePanGesture:(UIGestureRecognizer *)pan {
    CGPoint point = [pan locationInView:pan.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        _panStartPoint = point;
    }
    CGPoint currentPoint = point;
    
    _panDrawingMode = UkeDrawingModeEraserRectangle;
    
    UkeDrawingState drawingState = [self drawingStateFromGestureState:pan.state];
    [_panel.currentDrawingCanvas drawWithStartPoint:_panStartPoint currentPoint:currentPoint drawingState:drawingState drawingMode:_panDrawingMode];
}

- (UkeDrawingState)drawingStateFromGestureState:(UIGestureRecognizerState)state {
    UkeDrawingState drawingState = UkeDrawingStateUnknown;
    if (state == UIGestureRecognizerStateBegan) {
        drawingState = UkeDrawingStateStart;
    }else if (state == UIGestureRecognizerStateChanged) {
        drawingState = UkeDrawingStateDrawing;
    }else if (state == UIGestureRecognizerStateEnded ||
              state == UIGestureRecognizerStateCancelled ||
              state == UIGestureRecognizerStateFailed) {
        drawingState = UkeDrawingStateEnd;
    }
    return drawingState;
}

@end
