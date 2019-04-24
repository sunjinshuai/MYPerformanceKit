//
//  MYSafeFoundationContainer.m
//  MYKitDemo
//
//  Created by QMMac on 2018/6/26.
//  Copyright © 2018 com.51fanxing. All rights reserved.
//

#import "MYSafeFoundationContainer.h"
#import "NSArray+Safe.h"
#import "NSMutableArray+Safe.h"
#import "NSDictionary+Safe.h"
#import "NSMutableDictionary+Safe.h"
#import "NSObject+Safe.h"
#import "NSMutableString+Safe.h"
#import "NSString+Safe.h"

@interface MYSafeFoundationContainer ()

@property (nonatomic, strong) NSArray *tempArray;

@end

@implementation MYSafeFoundationContainer

+ (void)safeGuardContainersSelector {
    
    [NSArray registerClassPairMethodsInArray];
    [NSMutableArray registerClassPairMethodsInMutableArray];
    
    [NSDictionary registerClassPairMethodsInDictionary];
    [NSMutableDictionary registerClassPairMethodsInMutableDictionary];
    
    [NSObject registerClassPairMethodsInObject];
    
    [NSString registerClassPairMethodsInString];
    [NSMutableString registerClassPairMethodsInMutableString];
}

@end
