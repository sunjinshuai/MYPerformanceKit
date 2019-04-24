//
//  MYSafeKitRecord.m
//  MYKitDemo
//
//  Created by QMMac on 2018/7/31.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import "MYSafeKitRecord.h"

@implementation MYSafeKitRecord

static id<MYSafeKitRecordProtocol> __record;

+ (void)registerRecordHandler:(id<MYSafeKitRecordProtocol>)record {
    __record = record;
}

+ (void)recordFatalWithReason:(nullable NSString *)reason
                    errorType:(MYSafeKitShieldType)type {
    
    NSDictionary<NSString *, id> *errorInfo = @{ NSLocalizedDescriptionKey : (reason.length ? reason : @"未标识原因" )};
    
    NSError *error = [NSError errorWithDomain:[NSString stringWithFormat:@"com.xxshield.%@",
                                               [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]]
                                         code:-type
                                     userInfo:errorInfo];
    [__record recordWithReason:error];
}

+ (NSString *)getErrorMessageWithTipString:(NSString *)tipString {
    NSString *contentString = tipString;
    // 堆栈数据
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
    if (callStackSymbolsArr != nil) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:callStackSymbolsArr];
        NSString *ErrorString = [mutableArray componentsJoinedByString:@"\n"];//分隔符逗号
        contentString = [NSString stringWithFormat:@"%@\n%@", tipString, ErrorString];
    }
    
    return contentString;
}

+ (void)safeKit_showAlterWithMessage:(NSString *)messsage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                       message:messsage
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:@"确定", nil];
    [alertView show];
}


@end
