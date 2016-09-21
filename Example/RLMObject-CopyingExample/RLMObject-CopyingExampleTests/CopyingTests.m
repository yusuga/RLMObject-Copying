//
//  CopyingTests.m
//  RLMObject-CopyingExample
//
//  Created by Yu Sugawara on 7/8/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <Realm/RLMRealm.h>
#import "RLMObject+Copying.h"
#import "House.h"

@interface CopyingTests : XCTestCase

@property (nonatomic) RLMRealm *realm;

@end

@implementation CopyingTests

- (void)setUp
{
    [super setUp];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteAllObjects];
    }];
    self.realm = realm;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Shallow Copy

- (void)testShallowCopy
{
    [self.realm transactionWithBlock:^{
        [self.realm addObject:[[House alloc] initWithValue:[self houseValue]]];
    }];
    XCTAssertEqual([[House allObjects] count], 1);
    House *house = [[House allObjects] firstObject];
    
    XCTAssertThrows([house shallowCopy]);
}

- (void)testShallowCopyFromStandalone
{
    House *house = [[House alloc] initWithValue:[self houseValue]];
    XCTAssertNil(house.realm);
    
    House *copied;
    XCTAssertNoThrow(copied = [house shallowCopy]);
    XCTAssertNil(copied.realm);
    
    [self verifyRLMObject:house
              toRLMObject:copied
            isShallowCopy:YES];
}

#pragma mark - Deep Copy

- (void)testDeepCopy
{
    [self.realm transactionWithBlock:^{
        [self.realm addObject:[[House alloc] initWithValue:[self houseValue]]];
    }];
    XCTAssertEqual([[House allObjects] count], 1);
    House *house = [[House allObjects] firstObject];
    
    House *copied;
    XCTAssertNoThrow(copied = [house deepCopy]);
    
    [self verifyRLMObject:house
              toRLMObject:copied
            isShallowCopy:NO];
}

- (void)testDeepCopyFromStandalone
{
    House *house = [[House alloc] initWithValue:[self houseValue]];
    XCTAssertNil(house.realm);
    
    House *copied;
    XCTAssertNoThrow(copied = [house deepCopy]);
    XCTAssertNil(copied.realm);
    
    [self verifyRLMObject:house
              toRLMObject:copied
            isShallowCopy:NO];
}

#pragma mark - Verify

- (void)verifyRLMObject:(RLMObject *)obj1
            toRLMObject:(RLMObject *)obj2
          isShallowCopy:(BOOL)isShallowCopy
{
    NSLog(@"<%@>", isShallowCopy ? @"ShallowCopy" : @"DeepCopy");
    XCTAssertNotEqual(obj1, obj2);
    
    NSLog(@"%@ {", obj1.objectSchema.className);
    [self verifyRLMObject:obj1
              toRLMObject:obj2
            isShallowCopy:isShallowCopy
             realmRelated:obj1.realm != nil
                   indent:1];
    NSLog(@"}");
}

