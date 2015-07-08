//
//  NSData+CopyingTests.m
//  RLMObject-CopyingExample
//
//  Created by Yu Sugawara on 7/8/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import "NSData+CopyingTests.h"

@implementation NSData (CopyingTests)

+ (NSData *)defualtData
{
    return [@"data" dataUsingEncoding:NSUTF8StringEncoding];
}

@end
