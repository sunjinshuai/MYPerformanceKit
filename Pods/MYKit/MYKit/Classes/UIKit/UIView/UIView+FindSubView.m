//
//  UIView+FindSubView.m
//  MYKitDemo
//
//  Created by sunjinshuai on 2017/11/18.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import "UIView+FindSubView.h"

@implementation UIView (FindSubView)

+ (BOOL)intersectsWithOtherView:(UIView *)otherView anotherView:(UIView *)anotherView {
    // 先转换为相对于窗口的坐标，然后进行判断是否重合
    CGRect selfRect = [otherView convertRect:otherView.bounds toView:nil];
    CGRect viewRect = [anotherView convertRect:anotherView.bounds toView:nil];
    return CGRectIntersectsRect(selfRect, viewRect);
}

- (BOOL)intersectsWithView:(UIView *)view {
    // 先转换为相对于窗口的坐标，然后进行判断是否重合
    CGRect selfRect = [self convertRect:self.bounds toView:nil];
    CGRect viewRect = [view convertRect:view.bounds toView:nil];
    return CGRectIntersectsRect(selfRect, viewRect);
}

- (NSArray *)subviewsWithClass:(Class)cls {
    NSMutableArray *subviews = [NSMutableArray array];
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:cls]) {
            [subviews addObject:subview];
            [subviews addObjectsFromArray:[subview subviewsWithClass:cls]];
        }
    }
    return subviews;
}

+ (NSArray<UIView *> *)findCommonSuperView:(UIView *)viewOne other:(UIView *)viewOther {
    NSMutableArray *result = [NSMutableArray array];
    
    // 查找第一个视图的所有父视图
    NSArray *arrayOne = [self findSuperViews:viewOne];
    // 查找第二个视图的所有父视图
    NSArray *arrayOther = [self findSuperViews:viewOther];
    
    int i = 0;
    // 越界限制条件
    while (i < MIN((int)arrayOne.count, (int)arrayOther.count)) {
        // 倒序方式获取各个视图的父视图
        UIView *superOne = [arrayOne objectAtIndex:arrayOne.count - i - 1];
        UIView *superOther = [arrayOther objectAtIndex:arrayOther.count - i - 1];
        
        // 比较如果相等 则为共同父视图
        if (superOne == superOther) {
            [result addObject:superOne];
            i++;
        }
        // 如果不相等，则结束遍历
        else {
            break;
        }
    }
    
    return result;
}

+ (NSArray <UIView *> *)findSuperViews:(UIView *)view {
    // 初始化为第一父视图
    UIView *temp = view.superview;
    // 保存结果的数组
    NSMutableArray *result = [NSMutableArray array];
    while (temp) {
        [result addObject:temp];
        // 顺着superview指针一直向上查找
        temp = temp.superview;
    }
    return result;
}

@end
