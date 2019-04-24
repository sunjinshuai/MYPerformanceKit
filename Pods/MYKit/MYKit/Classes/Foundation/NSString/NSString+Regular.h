//
//  NSString+Regular.h
//  FXKitExampleDemo
//
//  Created by sunjinshuai on 2017/8/30.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regular)


/*!
 *  @method vertifyEmail
 *  验证字符串是否邮箱格式
 */
- (BOOL)vertifyEmail;

/*!
 *  @method vertifyChinese
 *  验证字符串是否中文
 */
- (BOOL)vertifyChinese;

/*!
 *  @method vertifyPassword
 *  验证字符串是否6-18位大小字母混合数字密码
 */
- (BOOL)vertifyPassword;

/*!
 *  @method vertifyHyperLink
 *  验证字符串是否超链接
 */
- (BOOL)vertifyHyperLink;

/*!
 *  @method vertifyTelephone
 *  验证字符串是否固机号码
 */
- (BOOL)vertifyTelephone;

/*!
 *  @method vertifyIpAddress
 *  验证字符串是否IP地址
 */
- (BOOL)vertifyIpAddress;

/*!
 *  @method vertifyMobilePhone
 *  验证字符串是否手机号码
 */
- (BOOL)vertifyMobilePhone;

/*!
 *  @method vertifyCarNumber
 *  验证字符串是否车牌号码
 */
- (BOOL)vertifyCarNumber;

/*!
 *  @method vertifyIdentifierNumber
 *  验证字符串是否身份证号码
 */
- (BOOL)vertifyIdentifierNumber;

/*!
 *  @method vertifyStringWithExp:
 *  验证字符串是否符合正则表达式规则
 */
- (BOOL)vertifyStringWithExp:(NSString *)exp;

@end
