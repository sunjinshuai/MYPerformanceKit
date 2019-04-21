//
//  MYTeleponyManager.m
//  MYUtils
//
//  Created by sunjinshuai on 2018/3/20.
//  Copyright © 2018年 com.51fanxing. All rights reserved.
//

#import "MYTeleponyManager.h"
#import <UIKit/UIKit.h>
#import <CallKit/CXCall.h>
#import <CallKit/CXCallObserver.h>

#define CurrentSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

@interface MYTeleponyManager () <CXCallObserverDelegate>

@property (nonatomic, strong) CXCallObserver *cXCallObserver;
@property (nonatomic, assign) BOOL currentCallState;
@property (nonatomic, strong) dispatch_queue_t phoneCallQueue;

@end

@implementation MYTeleponyManager

+ (instancetype)sharedInstance {
    static MYTeleponyManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MYTeleponyManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        if (CurrentSystemVersion >= 10.0) {
            _cXCallObserver = [[CXCallObserver alloc] init];
            _phoneCallQueue = dispatch_queue_create("MYPhoneCallObserverQueue", DISPATCH_QUEUE_SERIAL);
            [_cXCallObserver setDelegate:self queue:_phoneCallQueue];
        }
    }
    return self;
}

- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
    if ([call hasConnected]) {
        self.currentCallState = YES;
    }
    if ([call isOnHold]) {
        self.currentCallState = YES;
    }
    if ([call isOutgoing]) {
        self.currentCallState = YES;
    }
    if ([call hasEnded]) {
        self.currentCallState = NO;
    }
}

- (BOOL)isConnected {
    if (CurrentSystemVersion >= 10.0) {
        return self.currentCallState;
    } else {
        return NO;
    }
}

@end
