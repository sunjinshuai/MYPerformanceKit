//
//  NSNotificationCenter+SafeKit.m
//  MYKitDemo
//
//  Created by QMMac on 2018/6/19.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import "NSNotificationCenter+SafeKit.h"
#import "NSObject+Swizzle.h"

@interface XXObserverRemover : NSObject

@end

@implementation XXObserverRemover {
    __strong NSMutableArray *_centers;
    __unsafe_unretained id _obs;
}

- (instancetype)initWithObserver:(id)obs {
    if (self = [super init]) {
        _obs = obs;
        _centers = @[].mutableCopy;
    }
    return self;
}

- (void)addCenter:(NSNotificationCenter *)center {
    if (center) {
        [_centers addObject:center];
    }
}

- (void)dealloc {
    @autoreleasepool {
        for (NSNotificationCenter *center in _centers) {
            [center removeObserver:_obs];
        }
    }
}

@end

@implementation NSNotificationCenter (SafeKit)

+ (void)safeGuardNotificationSelector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self instanceSwizzleMethod:@selector(addObserver:selector:name:object:) replaceMethod:@selector(safe_addObserver:selector:name:object:)];
    });
}

- (void)safe_addObserver:(id)observer selector:(SEL)aSelector name:(nullable NSNotificationName)aName object:(nullable id)anObject {

    [self safe_addObserver:observer selector:aSelector name:aName object:anObject];
    
    addCenterForObserver(self, observer);
}

// why autorelasePool
// an instance life dead
// *********************1 release property
// *********************2 remove AssociatedObject
// *********************3 destory self
// Once u want use assobciedObject's dealloc method do something ,
// must in a custome autorelease Pool let associate
// release immediately.
// AssociatedObject retain source target  strategy must be __unsafe_unretain. (weak will be nil )
void addCenterForObserver(NSNotificationCenter *center ,id obs) {
    XXObserverRemover *remover = nil;
    static char removerKey;
    
    @autoreleasepool {
        remover = objc_getAssociatedObject(obs, &removerKey);
        if (!remover) {
            remover = [[XXObserverRemover alloc] initWithObserver:obs];
            objc_setAssociatedObject(obs, &removerKey, remover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [remover addCenter:center];
    }
}

@end
