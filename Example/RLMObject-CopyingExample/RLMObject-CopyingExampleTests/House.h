//
//  House.h
//  RLMObject-CopyingExample
//
//  Created by Yu Sugawara on 7/8/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import <Realm/Realm.h>
#import "Room.h"

@interface House : RLMObject

@property Room *livingRoom;         // RLMPropertyTypeObject
@property RLMArray<Room> *rooms;    // RLMPropertyTypeArray

@property int intValue;             // RLMPropertyTypeInt
@property BOOL boolValue;           // RLMPropertyTypeBool
@property float floatValue;         // RLMPropertyTypeFloat
@property double doubleValue;       // RLMPropertyTypeDouble
@property NSString *string;         // RLMPropertyTypeString
@property NSData *data;             // RLMPropertyTypeData
@property id any;                   // RLMPropertyTypeAny
@property NSDate *date;             // RLMPropertyTypeDate

@end

// This protocol enables typed collections. i.e.:
// RLMArray<House>
RLM_ARRAY_TYPE(House)
