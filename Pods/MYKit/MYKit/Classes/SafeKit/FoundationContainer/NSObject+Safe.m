//
//  NSObject+Aspect.m
//  Footstone
//
//  Created by 李阳 on 11/3/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "NSObject+Safe.h"
#import <objc/message.h>
#import "NSObject+Swizzle.h"

@implementation NSObject (Aspect)

+ (void)registerClassPairMethodsInObject {
    Class objectClass = NSClassFromString(@"NSObject");
    
    [self instanceSwizzleMethodWithClass:objectClass orginalMethod:@selector(setValue:forKey:) replaceMethod:@selector(safe_setValue:forKey:)];
    
    [self instanceSwizzleMethodWithClass:objectClass orginalMethod:@selector(setValue:forKeyPath:) replaceMethod:@selector(safe_setValue:forKeyPath:)];
    
    [self instanceSwizzleMethodWithClass:objectClass orginalMethod:@selector(valueForKey:) replaceMethod:@selector(safe_valueForKey:)];
    
    [self instanceSwizzleMethodWithClass:objectClass orginalMethod:@selector(valueForKeyPath:) replaceMethod:@selector(safe_valueForKeyPath:)];
}

- (void)safe_setValue:(nullable id)value forKey:(NSString *)key {
    if (!value) {
        NSLog(@"\"%@\"-value:(%@) can not be nil", NSStringFromSelector(_cmd), value);
        return;
    }
    if (!key) {
        NSLog(@"\"%@\"-key:(%@) can not be nil", NSStringFromSelector(_cmd), key);
        return;
    }
    [self safe_setValue:value forKey:key];
}

- (void)safe_setValue:(nullable id)value forKeyPath:(NSString *)keyPath {
    if (!value) {
        NSLog(@"\"%@\"-value:(%@) can not be nil", NSStringFromSelector(_cmd), value);
        return;
    }
    if (!keyPath) {
        NSLog(@"\"%@\"-keyPath:(%@) can not be nil", NSStringFromSelector(_cmd), keyPath);
        return;
    }
    [self safe_setValue:value forKeyPath:keyPath];
}

- (id)safe_valueForKey:(NSString *)key {
    if (!key) {
        NSLog(@"\"%@\"-key:(%@) can not be nil", NSStringFromSelector(_cmd), key);
        return nil;
    }
    return [self safe_valueForKey:key];
}

- (nullable id)safe_valueForKeyPath:(NSString *)keyPath {
    if (!keyPath) {
        NSLog(@"\"%@\"-keyPath:(%@) can not be nil", NSStringFromSelector(_cmd), keyPath);
        return nil;
    }
    return [self safe_valueForKeyPath:keyPath];
}

- (nullable id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"\"%@\"-parameter0:(%@) not found", NSStringFromSelector(_cmd), key);
    return nil;
}

- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
    NSLog(@"\"%@\"-parameter0:(%@)  set %@ forKey %@ not found", NSStringFromSelector(_cmd), key, value, key);
}

- (void)setNilValueForKey:(NSString *)key {
    NSLog(@"\"%@\"-parameter0:(%@) set nil for key %@", NSStringFromSelector(_cmd), key, key);
}

@end



