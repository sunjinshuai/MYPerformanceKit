//
//  UIView+Badge.h
//  MYKitDemo
//
//  Created by sunjinshuai on 2017/12/29.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Badge)

/**
 添加一个红点
 
 @param radius 圆角半径
 @param offsetX x
 @param offsetY y
 */
- (void)addBadgeWithRadius:(CGFloat)radius
                   offsetX:(CGFloat)offsetX
                   offsetY:(CGFloat)offsetY;

/**
 显示一个红点
 
 @param radius 圆角半径
 @param offsetX x
 @param offsetY y
 */
- (void)showBadgeWithRadius:(CGFloat)radius
                    offsetX:(CGFloat)offsetX
                    offsetY:(CGFloat)offsetY;


/**
 显示带数字的红点
 
 @param badgeValue 数字
 @param offsetX x
 @param offsetY y
 */
- (void)showBadgeValue:(NSString *)badgeValue
               offsetX:(CGFloat)offsetX
               offsetY:(CGFloat)offsetY;

/**
 显示
 */
- (void)showBadge;

/**
 隐藏
 */
- (void)hiddenBadge;

@end

NS_ASSUME_NONNULL_END
