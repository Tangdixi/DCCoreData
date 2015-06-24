//
//  DCCoreData.h
//  DCCoreData
//
//  Created by Paul on 4/3/15.
//  Copyright (c) 2015 DC. All rights reserved.
//

@import CoreData;
@import Foundation;

@interface DCCoreData : NSObject

/**
 @brief Tell DCCoreData if allow to ignore the unknown attribute when you insert a new
 managed object through a JSON dictionart
 */
@property (assign, nonatomic) BOOL ignoreUnknowAttribute;

/**
 @brief Create a singleton
 @return A singleton of **DCCoreData**
 */
+ (instancetype)shareDCCoreData;

/**
 @brief Configure the Core Data with the model's name
 @param modelName The Core Data Model Name in your Project, aka which file with a **xcdatamodeld** suffix
 @discussion You should invoke this method when you App is launched
 */
- (void)activeDCCoreDateWithModelName:(NSString *)modelName;

/**
 @brief Create a managed object with the specific entity name
 @param entityName The name of entity
 @return A new managed object
 */
- (id)createManagedObjectWithEntityName:(NSString *)entityName;

/**
 @brief Insert a managed object and commit the change
 @param managedObject The managed object which will be save
 */
- (void)insertManagedObject:(NSManagedObject *)managedObject;

/**
 @brief Insert managed objects and commit the change
 @param managedObjects The array which contain the managedObject that will be inserted
 */
- (void)insertManagedObjects:(NSArray *)managedObjects;

/**
 @brief Delete a managed object and commit the change
 @param managedObject The managed object which will be delete
 */
- (void)deleteManagedObject:(NSManagedObject *)managedObject;

/**
 @brief Delete managed objects and commit the change
 @param managedObjects The array which contain the managedObject that will be deleted
 */
- (void)deleteManagedObjects:(NSArray *)managedObjects;

/**
 @brief Commit all the previos change
 */
- (void)commitAllChanges;


- (void)insertManagedObjectFromJSONDictionary:(NSDictionary *)JSONDictionary
                                   intoEntity:(NSString *)entityName;

/**
 @brief Fetch managed objects in special entity
 @param entityName The managed object's entity name, this parameter should not be nil
 @return An array which contain the fetched managed objects
 */
- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName;

/**
 @brief Fetch managed objects with special predicate format in special entity
 @param entityName The managed object's entity name, this parameter should not be nil
 @param format The predicate format
 @return An array which contain the fetched managed objects
 */
- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName
                               predicateFormat:(NSString *)format;

/**
 @brief Fetch managed objects with special attribute name and value in special entity
 @param entityName The managed object's entity name, this parameter should not be nil
 @param name The name of the attribute, this parameter should not be nil
 @param value The value of the attribute, this parameter should not be nil
 @return An array which contain the fetched managed objects
 */
- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName
                                 attributeName:(NSString *)attribute
                             hasAttributeValue:(NSString *)value;

/**
 @brief Fetch managed objects with predicate and sort by the giving condition in special entity
 @param entityName The managed object's entity name, this parameter should not be nil
 @param name The name of the attribute, this parameter should not be nil
 @param value The value of the attribute, this parameter should not be nil
 @param sortKey The keyword which will be use to sort the fetch result, this parameter should not be nil
 @param ascending The sort order, default is NO
 @return An array which contain the fetched managed objects
 */
- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName
                                attributeName:(NSString *)attribute
                            hasAttributeValue:(NSString *)value
                                    sortByKey:(NSString *)sortKey
                                    ascending:(BOOL)ascending;

@end

#define dcCoreDataSingleton [DCCoreData shareDCCoreData]
