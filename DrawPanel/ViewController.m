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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1000;
    [button setTitle:@"上一页" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, CGRectGetMaxY(seg.frame), 100, 44.0);
    button.layer.cornerRadius = 4;
    button.layer.borderColor = [UIColor blueColor].CGColor;
    button.layer.borderWidth = 1.0;
    [button addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = 1001;
    [button2 setTitle:@"下一页" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    button2.frame = CGRectMake(375-100, CGRectGetMaxY(seg.frame), 100, 44.0);
    button2.layer.cornerRadius = 4;
    button2.layer.borderColor = [UIColor blueColor].CGColor;
    button2.layer.borderWidth = 1.0;
    [button2 addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    bgView.layer.masksToBounds = YES;
    bgView.frame = CGRectMake(0, CGRectGetMaxY(button.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-44.0*2);
    bgView.image = [UIImage imageNamed:@"test.jpeg"];
    [self.view addSubview:bgView];
    
    UkeDrawingDisplayPanel *panel = [[UkeDrawingDisplayPanel alloc] init];
    panel.frame = CGRectMake(0, CGRectGetMaxY(button.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-44.0*2);
    [self.view addSubview:panel];
    _panel = panel;
    
    [seg setSelectedSegmentIndex:0];
    [panel switchDrawingMode:UkeDrawingModeLine];
}

- (void)handleSegAction:(UISegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    [_panel switchDrawingMode:index];
}

- (void)handleButtonAction:(UIButton *)button {
    if (button.tag == 1000) {
        [_panel turnToPreviousPage];
    }else if (button.tag == 1001) {
        [_panel turnToNextPage];
    }
}

@end
