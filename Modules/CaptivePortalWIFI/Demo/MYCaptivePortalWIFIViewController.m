//
//  MYCaptivePortalWIFIViewController.m
//  MYPerformanceKit
//
//  Created by sunjinshuai on 2019/4/24.
//  Copyright © 2019 sunjinshuai. All rights reserved.
//

#import "MYCaptivePortalWIFIViewController.h"
#import "CaptivePortalWIFIManager.h"

@interface MYCaptivePortalWIFIViewController ()

@property (nonatomic, strong) UILabel *checkResultLabel;

@end

@implementation MYCaptivePortalWIFIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WIFT 检测";
    self.view.backgroundColor = [UIColor whiteColor];
    UISwitch *switchMode = [[UISwitch alloc] init];
    switchMode.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width - 100)/2
                                  ,
                                  200, 100, 50);
    [switchMode addTarget:self
                   action:@selector(testModeSwitchValueChanged:)
         forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchMode];
    
    UIButton *checkWifiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkWifiButton.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width - 200)/2
                                       ,
                                       CGRectGetMaxY(switchMode.frame) + 100,
                                       200,
                                       50);
    [checkWifiButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [checkWifiButton setTitle:@"检测当前网络是否需要注册" forState:UIControlStateNormal];
    [checkWifiButton addTarget:self action:@selector(checkWifiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkWifiButton];
    
    self.checkResultLabel = [UILabel new];
    self.checkResultLabel.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width - 300)/2
                                             ,
                                             CGRectGetMaxY(checkWifiButton.frame) + 20,
                                             300,
                                             50);
    self.checkResultLabel.textAlignment = NSTextAlignmentCenter;
    self.checkResultLabel.text = @"检测结果:---";
    [self.view addSubview:self.checkResultLabel];
}

- (void)testModeSwitchValueChanged:(UISwitch *)sender {
    [CaptivePortalWIFIManager sharedInstance].openTestMode = sender.isOn;
}

- (void)checkWifiButtonClick:(UIButton *)sender {
    self.checkResultLabel.text = @"认证中...";
    // TODO 如果当前网络状态不是WIFI，则无需检查
    [[CaptivePortalWIFIManager sharedInstance] checkIsWifiNeedAuthPasswordWithComplection:^(BOOL needAuthPassword) {
        self.checkResultLabel.text = needAuthPassword ? @"验证结果：需要认证" : @"验证结果：无需认证";
    } needAlert:YES];
}

@end
