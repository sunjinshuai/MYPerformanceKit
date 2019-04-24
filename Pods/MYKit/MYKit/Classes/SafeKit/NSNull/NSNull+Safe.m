//
//  NSNull+Safe.m
//  MYKit
//
//  Created by sunjinshuai on 2019/4/17.
//

#import "NSNull+Safe.h"
#import "NSObject+Swizzle.h"
#import "MYSafeKitRecord.h"
#import <objc/runtime.h>

@implementation NSNull (Safe)

+ (void)safeGuardNSNull {
    [self instanceSwizzleMethod:@selector(forwardingTargetForSelector:)
                  replaceMethod:@selector(safe_instanceMethod_forwardingTargetForSelector:)];
}

- (id)safe_instanceMethod_forwardingTargetForSelector:(SEL)aSelector {
    static NSArray *sTmpOutput = nil;
    if (sTmpOutput == nil) {
        sTmpOutput = @[@"", @0, @[], @{}];
    }
    
    for (id tmpObj in sTmpOutput) {
        if ([tmpObj respondsToSelector:aSelector]) {
            NSString *reason = [NSString stringWithFormat:@"*****Warning***** logic error.target is %@ method is %@, reason : method forword to Object default implement like send message to nil.",[self class], NSStringFromSelector(aSelector)];
            [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeNull)];
            return tmpObj;
        }
    }
    return [self safe_instanceMethod_forwardingTargetForSelector:aSelector];
}

@end
