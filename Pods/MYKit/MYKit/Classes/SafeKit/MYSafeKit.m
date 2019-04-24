//
//  MYSafeKit.m
//  MYKitDemo
//
//  Created by QMMac on 2018/6/26.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import "MYSafeKit.h"
#import "MYSafeKitRecord.h"
#import "MYSafeFoundationContainer.h"
#import "NSObject+UnknowSelector.h"
#import "NSTimer+Safe.h"
#import "NSObject+SafeKVO.h"
#import "NSNotificationCenter+SafeKit.h"
#import "NSNull+Safe.h"

@implementation MYSafeKit

+ (void)registerSafeKitShield {
    [self registerSafeKitShieldWithAbility:(MYSafeKitShieldTypeAll)];
}

+ (void)registerSafeKitShieldWithAbility:(MYSafeKitShieldType)ability {
    if (ability & MYSafeKitShieldTypeUnrecognizedSelector) {
        [self registerUnrecognizedSelector];
    }
    if (ability & MYSafeKitShieldTypeContainer) {
        [self registerContainer];
    }
    if (ability & MYSafeKitShieldTypeKVO) {
        [self registerKVO];
    }
    if (ability & MYSafeKitShieldTypeNotification) {
        [self registerNotification];
    }
    if (ability & MYSafeKitShieldTypeTimer) {
        [self registerTimer];
    }
    
    if (ability & MYSafeKitShieldTypeNull) {
        [self registerNull];
    }
}

+ (void)registerContainer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [MYSafeFoundationContainer safeGuardContainersSelector];
    });
}

+ (void)registerUnrecognizedSelector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject safeGuardUnrecognizedSelector];
    });
}

+ (void)registerKVO {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSObject registerClassPairMethodsInKVO];
    });
}

+ (void)registerNotification {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSNotificationCenter safeGuardNotificationSelector];
    });
}

+ (void)registerTimer {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSTimer registerClassPairMethodsInTimer];
    });
}

+ (void)registerNull {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSNull safeGuardNSNull];
    });
}

+ (void)registerRecordHandler:(nonnull id<MYSafeKitRecordProtocol>)record {
    [MYSafeKitRecord registerRecordHandler:record];
}

@end
