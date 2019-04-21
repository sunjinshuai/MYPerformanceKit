//
//  MBProgressHUD+Extension.m
//  MYPerformanceKit
//
//  Created by sunjinshuai on 2019/4/21.
//  Copyright © 2019 sunjinshuai. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)

+ (void)showTipMessageInWindow:(NSString *)message {
    [self showTipMessage:message isWindow:true timer:2];
}

+ (void)showTipMessageInView:(NSString *)message {
    [self showTipMessage:message isWindow:false timer:2];
}

+ (void)showTipMessageInWindow:(NSString *)message timer:(int)aTimer {
    [self showTipMessage:message isWindow:true timer:aTimer];
}

+ (void)showTipMessageInView:(NSString *)message timer:(int)aTimer {
    [self showTipMessage:message isWindow:false timer:aTimer];
}

+ (void)showTipMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer {
    MBProgressHUD *hud = [self _createHUDWithMessage:message isWindow:isWindow];
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:aTimer];
}

+ (void)showActivityMessageInView {
    [self showActivityMessage:@"" isWindow:false timer:0];
}

+ (void)showActivityMessageInWindow {
    [self showActivityMessage:@"" isWindow:true timer:0];
}

+ (void)showActivityMessageInWindow:(NSString *)message {
    [self showActivityMessage:message isWindow:true timer:0];
}

+ (void)showActivityMessageInView:(NSString *)message {
    [self showActivityMessage:message isWindow:false timer:0];
}

+ (void)showActivityMessageInWindow:(NSString *)message timer:(int)aTimer {
    [self showActivityMessage:message isWindow:true timer:aTimer];
}

+ (void)showActivityMessageInView:(NSString *)message timer:(int)aTimer {
    [self showActivityMessage:message isWindow:false timer:aTimer];
}

+ (void)showActivityMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer {
    MBProgressHUD *hud = [self _createHUDWithMessage:message isWindow:isWindow];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (aTimer > 0) {
        [hud hideAnimated:YES afterDelay:aTimer];
    }
}

+ (void)showSuccessMessage:(NSString *)Message {
    NSString *name = @"success";
    [self showCustomIconInWindow:name message:Message];
}

+ (void)showErrorMessage:(NSString *)Message {
    NSString *name = @"error";
    [self showCustomIconInWindow:name message:Message];
}

+ (void)showInfoMessage:(NSString *)Message {
    NSString *name = @"info";
    [self showCustomIconInWindow:name message:Message];
}

+ (void)showWarnMessage:(NSString *)Message {
    NSString *name = @"warn";
    [self showCustomIconInWindow:name message:Message];
}

+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message {
    [self showCustomIcon:iconName message:message isWindow:true];
}

+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message {
    [self showCustomIcon:iconName message:message isWindow:false];
}

+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow {
    MBProgressHUD *hud = [self _createHUDWithMessage:message isWindow:isWindow];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    hud.mode = MBProgressHUDModeCustomView;
    [hud hideAnimated:YES afterDelay:2];
}

+ (void)hideHUD {
    UIView *window =(UIView *)[UIApplication sharedApplication].delegate.window;
    [self hideAllHUDsForView:window animated:YES];
    [self hideAllHUDsForView:[self getCurrentViewController].view animated:YES];
}

#pragma mark - private method
+ (MBProgressHUD *)_createHUDWithMessage:(NSString *)message isWindow:(BOOL)isWindow {
    UIView *view = isWindow ? (UIView *)[UIApplication sharedApplication].delegate.window:[self getCurrentViewController].view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = NO;
    return hud;
}

// 获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentWindowViewController {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    // app默认windowLevel是UIWindowLevelNormal，如果不是，找到它
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tempWindow in windows) {
            if (tempWindow.windowLevel == UIWindowLevelNormal) {
                window = tempWindow;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    // 1、通过present弹出VC，appRootVC.presentedViewController不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    } else {
        // 2、通过navigationcontroller弹出VC
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    return nextResponder;
}

+ (UINavigationController *)getCurrentNavigationController {
    UIViewController *viewVC = (UIViewController *)[self getCurrentWindowViewController];
    UINavigationController *naVC;
    if ([viewVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController*)viewVC;
        naVC = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        if (naVC.presentedViewController) {
            while (naVC.presentedViewController) {
                naVC = (UINavigationController *)naVC.presentedViewController;
            }
        }
    } else if ([viewVC isKindOfClass:[UINavigationController class]]) {
        naVC = (UINavigationController *)viewVC;
        if (naVC.presentedViewController) {
            while (naVC.presentedViewController) {
                naVC = (UINavigationController*)naVC.presentedViewController;
            }
        }
    } else if ([viewVC isKindOfClass:[UIViewController class]]) {
        if (viewVC.navigationController) {
            return viewVC.navigationController;
        }
        return (UINavigationController*)viewVC;
    }
    return naVC;
}

+ (UIViewController *)getCurrentViewController {
    UIViewController *cc;
    UINavigationController *na = (UINavigationController *)[[self class] getCurrentNavigationController];
    if ([na isKindOfClass:[UINavigationController class]]) {
        cc = na.viewControllers.lastObject;
        if (cc.childViewControllers.count > 0) {
            cc = [[self class] getSubViewController:cc];
        }
    } else {
        cc = (UIViewController*)na;
    }
    return cc;
}

+ (UIViewController *)getSubViewController:(UIViewController *)vc {
    UIViewController *cc;
    cc = vc.childViewControllers.lastObject;
    if (cc.childViewControllers > 0) {
        [[self class] getSubViewController:cc];
    } else {
        return cc;
    }
    return cc;
}

@end
