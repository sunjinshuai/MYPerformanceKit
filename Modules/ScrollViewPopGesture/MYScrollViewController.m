//
//  MYScrollViewController.m
//  MYPerformanceKit
//
//  Created by sunjinshuai on 2019/4/24.
//  Copyright © 2019 sunjinshuai. All rights reserved.
//

#import "MYScrollViewController.h"
#import "UIViewController+PopGesture.h"

@interface MYScrollViewController ()

@end

@implementation MYScrollViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configScrollView];
}

- (void)configScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    scrollView.contentSize = CGSizeMake(1000, 0);
    scrollView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:scrollView];
    
    // scrollView需要支持侧滑返回
    [self addPopGestureToView:scrollView];
    
    // 禁止该页面侧滑返回
    // self.tz_interactivePopDisabled = YES;
}

@end
