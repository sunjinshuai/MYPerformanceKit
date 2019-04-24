//
//  NSObject+UnknowSelector.h
//  MYKitDemo
//
//  Created by QMMac on 2018/6/19.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject (UnknowSelector)

/**
 防护发送到未知的选择子到实例
 */
+ (void)safeGuardUnrecognizedSelector;

@end
