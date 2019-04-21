//
//  MYTeleponyManager.h
//  MYUtils
//
//  Created by sunjinshuai on 2018/3/20.
//  Copyright © 2018年 com.51fanxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYTeleponyManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)isConnected;

@end
