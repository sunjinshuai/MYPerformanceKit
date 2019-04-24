//
//  NSString+Safe.h
//  MYKitDemo
//
//  Created by QMMac on 2018/7/30.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Safe)

/**
 String 防护 Crash
 */
+ (void)registerClassPairMethodsInString;

@end
