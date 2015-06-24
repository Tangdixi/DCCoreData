//
//  Student.h
//  DCCoreData
//
//  Created by Paul on 4/18/15.
//  Copyright (c) 2015 DC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Teacher;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * identity;
@property (nonatomic, retain) NSDate * registerDate;
@property (nonatomic, retain) Teacher *teacher;

@end
