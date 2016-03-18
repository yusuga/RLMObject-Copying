//
//  RLMObject+Copying.m
//  RLMObject-CopyingExample
//
//  Created by Yu Sugawara on 7/8/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import "RLMObject+Copying.h"
#import <Realm/RLMObjectSchema.h>
#import <Realm/RLMProperty.h>
#import <Realm/RLMArray.h>

@implementation RLMObject (Copying)

- (instancetype)shallowCopy
{
    if (self.realm) {
        @throw @"Cannot copy the RLMObject related with Realm.";
    }
    
    RLMObject *object = [[NSClassFromString(self.objectSchema.className) alloc] init];
    
    for (RLMProperty *property in self.objectSchema.properties) {
        [object setValue:[self valueForKey:property.name] forKey:property.name];
    }
    
    return object;
}

- (instancetype)deepCopy
{
    RLMObject *object = [[NSClassFromString(self.objectSchema.className) alloc] init];
    
    for (RLMProperty *property in self.objectSchema.properties) {
        NSString *name = property.name;
        
        switch (property.type) {
            case RLMPropertyTypeArray:
            {
                RLMArray *array = [object valueForKey:name];
                
                for (RLMObject *value in [self valueForKey:name]) {
                    [array addObject:[value deepCopy]];
                }
                break;
            }
            case RLMPropertyTypeObject:
                [object setValue:[[self valueForKeyPath:property.name] deepCopy] forKeyPath:property.name];
                break;
            default:
            {
                id value = [self valueForKeyPath:property.name];
                if (value) {
                    if (![value conformsToProtocol:@protocol(NSCopying)]) {
                        @throw [NSString stringWithFormat:@"%@ does not conform to NSCopying", NSStringFromClass([value class])];
                    }
                    [object setValue:[value copy] forKeyPath:property.name];
                }
                break;
            }
        }
    }
    
    return object;
}

@end
