//
//  NSNotificationCenter+SafeKit.h
//  MYKitDemo
//
//  Created by QMMac on 2018/6/19.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (SafeKit)

/**
 防护 iOS 8 通知 carsh
 */
+ (void)safeGuardNotificationSelector;

@end
