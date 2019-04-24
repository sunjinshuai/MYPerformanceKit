//
//  UINavigationController+BackButtonHandler.h
//  MYKitDemo
//
//  Created by michael on 2018/12/15.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
- (BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (ShouldPopOnBackButton) <BackButtonHandlerProtocol>

@end

@interface UINavigationController (BackButtonHandler)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar
        shouldPopItem:(UINavigationItem *)item;

@end
