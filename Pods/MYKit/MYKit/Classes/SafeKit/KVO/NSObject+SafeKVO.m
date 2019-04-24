//
//  NSObject+SafeKVO.m
//  MYKitDemo
//
//  Created by QMMac on 2018/7/30.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import "NSObject+SafeKVO.h"
#import "NSObject+Swizzle.h"
#import "MYSafeKitRecord.h"
#import <dlfcn.h>
#include <CommonCrypto/CommonCrypto.h>
#include <zlib.h>

static inline NSString *kvo_md5StringOfObject(NSObject *object) {
    NSString *string = [NSString stringWithFormat:@"%p",object];
    const char *str = string.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", buffer[i]];
    }
    return output;
}

@interface KVOInfo : NSObject {
    @package
    void *_context;
    NSKeyValueObservingOptions _options;
    __weak NSObject *_observer;
    __weak NSString *_keyPath;
    NSString *_md5Str;
}

@end

@implementation KVOInfo

@end

@interface XXKVOProxy : NSObject {
    NSMutableDictionary<NSString*, NSMutableArray<NSObject *> *> *_keyPathMaps;
    
    dispatch_semaphore_t _addKvoProxyLock;
    dispatch_semaphore_t _removeKvoProxyLock;
}

/**
 将添加kvo时的相关信息加入到关系maps中，对应原有的添加观察者
 带成功和失败的回调
 */
- (void)addKVOInfoToMapsWithObserver:(NSObject *)observer
                          forKeyPath:(NSString *)keyPath
                             options:(NSKeyValueObservingOptions)options
                             context:(void *)context
                             success:(void(^)(void))success
                             failure:(void(^)(NSString *error))failure;

/**
 从关系maps中移除观察者 对应原有的移除观察者操作
 */
- (void)removeKVOInfoInMapsWithObserver:(NSObject *)observer
                             forKeyPath:(NSString *)keyPath
                                success:(void(^)(void))success
                                failure:(void(^)(NSString *error))failure;

/**
 获取所有对应的keyPaths
 */
- (NSArray *)getAllKeypaths;

@end

@implementation XXKVOProxy

- (instancetype)init {
    if (self = [super init]) {
        _keyPathMaps = [NSMutableDictionary dictionary];
        _addKvoProxyLock = dispatch_semaphore_create(1);
        _removeKvoProxyLock = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)addKVOInfoToMapsWithObserver:(NSObject *)observer
                          forKeyPath:(NSString *)keyPath
                             options:(NSKeyValueObservingOptions)options
                             context:(void *)context
                             success:(void(^)(void))success
                             failure:(void(^)(NSString *error))failure {
    dispatch_semaphore_wait(_addKvoProxyLock, DISPATCH_TIME_FOREVER);
    // 先判断有没有重复添加，上报 KVO 多次添加，没有的话，添加到数组中
    NSMutableArray <NSObject *> *kvoInfos = [self getKVOInfosForKeypath:keyPath];
    
    // 多次添加 KVO
    if (kvoInfos.count > 0) {
        
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : KVO add Observer to many timers.",
                            [self class], NSStringFromSelector(_cmd)];
        if (failure) {
            failure(reason);
        }
    } else {
        KVOInfo *info = [[KVOInfo alloc]init];
        info->_observer = observer;
        info->_md5Str = kvo_md5StringOfObject(observer);
        info->_keyPath = keyPath;
        info->_options = options;
        info->_context = context;
        [kvoInfos addObject:info];
        
        // 设置keyPath对应的观察者数组
        if (![_keyPathMaps.allKeys containsObject:keyPath]) {
            if (keyPath) {
                _keyPathMaps[keyPath] = kvoInfos;
            }
        }
        if (success) {
            success();
        }
    }
    dispatch_semaphore_signal(_addKvoProxyLock);
}

