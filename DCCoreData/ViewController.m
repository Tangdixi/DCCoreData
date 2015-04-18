//
//  ViewController.m
//  DCCoreData
//
//  Created by Paul on 4/3/15.
//  Copyright (c) 2015 DC. All rights reserved.
//

#import "ViewController.h"
#import "DCCoreData.h"

#import "Teacher.h"
#import "Student.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tap:(id)sender {
    
    Student *paul = [dcCoreDataSingleton createManagedObjectWithEntityName:@"Student"];
    paul.name = @"DC";
    paul.identity = @"Paul1120";

    Student *fanny = [dcCoreDataSingleton createManagedObjectWithEntityName:@"Student"];
    fanny.name = @"Fanny";
    fanny.identity = @"Fanny0520";

    [dcCoreDataSingleton insertManagedObjects:@[paul, fanny]];
    
//    Student *student = [dcCoreDataSingleton fetchManagedObjectsWithEntityName:@"Student" attributeName:@"name" hasAttributeValue:@"DC"].lastObject;
//    NSLog(@"Found! name: %@", student.name);
//    
//    student.name = @"Paul";
//    
    [dcCoreDataSingleton commitAllChanges];
//
    
//    [dcCoreDataSingleton insertManagedObjectFromJSONDictionary:@{
//                                                                 @"asd": @"Jim",
//                                                                 @"identity":@"Jim123"
//                                                                 }
//                                                    intoEntity:@"student"];
    
    NSArray *results = [dcCoreDataSingleton fetchManagedObjectsWithEntityName:@"Student"];
    for (Student *student in results) {
        NSLog(@"name: %@", student);
    }
    
}

- (void)fetchAllData {
    
}

@end
