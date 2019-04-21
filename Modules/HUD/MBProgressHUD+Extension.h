//
//  MBProgressHUD+Extension.h
//  MYPerformanceKit
//
//  Created by sunjinshuai on 2019/4/21.
//  Copyright © 2019 sunjinshuai. All rights reserved.
//

#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (Extension)

+ (void)showTipMessageInWindow:(NSString *)message;
+ (void)showTipMessageInView:(NSString *)message;
+ (void)showTipMessageInWindow:(NSString *)message timer:(int)aTimer;
+ (void)showTipMessageInView:(NSString *)message timer:(int)aTimer;

+ (void)showActivityMessageInView;
+ (void)showActivityMessageInWindow;
+ (void)showActivityMessageInWindow:(NSString *)message;
+ (void)showActivityMessageInView:(NSString *)message;
+ (void)showActivityMessageInWindow:(NSString *)message timer:(int)aTimer;
+ (void)showActivityMessageInView:(NSString *)message timer:(int)aTimer;

+ (void)showSuccessMessage:(NSString *)Message;
+ (void)showErrorMessage:(NSString *)Message;
+ (void)showInfoMessage:(NSString *)Message;
+ (void)showWarnMessage:(NSString *)Message;

+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message;
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message;

+ (void)hideHUD;

@end

NS_ASSUME_NONNULL_END
