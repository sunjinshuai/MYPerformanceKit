//
//  UILabel+LineSpacing.h
//  MYKitDemo
//
//  Created by QMMac on 2018/7/20.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 此分类适合Label文本指定的行数，行间距等
 */
@interface UILabel (LineSpacing)

// 请不要将属性名称取为lineSpacing，UILabel已有此隐藏属性。
@property (nonatomic, assign) CGFloat lineSpace;

+ (void)registerLineSpacingSelector;

@end
