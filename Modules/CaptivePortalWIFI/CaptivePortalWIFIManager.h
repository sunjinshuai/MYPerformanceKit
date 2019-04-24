//
//  CaptivePortalWIFIManager.h
//  MYPerformanceKit
//
//  Created by sunjinshuai on 2019/4/24.
//  Copyright © 2019 sunjinshuai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CaptivePortalWIFIManager : NSObject

+ (instancetype)sharedInstance;

/// 开启测试模式，开启后，每次验证都会提示需要认证WIFI
@property (assign, nonatomic) BOOL openTestMode;

/**
 *  检查当前wifi是否需要验证密码
 *  needAlert: 为YES时，若当前wifi需要验证密码，则会弹出警告框提示用户
 */
- (void)checkIsWifiNeedAuthPasswordWithComplection:(void (^)(BOOL needAuthPassword))complection
                                         needAlert:(BOOL)needAlert;

@end

NS_ASSUME_NONNULL_END
