//
//  NSArray+Aspect.h
//  Footstone
//
//  Created by 李阳 on 8/3/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray <T> (Safe)

/**
 可变数组 crash 防护
 */
+ (void)registerClassPairMethodsInMutableArray;

@end
