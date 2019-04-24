//
//  MYKitDefinition.h
//  MYKitDemo
//
//  Created by michael on 2019/2/12.
//  Copyright © 2019 com.51fanxing. All rights reserved.
//

#ifndef MYKitDefinition_h
#define MYKitDefinition_h

// 系统版本
#define ITG_SYSTEM_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]
#define ITG_IOS_8   (ITG_SYSTEM_VERSION >= 7.0 && ITG_SYSTEM_VERSION < 8.0)
#define ITG_IOS_9   (ITG_SYSTEM_VERSION >= 8.0 && ITG_SYSTEM_VERSION < 9.0)
#define ITG_IOS_10  (ITG_SYSTEM_VERSION >= 10.0 && ITG_SYSTEM_VERSION < 11.0)
#define ITG_IOS_11  (ITG_SYSTEM_VERSION >= 11.0 && ITG_SYSTEM_VERSION < 12.0)
#define ITG_IOS_12  (ITG_SYSTEM_VERSION >= 12.0 && ITG_SYSTEM_VERSION < 13.0)

#define ITG_IOS_AT_LEAST_8  (ITG_SYSTEM_VERSION >= 8.0)
#define ITG_IOS_AT_LEAST_9  (ITG_SYSTEM_VERSION >= 9.0)
#define ITG_IOS_AT_LEAST_10 (ITG_SYSTEM_VERSION >= 10.0)
#define ITG_IOS_AT_LEAST_11 (ITG_SYSTEM_VERSION >= 11.0)
#define ITG_IOS_AT_LEAST_12 (ITG_SYSTEM_VERSION >= 12.0)

// 型号
#define ITG_DEVICE_IPAD         (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define ITG_DEVICE_IPHONE       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

// 特殊手机型号, 刘海屏: iPhoneX, iPhone XS, iPhone XR...
// 获取底部安全区域高度，iPhone X 竖屏下为 34.0，横屏下为 21.0，其他类型设备都为 0
#define ITG_DEVICE_IPHONE_X \
({  \
BOOL isIPhoneX = NO;    \
if (@available(iOS 11.0, *)) {  \
UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];    \
BOOL isDeviceX = NO;    \
CGFloat bottomSafeInset = keyWindow.safeAreaInsets.bottom;  \
isDeviceX = bottomSafeInset == 34.0f || bottomSafeInset == 21.0f;  \
isIPhoneX = isDeviceX && ITG_DEVICE_IPHONE;\
}   \
(isIPhoneX);    \
})  \

// 特殊手机型号, 小手机: iPhone4S, iPhone5S... (屏幕为3.5英寸或者4英寸)
#define ITG_DEVICE_IPHONE_SMALL (ITG_DEVICE_IPHONE && (ITG_DEFALUT_SCREEN_WIDTH == 320 || ITG_DEFALUT_SCREEN_HEIGHT == 320))

// 屏幕方向
#define ITG_DEVICE_STATUS_BAR_ORIENTATION   [[UIApplication sharedApplication] statusBarOrientation]
#define ITG_DEVICE_PORTRAIT \
(ITG_DEVICE_STATUS_BAR_ORIENTATION == UIInterfaceOrientationPortrait || ITG_DEVICE_STATUS_BAR_ORIENTATION == UIDeviceOrientationPortraitUpsideDown)
#define ITG_DEVICE_LANDSCAPE \
(ITG_DEVICE_STATUS_BAR_ORIENTATION == UIDeviceOrientationLandscapeRight || ITG_DEVICE_STATUS_BAR_ORIENTATION == UIDeviceOrientationLandscapeLeft)

// 像素
#define ITG_DEFALUT_SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define ITG_DEFALUT_SCREEN_HEIGHT    [[UIScreen mainScreen] bounds].size.height
#define ITG_DEFALUT_STATUSBAR_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height
#define ITG_ORIENTATION_SCREEN_WIDTH   MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define ITG_ORIENTATION_SCREEN_HEIGHT  MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)

// 默认设计稿像素
#define ITG_DEFALUT_PHONE_SCALE_PX 375.0
#define ITG_DEFALUT_PAD_SCALE_PX   1024.0

// 比例像素
#define ITG_PHONE_SCALE_PX(value)  ceil((value / (ITG_DEFALUT_PHONE_SCALE_PX / [UIScreen mainScreen].bounds.size.width)))
#define ITG_PAD_SCALE_PX(value)    ceil((value / (ITG_DEFALUT_PAD_SCALE_PX / [UIScreen mainScreen].bounds.size.width)))
#define ITG_ORIENTATION_PHONE_SCALE_PX(value)  ceil((value / (ITG_DEFALUT_PHONE_SCALE_PX / ITG_ORIENTATION_SCREEN_WIDTH)))

// 字体
#define ITG_DEFALUT_FONT(size)      [UIFont systemFontOfSize:size]
#define ITG_DEFALUT_BOLD_FONT(size) [UIFont boldSystemFontOfSize:size]
#define ITG_PF_REGULAR_FONT(_size_) [UIFont fontWithName:@"PingFangSC-Regular" size:_size_]
#define ITG_PF_MEDIUM_FONT(_size_)  [UIFont fontWithName:@"PingFangSC-Medium" size:_size_]

// 颜色
// RGBA
#define ITG_COLOR_RGBA(r, g, b ,a) \
[UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define ITG_COLOR_RGB(r, g, b)  ITG_COLOR_RGBA(r, g, b, 1.0)

// 16进制
#define ITG_COLOR_HEXA(hex, a) \
[UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:a]
#define ITG_COLOR_HEX(hex)  ITG_COLOR_HEXA(hex, 1.0)

// 设备适配
#define ITGSafeAreaInsets() \
({ \
UIEdgeInsets insets; \
if (@available(iOS 11.0, *)) { \
insets = UIApplication.sharedApplication.keyWindow.safeAreaInsets; \
} else { \
insets = UIEdgeInsetsZero; \
} \
(insets); \
}) \

#endif /* MYKitDefinition_h */
