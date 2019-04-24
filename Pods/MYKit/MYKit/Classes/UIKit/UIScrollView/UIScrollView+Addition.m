//
//  UIScrollView+Addition.m
//  MYKitDemo
//
//  Created by sunjinshuai on 2017/12/29.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import "UIScrollView+Addition.h"

@implementation UIScrollView (Addition)

#pragma mark - Content Offset

- (CGFloat)contentOffsetX {
    return self.contentOffset.x;
}

- (CGFloat)contentOffsetY {
    return self.contentOffset.y;
}

- (void)setContentOffsetX:(CGFloat)newContentOffsetX {
    self.contentOffset = CGPointMake(newContentOffsetX, self.contentOffsetY);
}

- (void)setContentOffsetY:(CGFloat)newContentOffsetY {
    self.contentOffset = CGPointMake(self.contentOffsetX, newContentOffsetY);
}

#pragma mark - Content Size

- (CGFloat)contentSizeWidth {
    return self.contentSize.width;
}

- (CGFloat)contentSizeHeight {
    return self.contentSize.height;
}

- (void)setContentSizeWidth:(CGFloat)newContentSizeWidth {
    self.contentSize = CGSizeMake(newContentSizeWidth, self.contentSizeHeight);
}

- (void)setContentSizeHeight:(CGFloat)newContentSizeHeight {
    self.contentSize = CGSizeMake(self.contentSizeWidth, newContentSizeHeight);
}

#pragma mark - Content Inset

- (CGFloat)contentInsetTop {
    return self.contentInset.top;
}

- (CGFloat)contentInsetRight {
    return self.contentInset.right;
}

- (CGFloat)contentInsetBottom {
    return self.contentInset.bottom;
}

- (CGFloat)contentInsetLeft {
    return self.contentInset.left;
}

- (void)setContentInsetTop:(CGFloat)newContentInsetTop {
    UIEdgeInsets newContentInset = self.contentInset;
    newContentInset.top = newContentInsetTop;
    self.contentInset = newContentInset;
}

- (void)setContentInsetRight:(CGFloat)newContentInsetRight {
    UIEdgeInsets newContentInset = self.contentInset;
    newContentInset.right = newContentInsetRight;
    self.contentInset = newContentInset;
}

- (void)setContentInsetBottom:(CGFloat)newContentInsetBottom {
    UIEdgeInsets newContentInset = self.contentInset;
    newContentInset.bottom = newContentInsetBottom;
    self.contentInset = newContentInset;
}

- (void)setContentInsetLeft:(CGFloat)newContentInsetLeft {
    UIEdgeInsets newContentInset = self.contentInset;
    newContentInset.left = newContentInsetLeft;
    self.contentInset = newContentInset;
}

@end
