//
//  Room.m
//  RLMObject-CopyingExample
//
//  Created by Yu Sugawara on 7/8/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import "Room.h"
#import "NSString+CopyingTests.h"
#import "NSData+CopyingTests.h"
#import "NSDate+CopyingTests.h"

@implementation Room

+ (NSDictionary *)defaultPropertyValues
{
    return @{NSStringFromSelector(@selector(intValue)) : @(INT_MAX),
             NSStringFromSelector(@selector(boolValue)) : @YES,
             NSStringFromSelector(@selector(floatValue)) : @(FLT_MAX),
             NSStringFromSelector(@selector(doubleValue)) : @(DBL_MAX),
             NSStringFromSelector(@selector(string)) : [NSString defualtString],
             NSStringFromSelector(@selector(data)) : [NSData defualtData],
             NSStringFromSelector(@selector(any)) : [NSData defualtData],
             NSStringFromSelector(@selector(date)) : [NSDate defualtDate]};
}

@end
