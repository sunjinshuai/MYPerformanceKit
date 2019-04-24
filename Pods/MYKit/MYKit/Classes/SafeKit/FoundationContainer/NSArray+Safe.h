//
//  NSArray+Aspect.h
//  Footstone
//
//  Created by 李阳 on 8/3/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 防御数组入参崩溃
 */
@interface NSArray <T> (Safe)

+ (void)registerClassPairMethodsInArray;

@end

