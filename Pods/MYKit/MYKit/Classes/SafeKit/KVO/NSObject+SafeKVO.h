//
//  NSObject+SafeKVO.h
//  MYKitDemo
//
//  Created by QMMac on 2018/7/30.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SafeKVO)

/**
 防护 KVO Crash
 */
+ (void)registerClassPairMethodsInKVO;

@end
