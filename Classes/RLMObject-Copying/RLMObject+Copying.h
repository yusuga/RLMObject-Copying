//
//  RLMObject+Copying.h
//  RLMObject-CopyingExample
//
//  Created by Yu Sugawara on 7/8/15.
//  Copyright (c) 2015 Yu Sugawara. All rights reserved.
//

#import <Realm/RLMObject.h>

@interface RLMObject (Copying)

- (instancetype)shallowCopy;
- (instancetype)deepCopy;

@end
