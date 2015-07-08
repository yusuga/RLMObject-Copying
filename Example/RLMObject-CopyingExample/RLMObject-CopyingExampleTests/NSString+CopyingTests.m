//
//  NSString+CopyingTests.m
//  RLMObject-CopyingExample
//
//  Created by Yu Sugawara on 7/8/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import "NSString+CopyingTests.h"

@implementation NSString (CopyingTests)

+ (NSString *)defualtString
{
    return @"defualt string".mutableCopy;
}

@end
