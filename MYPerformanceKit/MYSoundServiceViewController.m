//
//  MYSoundServiceViewController.m
//  MYPerformanceKit
//
//  Created by sunjinshuai on 2019/4/21.
//  Copyright © 2019 sunjinshuai. All rights reserved.
//

#import "MYSoundServiceViewController.h"
#import "MYSoundService.h"

@interface MYSoundServiceViewController ()

@end

@implementation MYSoundServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"声音播放";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.backgroundColor = [UIColor blueColor];
    playButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2, 250, 100, 50);
    [playButton setTitle:@"播放声音" forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playSoundTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    UIButton *telephoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    telephoneButton.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100)/2, CGRectGetMaxY(playButton.frame) + 50, 100, 50);
    telephoneButton.backgroundColor = [UIColor blueColor];
    [telephoneButton setTitle:@"拨打电话" forState:UIControlStateNormal];
    [telephoneButton addTarget:self action:@selector(phoneCallTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:telephoneButton];
}

- (void)playSoundTapped:(UIButton *)sender {
    [[MYSoundService sharedInstance] playSoundWithName:@"brithdayMusic" ofType:@"mp3"];
}

- (void)phoneCallTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://+8618600881435"]]
                                       options:@{
                                                 UIApplicationOpenURLOptionUniversalLinksOnly : @YES
                                                 }
                             completionHandler:nil];
}

@end
