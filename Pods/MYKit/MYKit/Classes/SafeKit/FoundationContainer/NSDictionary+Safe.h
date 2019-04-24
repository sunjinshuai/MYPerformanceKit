//
//  NSDictionary+Safe.h
//  Footstone
//
//  Created by 李阳 on 4/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary <K, V> (Safe)

/**
 字典 crash 防护
 */
+ (void)registerClassPairMethodsInDictionary;

@end