- (void)removeKVOInfoInMapsWithObserver:(NSObject *)observer
                             forKeyPath:(NSString *)keyPath
                                success:(void(^)(void))success
                                failure:(void(^)(NSString *error))failure {
    
    dispatch_semaphore_wait(_removeKvoProxyLock, DISPATCH_TIME_FOREVER);
    
    NSMutableArray <NSObject *> *kvoInfos = [self getKVOInfosForKeypath:keyPath];
    
    if (kvoInfos.count == 0) {
        
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : KVO remove Observer to many times.",
                            [self class], NSStringFromSelector(_cmd)];
        
        if (failure) {
            failure(reason);
        }
    } else {
        
        KVOInfo *kvoInfo;
        for (KVOInfo *obj in kvoInfos) {
            if ([obj->_md5Str isEqualToString:kvo_md5StringOfObject(observer)]) {
                kvoInfo = obj;
                break;
            }
        }
        if (kvoInfo) {
            [kvoInfos removeObject:kvoInfo];
            if (kvoInfos.count == 0) { // 说明该keypath没有observer观察，可以移除该键
                [_keyPathMaps removeObjectForKey:keyPath];
            }
        }
        if (success) {
            success();
        }
    }
    dispatch_semaphore_signal(_removeKvoProxyLock);
}

/**
 获取keypath对应的所有观察者
 */
- (NSMutableArray *)getKVOInfosForKeypath:(NSString *)keypath {
    if ([_keyPathMaps.allKeys containsObject:keypath]) {
        return [_keyPathMaps objectForKey:keypath];
    } else {
        return [NSMutableArray array];
    }
}

/**
 获取所有被观察的keypaths
 */
- (NSArray *)getAllKeypaths{
    NSArray <NSString *>*keyPaths = _keyPathMaps.allKeys;
    return keyPaths;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSMutableArray <KVOInfo *> *kvoInfos = [self getKVOInfosForKeypath:keyPath];
    for (NSObject *observer in kvoInfos) {
        @try {
            [observer observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        } @catch (NSException *exception) {
            NSString *reason = [NSString stringWithFormat:@"non fatal Error%@",[exception description]];
            [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeKVO)];
        }
    }
}

@end

@implementation NSObject (SafeKVO)

static void *KVOProtectorKey = &KVOProtectorKey;
static NSString *const KVOProtectorValue = @"KVOProtectorValue";

+ (void)registerClassPairMethodsInKVO {
    [self instanceSwizzleMethod:@selector(addObserver:forKeyPath:options:context:) replaceMethod:@selector(safe_addObserver:forKeyPath:options:context:)];
    
    [self instanceSwizzleMethod:@selector(removeObserver:forKeyPath:) replaceMethod:@selector(safe_removeObserver:forKeyPath:)];
    
    [self instanceSwizzleMethod:@selector(removeObserver:forKeyPath:context:) replaceMethod:@selector(safe_removeObserver:forKeyPath:context:)];
    
    [self instanceSwizzleMethod:NSSelectorFromString(@"dealloc") replaceMethod:@selector(safeKvo_dealloc)];
}

- (void)safe_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    static struct dl_info app_info;
    if (app_info.dli_saddr == NULL) {
        dladdr((__bridge void *)[UIApplication.sharedApplication.delegate class], &app_info);
    }
    struct dl_info self_info = {0};
    dladdr((__bridge void *)[self class], &self_info);
    
    //    ignore system class
    if (self_info.dli_fname == NULL || strcmp(app_info.dli_fname, self_info.dli_fname)) {
        [self safe_addObserver:observer forKeyPath:keyPath options:options context:context];
    } else {
        __weak typeof(self) weakSelf = self;
        objc_setAssociatedObject(self, KVOProtectorKey, KVOProtectorValue, OBJC_ASSOCIATION_RETAIN);
        [self.kvoProxy addKVOInfoToMapsWithObserver:observer forKeyPath:keyPath options:options context:context success:^{
            [weakSelf safe_addObserver:weakSelf.kvoProxy forKeyPath:keyPath options:options context:context];
        } failure:^(NSString *error) {
            [MYSafeKitRecord recordFatalWithReason:error errorType:MYSafeKitShieldTypeKVO];
        }];
    }
}

