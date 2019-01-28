//
//  ViewController.m
//  DrawPanel
//
//  Created by liqian on 2019/1/26.
//  Copyright © 2019 liqian. All rights reserved.
//

#import "ViewController.h"
#import "UkeDrawingDisplayPanel.h"

@interface ViewController ()
@property (nonatomic, strong) UkeDrawingDisplayPanel *panel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"线", @"线段", @"圆", @"框", @"文字", @"橡皮", @"框选删除", @"箭头", @"三角"]];
    seg.frame = CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 44.0);
    [seg addTarget:self action:@selector(handleSegAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    
    UkeDrawingDisplayPanel *panel = [[UkeDrawingDisplayPanel alloc] init];
    panel.frame = CGRectMake(0, CGRectGetMaxY(seg.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-44.0);
    [self.view addSubview:panel];
    _panel = panel;
    
    [seg setSelectedSegmentIndex:0];
    [panel switchDrawingMode:UkeDrawingModeLine];
}

- (void)handleSegAction:(UISegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    [_panel switchDrawingMode:index];
}

@end
