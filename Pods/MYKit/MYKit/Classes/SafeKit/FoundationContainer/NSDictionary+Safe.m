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

@implementation NSDictionary (Safe)

+ (void)registerClassPairMethodsInDictionary {
    Class dictionaryClass = NSClassFromString(@"NSDictionary");
    Class __NSPlaceholderDictionaryClass = NSClassFromString(@"__NSPlaceholderDictionary");
    
    [self classSwizzleMethodWithClass:dictionaryClass orginalMethod:@selector(dictionaryWithObjects:forKeys:count:) replaceMethod:@selector(safe_dictionaryWithObjects:forKeys:count:)];
    
    [self classSwizzleMethodWithClass:dictionaryClass orginalMethod:@selector(dictionaryWithObjects:forKeys:) replaceMethod:@selector(safe_dictionaryWithObjects:forKeys:)];
    
    [self instanceSwizzleMethodWithClass:__NSPlaceholderDictionaryClass orginalMethod:@selector(initWithObjects:forKeys:count:) replaceMethod:@selector(safe_initWithObjects:forKeys:count:)];
}

+ (instancetype)safe_dictionaryWithObjects:(id _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt {
    NSUInteger index = 0;
    id  _Nonnull __unsafe_unretained newObjects[cnt];
    id  _Nonnull __unsafe_unretained newkeys[cnt];
    for (int i = 0; i < cnt; i++) {
        id tmpItem = objects[i];
        id tmpKey = keys[i];
        if (tmpItem == nil || tmpKey == nil) {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : NSDictionary constructor appear nil",
                                [self class], NSStringFromSelector(_cmd)];
            [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
            continue;
        }
        newObjects[index] = objects[i];
        newkeys[index] = keys[i];
        index++;
    }
    return [self safe_dictionaryWithObjects:objects forKeys:keys count:cnt];
}

+ (instancetype)safe_dictionaryWithObjects:(NSArray *)objects forKeys:(NSArray<id<NSCopying>> *)keys {
    if (objects.count != keys.count) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : count of objects (%ld) differs from count of keys (%ld)",
                            [self class], NSStringFromSelector(_cmd), (unsigned long)objects.count, (unsigned long)keys.count];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return nil;
    }
    NSUInteger index = 0;
    id _Nonnull objectsNew[objects.count];
    id <NSCopying> _Nonnull keysNew[keys.count];
    for (int i = 0; i<keys.count; i++) {
        if (objects[i] && keys[i]) {
            objectsNew[index] = objects[i];
            keysNew[index] = keys[i];
            index ++;
        } else {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : attempt to insert nil object from objects[%d]",
                                [self class], NSStringFromSelector(_cmd), i];
            [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        }
    }
    return [self safe_dictionaryWithObjects:[NSArray arrayWithObjects:objectsNew count:index] forKeys:[NSArray arrayWithObjects:keysNew count:index]];
}

- (instancetype)safe_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt{
    NSUInteger index = 0;
    id _Nonnull objectsNew[cnt];
    id <NSCopying> _Nonnull keysNew[cnt];
    //'*** -[NSDictionary initWithObjects:forKeys:]: count of objects (1) differs from count of keys (0)'
    for (int i = 0; i<cnt; i++) {
        if (objects[i] && keys[i]) { // 可能存在nil的情况
            objectsNew[index] = objects[i];
            keysNew[index] = keys[i];
            index ++;
        } else {
            NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : attempt to insert nil object from objects[%d]",
                                [self class], NSStringFromSelector(_cmd), i];
            [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        }
    }
    return [self safe_initWithObjects:objectsNew forKeys:keysNew count:index];
}

@end



