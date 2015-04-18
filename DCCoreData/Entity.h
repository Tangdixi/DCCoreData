//
//  Entity.h
//  DCCoreData
//
//  Created by Paul on 4/16/15.
//  Copyright (c) 2015 DC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student;

@interface Entity : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSSet *students;
@end

@interface Entity (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
