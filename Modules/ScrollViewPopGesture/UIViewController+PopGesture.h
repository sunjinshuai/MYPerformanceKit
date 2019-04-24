//
//  UIViewController+PopGesture.h
//  MYPerformanceKit
//
//  Created by sunjinshuai on 2019/4/24.
//  Copyright © 2019 sunjinshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (PopGesture)<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@interface UIViewController (PopGesture)

/// 给view添加侧滑返回效果
- (void)addPopGestureToView:(UIView *)view;

/// 禁止该页面的侧滑返回
@property (nonatomic, assign) BOOL interactivePopDisabled;

@end

NS_ASSUME_NONNULL_END
