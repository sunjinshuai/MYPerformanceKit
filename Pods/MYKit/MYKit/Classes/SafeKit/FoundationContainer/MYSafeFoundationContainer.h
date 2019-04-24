//
//  MYSafeFoundationContainer.h
//  MYKitDemo
//
//  Created by QMMac on 2018/6/26.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYSafeFoundationContainer : NSObject

/**
 防护 Foundation crash
 */
+ (void)safeGuardContainersSelector;

@end