- (void)verifyRLMObject:(RLMObject *)obj1
            toRLMObject:(RLMObject *)obj2
          isShallowCopy:(BOOL)isShallowCopy
           realmRelated:(BOOL)realmRelated
                 indent:(NSUInteger)indent
{
    NSString *(^makeIndent)(NSUInteger indent) = ^NSString *(NSUInteger indent) {
        static NSString *kSpace = @"    ";
        NSMutableString *indentStr = @"".mutableCopy;
        for (NSUInteger i = 0; i < indent; i++) {
            [indentStr appendString:kSpace];
        }
        return [indentStr copy];
    };
    
    for (RLMProperty *property in obj1.objectSchema.properties) {
        NSString *name = property.name;
        
        id value1 = [obj1 valueForKey:name];
        id value2 = [obj2 valueForKey:name];
        
        void (^verify)(RLMPropertyType type, NSString *name, id value1, id value2, NSUInteger indent) = ^(RLMPropertyType type, NSString *name, id value1, id value2, NSUInteger indent) {
            NSString *indentStr = makeIndent(indent);
            switch (type) {
                case RLMPropertyTypeArray:
                    XCTFail(@"Impossible RLMArray of RLMArray.");
                    break;
                case RLMPropertyTypeObject:
                    NSLog(@"%@%@: (%p - %p) {", indentStr, name, value1, value2);
                    if (isShallowCopy) {
                        XCTAssertEqual(value1, value2);
                    } else {
                        XCTAssertNotEqual(value1, value2);
                    }
                    
                    [self verifyRLMObject:value1
                              toRLMObject:value2
                            isShallowCopy:isShallowCopy
                             realmRelated:realmRelated
                                   indent:indent + 1];
                    NSLog(@"%@}", indentStr);
                    break;
                case RLMPropertyTypeInt:
                    NSLog(@"%@%@", indentStr, property.name);
                    XCTAssertEqual([value1 intValue], INT_MAX);
                    XCTAssertEqual([value1 intValue], [value2 intValue]);
                    break;
                case RLMPropertyTypeBool:
                    NSLog(@"%@%@", indentStr, property.name);
                    XCTAssertEqual([value1 boolValue], YES);
                    XCTAssertEqual([value1 boolValue], [value2 boolValue]);
                    break;
                case RLMPropertyTypeFloat:
                    NSLog(@"%@%@", indentStr, property.name);
                    XCTAssertEqual([value1 floatValue], FLT_MAX);
                    XCTAssertEqual([value1 floatValue], [value2 floatValue]);
                    break;
                case RLMPropertyTypeDouble:
                    NSLog(@"%@%@", indentStr, property.name);
                    XCTAssertEqual([value1 doubleValue], DBL_MAX);
                    XCTAssertEqual([value1 doubleValue], [value2 doubleValue]);
                    break;
                default:
                    NSLog(@"%@%@: (%p - %p)", indentStr, property.name, value1, value2);
                    if (isShallowCopy || (type == RLMPropertyTypeDate && !realmRelated)) {
                        XCTAssertEqual(value1, value2);
                    } else {
                        XCTAssertEqualObjects(value1, value2);
                    }
                    break;
            }
        };
        
        if (property.type == RLMPropertyTypeArray) {
            NSString *indentStr = makeIndent(indent);
            
            NSLog(@"%@%@: (%p - %p) {", indentStr, name, value1, value2);
            
            
            if (isShallowCopy) {
                /**
                 *  Cannot shallow copy the RLMArrray.
                 */
                // XCTAssertEqual(value1, value2);
            } else {
                XCTAssertNotEqual(value1, value2);
            }
            XCTAssertEqual([value1 count], [value2 count]);
            for (NSUInteger i = 0; i < [value1 count]; i++) {
                id childValue1 = [value1 objectAtIndex:i];
                id childValue2 = [value2 objectAtIndex:i];
                
                verify(RLMPropertyTypeObject,
                       ((RLMObject *)childValue1).objectSchema.className,
                       childValue1,
                       childValue2,
                       indent + 1);
            }
            NSLog(@"%@}", indentStr);
        } else {
            verify(property.type,
                   name,
                   value1,
                   value2,
                   indent);
        }
    }
}

#pragma mark - Utility

- (NSDictionary *)houseValue
{
    return @{@"address" : @(100),
             @"livingRoom" : @{@"table" : @{},
                               @"chairs" : [self chairValue]},
             @"rooms" : [self roomsValue]};
}

- (NSArray *)roomsValue
{
    return @[@{@"table" : @{}, @"chairs" : [self chairValue]},
             @{@"table" : @{}, @"chairs" : [self chairValue]}];
}

- (NSArray *)chairValue
{
    return @[@{}, @{}, @{}];
}

- (NSArray *)chairValuesWithCount:(NSUInteger)count
{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:count];
    for (NSUInteger i = 0; i < count; i++) {
        [arr addObject:@{}];
    }
    return [arr copy];
}

@end
