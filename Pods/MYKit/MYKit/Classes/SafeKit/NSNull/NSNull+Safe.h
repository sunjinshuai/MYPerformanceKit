//
//  NSNull+Safe.h
//  MYKit
//
//  Created by sunjinshuai on 2019/4/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNull (Safe)

/**
 NSNull
 */
+ (void)safeGuardNSNull;

@end

NS_ASSUME_NONNULL_END
