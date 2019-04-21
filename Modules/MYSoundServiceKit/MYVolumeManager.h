//
//  MYVolumeManager.h
//  MYUtils
//
//  Created by sunjinshuai on 2018/3/20.
//  Copyright © 2018年 com.51fanxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYVolumeManager : NSObject

@property (nonatomic, assign) CGFloat volumeValue;

+ (instancetype)shareInstance;

// 耳机状态监听
- (void)setAudioChangeNotification;
// 检测耳机状态 是否插入
- (BOOL)isHeadsetPluggedIn;
// 当前音量
- (float)getCurrentVolume;
// 移除 MPVolumeView
- (void)removeMPVolumeView;

@end
