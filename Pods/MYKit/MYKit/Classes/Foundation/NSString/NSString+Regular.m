//
//  NSString+Regular.m
//  FXKitExampleDemo
//
//  Created by sunjinshuai on 2017/8/30.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import "NSString+Regular.h"

@implementation NSString (Regular)

- (BOOL)vertifyEmail {
    return [self vertifyStringWithExp: @"^(\\S+@\\S+\\.[a-zA-Z]{2,4})$"];
}

- (BOOL)vertifyChinese {
    return [self vertifyStringWithExp: @"^([\u4e00-\u9fa5]+)$"];
}

- (BOOL)vertifyPassword {
    NSString * lengthMatch = @"^(.{6,18})$";
    NSString * numberMatch = @"^(.*\\d+.*)$";
    NSString * lowerMatch = @"^(.*[a-z]+.*)$";
    NSString * upperMatch = @"^(.*[A-Z]+.*)$";
    return [self vertifyStringWithExp: lengthMatch] &&
    [self vertifyStringWithExp: numberMatch] &&
    [self vertifyStringWithExp: lowerMatch] &&
    [self vertifyStringWithExp: upperMatch];
}

- (BOOL)vertifyCarNumber {
    return [self vertifyStringWithExp: @"^([\u4e00-\u9fa5]{1}[a-zA-Z]{1}\\w{4}[a-zA-Z0-9[\u4e00-\u9fa5]]{1})$"];
}

- (BOOL)vertifyHyperLink {
    return [self vertifyStringWithExp: @"^((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)$"];
}

- (BOOL)vertifyIpAddress {
    return [self vertifyStringWithExp: @"^(([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3})|(0\\.0\\.0\\.0)$"];
}

- (BOOL)vertifyTelephone {
    return [self vertifyStringWithExp: @"^(0\\d{2}-?\\d{8})|(\\d{8})|(0\\d{3}-?\\d{8})|(400-\\d{3}-\\d{4})$"];
}

- (BOOL)vertifyMobilePhone {
    return [self vertifyStringWithExp: @"^1\\d{10}$"];
}

- (BOOL)vertifyIdentifierNumber {
    /// http://blog.csdn.net/wei549434510/article/details/50596207
    return [self vertifyStringWithExp: @"(^[1-9]\\d{5}(18|19|([23]\\d))\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{3}[0-9Xx]$)|(^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{2}[0-9Xx]$)"];
}

- (BOOL)vertifyStringWithExp:(NSString *)exp {
    if (![exp isKindOfClass: [NSString class]]) {
        return NO;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", exp];
    return [predicate evaluateWithObject:self];
}

@end
