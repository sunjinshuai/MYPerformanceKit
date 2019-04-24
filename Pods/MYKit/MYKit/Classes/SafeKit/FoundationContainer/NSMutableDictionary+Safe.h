//
//  NSDictionary+Safe.h
//  Footstone
//
//  Created by 李阳 on 4/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary <K, V> (Safe)

/**
 可变字典 crash 防护
 */
+ (void)registerClassPairMethodsInMutableDictionary;

@end
