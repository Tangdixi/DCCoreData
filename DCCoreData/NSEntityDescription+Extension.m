//
//  NSEntityDescription+Extension.m
//  DCCoreData
//
//  Created by Paul on 4/18/15.
//  Copyright (c) 2015 DC. All rights reserved.
//

#import "NSEntityDescription+Extension.h"

@implementation NSEntityDescription (Extension)

- (BOOL)hasAttribute:(NSString *)name {
    
    // Auto convert the name into lowwercase
    //
    name = [name lowercaseString];
    
    // Never allow an empty key as an attribute
    //
    NSAssert(name.length != 0, @"DCCoreData Error: You JSON dictionary has an empty key!\n");
    
    for (NSString *attributeName in self.attributesByName.allKeys) {
        
        if ([name isEqualToString:attributeName]) {
            return YES;
        }

    }
    
    NSLog(@"DCCoreData Warning: You JSON dictionary has an unknown attribute [%@]\n", name);
    
    return NO;
}

@end
