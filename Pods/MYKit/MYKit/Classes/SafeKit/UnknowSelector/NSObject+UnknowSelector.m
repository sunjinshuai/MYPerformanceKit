//
//  NSObject+UnknowSelector.m
//  MYKitDemo
//
//  Created by QMMac on 2018/6/19.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import "NSObject+UnknowSelector.h"
#import "NSObject+Swizzle.h"
#import "MYSafeKitRecord.h"
#import <dlfcn.h>

/**
 default Implement
 
 @param target trarget
 @param cmd cmd
 @param ... other param
 @return default Implement is zero
 */
int smartFunction(id target, SEL cmd, ...) {
    return 0;
}

static BOOL __addMethod(Class clazz, SEL sel) {
    NSString *selName = NSStringFromSelector(sel);
    
    NSMutableString *tmpString = [[NSMutableString alloc] initWithFormat:@"%@", selName];
    
    int count = (int)[tmpString replaceOccurrencesOfString:@":"
                                                withString:@"_"
                                                   options:NSCaseInsensitiveSearch
                                                     range:NSMakeRange(0, selName.length)];
    
    NSMutableString *val = [[NSMutableString alloc] initWithString:@"i@:"];
    
    for (int i = 0; i < count; i++) {
        [val appendString:@"@"];
    }
    const char *funcTypeEncoding = [val UTF8String];
    return class_addMethod(clazz, sel, (IMP)smartFunction, funcTypeEncoding);
}

@interface MYShieldStubObject : NSObject

- (instancetype)init __unavailable;

+ (MYShieldStubObject *)shareInstance;

- (BOOL)addFunc:(SEL)sel;

+ (BOOL)addClassFunc:(SEL)sel;

@end

@implementation MYShieldStubObject

+ (MYShieldStubObject *)shareInstance {
    static MYShieldStubObject *singleton;
    if (!singleton) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            singleton = [MYShieldStubObject new];
        });
    }
    return singleton;
}

- (BOOL)addFunc:(SEL)sel {
    return __addMethod([MYShieldStubObject class], sel);
}

+ (BOOL)addClassFunc:(SEL)sel {
    Class metaClass = objc_getMetaClass(class_getName([MYShieldStubObject class]));
    return __addMethod(metaClass, sel);
}

@end

@implementation NSObject (UnknowSelector)

+ (void)safeGuardUnrecognizedSelector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 防御对象实例方法
        [self instanceSwizzleMethod:@selector(forwardingTargetForSelector:) replaceMethod:@selector(safe_instanceMethod_forwardingTargetForSelector:)];
        
        // 防御对象类方法
        [self swizzleClassMethod:@selector(forwardingTargetForSelector:) replaceMethod:@selector(safe_classMethod_forwardingTargetForSelector:)];
    });
}

- (id)safe_instanceMethod_forwardingTargetForSelector:(SEL)aSelector {

    BOOL aBool = [self respondsToSelector:aSelector];
    
    NSMethodSignature * signature = [self methodSignatureForSelector:aSelector];
    if (aBool || signature) {
        return [self safe_instanceMethod_forwardingTargetForSelector:aSelector];
    } else {
        MYShieldStubObject *stub = [MYShieldStubObject shareInstance];
        [stub addFunc:aSelector];
        
        NSString *reason = [NSString stringWithFormat:@"*****Warning***** logic error.target is %@ method is %@, reason : method forword to Object default implement like send message to nil.",[self class], NSStringFromSelector(aSelector)];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeUnrecognizedSelector)];
        return stub;
    }
}

+ (id)safe_classMethod_forwardingTargetForSelector:(SEL)aSelector {
    
    BOOL aBool = [self respondsToSelector:aSelector];
    
    NSMethodSignature * signature = [self methodSignatureForSelector:aSelector];
    if (aBool || signature) {
        return [self safe_classMethod_forwardingTargetForSelector:aSelector];
    } else {
        MYShieldStubObject *stub = [MYShieldStubObject shareInstance];
        [stub addFunc:aSelector];
        
        NSString *reason = [NSString stringWithFormat:@"*****Warning***** logic error.target is %@ method is %@, reason : method forword to Object default implement like send message to nil.",[self class], NSStringFromSelector(aSelector)];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeUnrecognizedSelector)];
        return stub;
    }
}

@end
