//
//  NSDictionary+Safe.m
//  Footstone
//
//  Created by 李阳 on 4/5/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import "NSObject+Swizzle.h"
#import "MYSafeKitRecord.h"

@implementation NSMutableDictionary (Safe)

+ (void)registerClassPairMethodsInMutableDictionary {

    Class dictionaryM = NSClassFromString(@"__NSDictionaryM");
    
    [self instanceSwizzleMethodWithClass:dictionaryM orginalMethod:@selector(setObject:forKey:) replaceMethod:@selector(safe_setObject:forKey:)];
    
    [self instanceSwizzleMethodWithClass:dictionaryM orginalMethod:@selector(removeObjectForKey:) replaceMethod:@selector(safe_removeObjectForKey:)];
    
    [self instanceSwizzleMethodWithClass:dictionaryM orginalMethod:@selector(setObject:forKeyedSubscript:) replaceMethod:@selector(safe_setObject:forKeyedSubscript:)];
}

- (void)safe_setObject:(id)anObject forKeyedSubscript:(id <NSCopying>)aKey {
    
    if (anObject && aKey) {
        [self safe_setObject:anObject forKeyedSubscript:aKey];
        return;
    } else {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : key or value appear nil- key is %@, obj is %@",
                            [self class], NSStringFromSelector(_cmd), aKey, anObject];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
    }
}

- (void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : \"-parameter0:(%@) cannot be nil",
                            [self class], NSStringFromSelector(_cmd), anObject];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    if (!aKey) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : \"-parameter1:(%@) cannot be nil",
                            [self class], NSStringFromSelector(_cmd), aKey];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    [self safe_setObject:anObject forKey:aKey];
}

- (void)safe_removeObjectForKey:(id)aKey {
    if (!aKey) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : \"-parameter0:(%@) cannot be nil",
                            [self class], NSStringFromSelector(_cmd), aKey];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    [self safe_removeObjectForKey:aKey];
}

@end

