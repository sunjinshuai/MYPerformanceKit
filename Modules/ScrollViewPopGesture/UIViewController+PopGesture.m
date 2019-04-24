//
//  UIViewController+PopGesture.m
//  MYPerformanceKit
//
//  Created by sunjinshuai on 2019/4/24.
//  Copyright © 2019 sunjinshuai. All rights reserved.
//

#import "UIViewController+PopGesture.h"
#import <MYKit/MYFoundationKit.h>

static char kNaviDelegateKey;
static char kPopDelegateKey;
static char kPopGestureRecognizerKey;
static char kInteractivePopDisabledKey;

@interface UINavigationController (PopGesturePrivate)

@property (nonatomic, weak, readonly) id naviDelegate;
@property (nonatomic, weak, readonly) id popDelegate;

@end

@implementation UINavigationController (PopGesture)

+ (void)load {
    [self instanceSwizzleMethodWithClass:self
                           orginalMethod:@selector(viewWillAppear:)
                           replaceMethod:@selector(swizzle_viewWillAppear:)];
}

- (void)swizzle_viewWillAppear:(BOOL)animated {
    [self swizzle_viewWillAppear:animated];
    
    // 只是为了触发tz_PopDelegate的get方法，获取到原始的interactivePopGestureRecognizer的delegate
    [self.popDelegate class];
    // 获取导航栏的代理
    [self.naviDelegate class];
    self.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.delegate = self.naviDelegate;
    });
}

- (id)popDelegate {
    id popDelegate = objc_getAssociatedObject(self, &kPopDelegateKey);
    if (!popDelegate) {
        popDelegate = self.interactivePopGestureRecognizer.delegate;
        objc_setAssociatedObject(self, &kPopDelegateKey, popDelegate, OBJC_ASSOCIATION_ASSIGN);
    }
    return popDelegate;
}

- (id)naviDelegate {
    id naviDelegate = objc_getAssociatedObject(self, &kNaviDelegateKey);
    if (!naviDelegate) {
        naviDelegate = self.delegate;
        if (naviDelegate) {
            objc_setAssociatedObject(self, &kNaviDelegateKey, naviDelegate, OBJC_ASSOCIATION_ASSIGN);
        }
    }
    return naviDelegate;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    if ([self.navigationController.transitionCoordinator isAnimated]) {
        return NO;
    }
    if (self.childViewControllers.count <= 1) {
        return NO;
    }
    UIViewController *vc = self.topViewController;
    if (vc.interactivePopDisabled) {
        return NO;
    }
    // 侧滑手势触发位置
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint offSet = [gestureRecognizer translationInView:gestureRecognizer.view];
    BOOL ret = (0 < offSet.x && location.x <= 40);
    // NSLog(@"%@ %@",NSStringFromCGPoint(location),NSStringFromCGPoint(offSet));
    return ret;
}

/// 只有当系统侧滑手势失败了，才去触发ScrollView的滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 转发给业务方代理
    if (self.naviDelegate && ![self.naviDelegate isEqual:self]) {
        if ([self.naviDelegate respondsToSelector:@selector(navigationController:
                                                            didShowViewController:
                                                            animated:)]) {
            [self.naviDelegate navigationController:navigationController
                              didShowViewController:viewController
                                           animated:animated];
        }
    }
    // 让系统的侧滑返回生效
    self.interactivePopGestureRecognizer.enabled = YES;
    if (self.childViewControllers.count > 0) {
        if (viewController == self.childViewControllers[0]) {
            self.interactivePopGestureRecognizer.delegate = self.popDelegate; // 不支持侧滑
        } else {
            self.interactivePopGestureRecognizer.delegate = nil; // 支持侧滑
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    // 转发给业务方代理
    if (self.naviDelegate && ![self.naviDelegate isEqual:self]) {
        if ([self.naviDelegate respondsToSelector:@selector(navigationController:
                                                            willShowViewController:
                                                            animated:)]) {
            [self.naviDelegate navigationController:navigationController
                             willShowViewController:viewController
                                           animated:animated];
        }
    }
}

@end

@interface UIViewController (PopGesturePrivate)

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *popGestureRecognizer;

@end

@implementation UIViewController (PopGesture)

- (void)addPopGestureToView:(UIView *)view {
    if (!view) return;
    if (!self.navigationController) {
        // 在控制器转场的时候，self.navigationController可能是nil,这里用GCD和递归来处理这种情况
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addPopGestureToView:view];
        });
    } else {
        UIPanGestureRecognizer *pan = self.popGestureRecognizer;
        if (![view.gestureRecognizers containsObject:pan]) {
            [view addGestureRecognizer:pan];
        }
    }
}

- (UIPanGestureRecognizer *)popGestureRecognizer {
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(self, &kPopGestureRecognizerKey);
    if (!pan) {
        // 侧滑返回手势 手势触发的时候，让target执行action
        id target = self.navigationController.popDelegate;
        SEL action = NSSelectorFromString(@"handleNavigationTransition:");
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
        pan.maximumNumberOfTouches = 1;
        pan.delegate = self.navigationController;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        objc_setAssociatedObject(self, &kPopGestureRecognizerKey, pan, OBJC_ASSOCIATION_ASSIGN);
    }
    return pan;
}

- (BOOL)interactivePopDisabled {
    return [objc_getAssociatedObject(self, &kInteractivePopDisabledKey) boolValue];
}

- (void)setInteractivePopDisabled:(BOOL)disabled {
    objc_setAssociatedObject(self, &kInteractivePopDisabledKey, @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
