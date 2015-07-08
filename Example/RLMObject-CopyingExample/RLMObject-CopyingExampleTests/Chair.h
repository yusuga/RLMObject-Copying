//
//  Chair.h
//  RLMObject-CopyingExample
//
//  Created by Yu Sugawara on 7/8/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import <Realm/Realm.h>

@interface Chair : RLMObject

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Chair>
RLM_ARRAY_TYPE(Chair)