- (void)safe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    static struct dl_info app_info;
    if (app_info.dli_saddr == NULL) {
        dladdr((__bridge void *)[UIApplication.sharedApplication.delegate class], &app_info);
    }
    struct dl_info self_info = {0};
    dladdr((__bridge void *)[self class], &self_info);
    
    //    ignore system class
    if (self_info.dli_fname == NULL || strcmp(app_info.dli_fname, self_info.dli_fname)) {
        [self safe_removeObserver:observer forKeyPath:keyPath];
    } else {
        [self.kvoProxy removeKVOInfoInMapsWithObserver:observer forKeyPath:keyPath success:^{
            [self safe_removeObserver:self.kvoProxy forKeyPath:keyPath];
        } failure:^(NSString *error) {
            [MYSafeKitRecord recordFatalWithReason:error errorType:MYSafeKitShieldTypeKVO];
        }];
    }
}

- (void)safe_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context {
    static struct dl_info app_info;
    if (app_info.dli_saddr == NULL) {
        dladdr((__bridge void *)[UIApplication.sharedApplication.delegate class], &app_info);
    }
    struct dl_info self_info = {0};
    dladdr((__bridge void *)[self class], &self_info);
    
    //    ignore system class
    if (self_info.dli_fname == NULL || strcmp(app_info.dli_fname, self_info.dli_fname)) {
        [self safe_removeObserver:observer forKeyPath:keyPath context:context];
    } else {
        [self.kvoProxy removeKVOInfoInMapsWithObserver:observer forKeyPath:keyPath success:^{
            [self safe_removeObserver:self.kvoProxy forKeyPath:keyPath];
        } failure:^(NSString *error) {
            [MYSafeKitRecord recordFatalWithReason:error errorType:MYSafeKitShieldTypeKVO];
        }];
    }
}

- (void)safeKvo_dealloc {
    static struct dl_info app_info;
    if (app_info.dli_saddr == NULL) {
        dladdr((__bridge void *)[UIApplication.sharedApplication.delegate class], &app_info);
    }
    struct dl_info self_info = {0};
    dladdr((__bridge void *)[self class], &self_info);
    
    //    ignore system class
    if (self_info.dli_fname == NULL || strcmp(app_info.dli_fname, self_info.dli_fname)) {
        [self safeKvo_dealloc];
    } else {
        NSString *value = (NSString *)objc_getAssociatedObject(self, KVOProtectorKey);
        if ([value isEqualToString:KVOProtectorValue]) {
            NSArray *keypaths = [self.kvoProxy getAllKeypaths];
            if (keypaths.count > 0) {
                NSString *reason = [NSString stringWithFormat:@"****** Waring ***** \n An instance %@ was deallocated while key value observers were still registered with it. The Keypaths is:%@", self.class, [keypaths componentsJoinedByString:@","]];
                [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeKVO)];
            }
            for (NSString *keyPath in keypaths) {
                // 手动移除没有移除的监听者
                [self safe_removeObserver:self.kvoProxy forKeyPath:keyPath];
            }
        }
    }
}

- (void)setKvoProxy:(XXKVOProxy *)kvoProxy {
    objc_setAssociatedObject(self, @selector(kvoProxy), kvoProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (XXKVOProxy *)kvoProxy {
    XXKVOProxy *getKvoProxy = objc_getAssociatedObject(self, @selector(kvoProxy));
    if (!getKvoProxy) {
        getKvoProxy = [[XXKVOProxy alloc] init];
        objc_setAssociatedObject(self, @selector(kvoProxy), getKvoProxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return getKvoProxy;
}

@end
