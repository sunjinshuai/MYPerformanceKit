//
//  NSString+Safe.m
//  MYKitDemo
//
//  Created by QMMac on 2018/7/30.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import "NSString+Safe.h"
#import "NSObject+Swizzle.h"
#import "MYSafeKitRecord.h"

@implementation NSString (Safe)

+ (void)registerClassPairMethodsInString {
    Class NSCFConstantString = NSClassFromString(@"__NSCFConstantString");
    
    [self instanceSwizzleMethodWithClass:NSCFConstantString orginalMethod:@selector(characterAtIndex:) replaceMethod:@selector(safe_characterAtIndex:)];
    
    [self instanceSwizzleMethodWithClass:NSCFConstantString orginalMethod:@selector(substringFromIndex:) replaceMethod:@selector(safe_substringFromIndex:)];
    
    [self instanceSwizzleMethodWithClass:NSCFConstantString orginalMethod:@selector(substringToIndex:) replaceMethod:@selector(safe_substringToIndex:)];
    
    [self instanceSwizzleMethodWithClass:NSCFConstantString orginalMethod:@selector(substringWithRange:) replaceMethod:@selector(safe_substringWithRange:)];
    
    [self instanceSwizzleMethodWithClass:NSCFConstantString orginalMethod:@selector(stringByReplacingCharactersInRange:withString:) replaceMethod:@selector(safe_stringByReplacingCharactersInRange:withString:)];
}

- (unichar)safe_characterAtIndex:(NSUInteger)index {
    if (index >= self.length) {
        unichar characteristic = 0;
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : Range [0, %lu) or index out of bounds [0, %lu)",
                            [self class], NSStringFromSelector(_cmd), index, self.length];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        
        return characteristic;
    }
    return [self safe_characterAtIndex:index];
}

- (NSString *)safe_substringFromIndex:(NSUInteger)from {
    if (from >= self.length) {
        
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : Index %ld out of bounds; string length %ld",
                            [self class], NSStringFromSelector(_cmd), (unsigned long)from, (unsigned long)self.length];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return nil;
    }
    return [self safe_substringFromIndex:from];
}

- (NSString *)safe_substringToIndex:(NSUInteger)to {
    if (to >= self.length) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : Index %ld out of bounds; string length %ld",
                            [self class], NSStringFromSelector(_cmd), (unsigned long)to, (unsigned long)self.length];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return [self safe_substringToIndex:self.length - 1];
    }
    return [self safe_substringToIndex:to];
}

- (NSString *)safe_substringWithRange:(NSRange)range {
    if (range.location + range.length > self.length) {
        
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : Range {%ld, %ld} out of bounds; string length %ld",
                            [self class], NSStringFromSelector(_cmd), (unsigned long)range.location, (unsigned long)range.length, (unsigned long)self.length];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        if (range.location < self.length) {
            return [self safe_substringFromIndex:range.location];
        }
        return nil;
    }
    return [self safe_substringWithRange:range];
}

- (NSString *)safe_stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement {
    if (range.location + range.length > self.length) {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@, reason : Range [0, %lu) or index out of bounds [0, %lu)",
                            [self class], NSStringFromSelector(_cmd), range.length, self.length];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        if (range.location<self.length) {
            return [self safe_stringByReplacingCharactersInRange:NSMakeRange(range.location, self.length - range.location) withString:replacement];
        }
        return nil;
    }
    return [self safe_stringByReplacingCharactersInRange:range withString:replacement];
}

@end
