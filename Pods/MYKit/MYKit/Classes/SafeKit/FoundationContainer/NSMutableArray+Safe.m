//
//  NSArray+Aspect.m
//  Footstone
//
//  Created by 李阳 on 8/3/2018.
//  Copyright © 2018 BetrayalPromise. All rights reserved.
//

#import "NSMutableArray+Safe.h"
#import "NSObject+Swizzle.h"
#import "MYSafeKitRecord.h"

@implementation NSMutableArray (Safe)

+ (void)registerClassPairMethodsInMutableArray {
    Class __NSArrayM = NSClassFromString(@"__NSArrayM");
    
    // objectAtIndex
    [self instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(objectAtIndex:) replaceMethod:@selector(safe_objectAtIndexWithArrayM:)];
    
    // removeObjectAtIndex
    [self instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(removeObjectAtIndex:) replaceMethod:@selector(safe_removeObjectAtIndex:)];
    
    // removeObjectsInRange
    [self instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(removeObjectsInRange:) replaceMethod:@selector(safe_removeObjectsInRange:)];
    
    // objectAtIndexedSubscript
    [self instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(objectAtIndexedSubscript:) replaceMethod:@selector(safe_objectAtIndexedSubscript:)];
    
    // insertObject:atIndex:
    [self instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(insertObject:atIndex:) replaceMethod:@selector(safe_insertObject:atIndex:)];
    
    // insertObjects:atIndexes:
    [self instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(insertObjects:atIndexes:) replaceMethod:@selector(safe_insertObjects:atIndexes:)];
    
    // removeObjectsAtIndexes
    [self instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(removeObjectsAtIndexes:) replaceMethod:@selector(safe_removeObjectsAtIndexes:)];
    
    // replaceObjectAtIndex:withObject:
    [self instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(replaceObjectAtIndex:withObject:) replaceMethod:@selector(safe_replaceObjectAtIndex:withObject:)];
    
    // replaceObjectsAtIndexes:withObjects:
    [self instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(replaceObjectsAtIndexes:withObjects:) replaceMethod:@selector(safe_replaceObjectsAtIndexes:withObjects:)];
    
    // exchangeObjectAtIndex:withObjectAtIndex:
    [self instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(exchangeObjectAtIndex:withObjectAtIndex:) replaceMethod:@selector(safe_exchangeObjectAtIndex:withObjectAtIndex:)];
    
    // setObject:atIndexedSubscript:
    [self instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(setObject:atIndexedSubscript:) replaceMethod:@selector(safe_atIndexedSubscript:atIndexedSubscript:)];
    
    // replaceObjectsInRange:withObjectsFromArray:
    [self instanceSwizzleMethodWithClass:__NSArrayM orginalMethod:@selector(replaceObjectsInRange:withObjectsFromArray:) replaceMethod:@selector(safe_replaceObjectsInRange:withObjectsFromArray:)];
}

- (id)safe_objectAtIndexWithArrayM:(NSUInteger)index{
    if (index < [(NSArray *)self count]) {
        return [self safe_objectAtIndexWithArrayM:index];
    } else {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of array ",
                            [self class], NSStringFromSelector(@selector(objectAtIndex:)), @(index), @(self.count)];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:MYSafeKitShieldTypeContainer];
        return nil;
    }
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index {
    
    if (index < [(NSArray *)self count]) {
        [self safe_removeObjectAtIndex:index];
    } else {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : -index:(%@) must at range [0, %@)",
                            [self class], NSStringFromSelector(@selector(removeObjectAtIndex:)), @(index), @(self.count)];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:MYSafeKitShieldTypeContainer];
    }
}

- (void)safe_removeObjectsInRange:(NSRange)range {
    if (range.location + range.length > [(NSArray *)self count]) {
        
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : -range:(%@) should be at range [0, %@)",
                            [self class], NSStringFromSelector(_cmd), NSStringFromRange(range), @(self.count)];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:MYSafeKitShieldTypeContainer];
        return;
    }
    [self safe_removeObjectsInRange:range];
}

- (id)safe_objectAtIndexedSubscript:(NSUInteger)idx {
    
    if (idx < [(NSArray *)self count]) {
        return [self safe_objectAtIndexedSubscript:idx];
    } else {
        NSString *reason = [NSString stringWithFormat:@"target is %@ method is %@,reason : index %@ out of count %@ of array ",
                            [self class], NSStringFromSelector(@selector(objectAtIndexedSubscript:)), @(idx), @(self.count)];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:MYSafeKitShieldTypeContainer];
        return nil;
    }
}

- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index {
    
    if (!anObject) {
        NSString *reason = [NSString stringWithFormat:@"\"%@\"-object:(%@) is nil", NSStringFromSelector(_cmd), anObject];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    if (index > [(NSArray *)self count]) {
        NSString *reason = [NSString stringWithFormat:@"\"%@\"-index:(%lu) must at range [0, %lu)", NSStringFromSelector(_cmd), index, (unsigned long)[(NSArray *)self count]];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    [self safe_insertObject:anObject atIndex:index];
}

- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (!anObject) {
        NSString *reason = [NSString stringWithFormat:@"%@\"%@\"-object:(%@) is nil", [self class], NSStringFromSelector(_cmd), anObject];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    if (index > [(NSArray *)self count]) {
        NSString *reason = [NSString stringWithFormat:@"%@\"%@\"-index:(%lu) must at range [0, %lu)", [self class], NSStringFromSelector(_cmd), index, (unsigned long)[(NSArray *)self count]];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    [self safe_replaceObjectAtIndex:index withObject:anObject];
}

- (void)safe_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    if (idx1 >= [(NSArray *)self count]) {
        NSString *reason = [NSString stringWithFormat:@"%@\"%@\"-idx1:(%lu) must at range [0, %lu)",[self class], NSStringFromSelector(_cmd), (unsigned long)idx1, (unsigned long)[(NSArray *)self count]];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    if (idx2 >= [(NSArray *)self count]) {
        NSString *reason = [NSString stringWithFormat:@"%@\"%@\"-idx2:(%lu) must at range [0, %lu)",[self class], NSStringFromSelector(_cmd), (unsigned long)idx2, (unsigned long)[(NSArray *)self count]];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    [self safe_exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)safe_removeObjectsAtIndexes:(NSIndexSet *)indexes {
    __block BOOL isPassed = YES;
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL*stop) {
        NSLog(@"%lu", (unsigned long)idx);
        if (isPassed) {
            if (idx < [(NSArray *)self count]) {
                isPassed = YES;
            } else {
                isPassed = NO;
            }
        }
    }];
    if (!isPassed) {
        NSString *reason = [NSString stringWithFormat:@"%@\"%@\"-parameter0:(%@) must at range [0, %lu)",[self class], NSStringFromSelector(_cmd), indexes, (unsigned long)[(NSArray *)self count]];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    [self safe_removeObjectsAtIndexes:indexes];
}

- (void)safe_insertObjects:(NSArray<id> *)objects atIndexes:(NSIndexSet *)indexes {
    __block BOOL isPassed = YES;
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL*stop) {
        NSLog(@"%lu", (unsigned long)idx);
        if (isPassed) {
            if (idx < [(NSArray *)self count]) {
                isPassed = YES;
            } else {
                isPassed = NO;
            }
        }
    }];
    if (!isPassed) {
        NSString *reason = [NSString stringWithFormat:@"%@\"%@\"-parameter0:(%@) must at range [0, %lu)",[self class], NSStringFromSelector(_cmd), indexes, (unsigned long)[(NSArray *)self count]];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    [self safe_insertObjects:objects atIndexes:indexes];
}

- (void)safe_replaceObjectsAtIndexes:(NSIndexSet *)indexes withObjects:(NSArray<id> *)objects {
    
    __block BOOL isPassed = YES;
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL*stop) {
        NSLog(@"%lu", (unsigned long)idx);
        if (isPassed) {
            if (idx < [(NSArray *)self count]) {
                isPassed = YES;
            } else {
                isPassed = NO;
            }
        }
    }];
    if (!isPassed) {
        NSString *reason = [NSString stringWithFormat:@"%@\"%@\"-parameter0:(%@) must at range [0, %lu)",[self class], NSStringFromSelector(_cmd), indexes, (unsigned long)[(NSArray *)self count]];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    [self safe_replaceObjectsAtIndexes:indexes withObjects:objects];
}

- (void)safe_atIndexedSubscript:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if (idx > [(NSMutableArray *)self count]) {
        NSString *reason = [NSString stringWithFormat:@"%@\"%@\"-index:(%@) must at range [0, %lu)", [self class], NSStringFromSelector(_cmd), @(idx), (unsigned long)[(NSArray *)self count]];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    if (!obj) {
        NSString *reason = [NSString stringWithFormat:@"%@\"%@\"-obj:%@ cannot be set nil", [self class], NSStringFromSelector(_cmd), obj];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    [self safe_atIndexedSubscript:obj atIndexedSubscript:idx];
}

- (void)safe_replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray<id> *)otherArray {
    
    if (range.location + range.length > [(NSArray *)self count]) {
        NSString *reason = [NSString stringWithFormat:@"%@\"%@\"-parameter0:(%@) must at range [0, %lu)",[self class], NSStringFromSelector(_cmd), NSStringFromRange(range), (unsigned long)[(NSArray *)self count]];
        [MYSafeKitRecord recordFatalWithReason:reason errorType:(MYSafeKitShieldTypeContainer)];
        return;
    }
    [self safe_replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

@end


