//
//  UIView+Addition.h
//  MYKitDemo
//
//  Created by sunjinshuai on 2017/12/29.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MYGradientDirection) {
    MYGradientDirectionTopLeft = 0,
    MYGradientDirectionTop = 1,
    MYGradientDirectionLeft = 2,
};

@interface UIView (Addition)

- (void)setGradientBackgroundColors:(NSArray<UIColor *> *)colorArray direction:(MYGradientDirection)direction;

- (void)setGradientBackgroundColors:(NSArray<UIColor *> *)colorArray;

- (void)setGradientBackgroundColorFrom:(UIColor *)fromColor toColor:(UIColor *)toColor;

/*!
 *  @method snapshotImage
 *  截取view
 */
- (UIImage *)snapshotImage;

/*!
 *  @method snapshotImageInRect:
 *  截取view中rect范围的视图
 */
- (UIImage *)snapshotImageInRect:(CGRect)rect;

@end
