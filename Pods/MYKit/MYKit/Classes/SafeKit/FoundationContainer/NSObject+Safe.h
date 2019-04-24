//
//  NSObject+Aspect.h
//  Footstone
//
//  Created by 李阳 on 11/3/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 防御 KVC KVO 崩溃
 */
@interface NSObject (Aspect)

+ (void)registerClassPairMethodsInObject;

@end
