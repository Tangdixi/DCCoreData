//
//  DCCoreData.m
//  DCCoreData
//
//  Created by Paul on 4/3/15.
//  Copyright (c) 2015 DC. All rights reserved.
//

#import "DCCoreData.h"
#import "NSEntityDescription+Extension.h"

@interface DCCoreData ()

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation DCCoreData

static NSString * projectModelName = @"";

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Initialization

+ (instancetype)shareDCCoreData {
    
    // Initialization only once.
    //
    static DCCoreData *dcCoreData = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dcCoreData = [[self alloc]init];

    });
    
    return dcCoreData;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        // Add the some initialization code here
        //
        // ......
        
    }
    return self;
}

- (void)activeDCCoreDateWithModelName:(NSString *)modelName {
    
    // Set the project's model file name. Should never be nil
    //
    NSParameterAssert(modelName);
    
    projectModelName = modelName;
    
}

#pragma mark - Basic Operation 

- (id)createManagedObjectWithEntityName:(NSString *)entityName {
    
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    
}

#pragma mark - Insert Methods

- (void)insertManagedObject:(NSManagedObject *)managedObject {
    
    // Register a managedObject for next time save
    //
    [self.managedObjectContext insertObject:managedObject];
    
    // Commit the change and save it
    //
    [self commitAllChanges];
    
}

- (void)insertManagedObjects:(NSArray *)managedObjects {
    
    for (NSManagedObject *managedObject in managedObjects) {
        [self.managedObjectContext insertObject:managedObject];
    }
    
    [self commitAllChanges];
}

#pragma mark - Delete Methods

- (void)deleteManagedObject:(NSManagedObject *)managedObject {
    
    // Register a managedObject for next time save
    //
    [self.managedObjectContext deleteObject:managedObject];
    
    // Commit the change and save it
    //
    [self commitAllChanges];
    
}

- (void)deleteManagedObjects:(NSArray *)managedObjects {
    
    for (NSManagedObject *managedObject in managedObjects) {
        [self.managedObjectContext deleteObject:managedObject];
    }
    
    [self commitAllChanges];
}

#pragma mark - Fetch Mathods

- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName {
    
    return [self fetchManagedObjectsWithEntityName:entityName predicateFormat:nil];
    
}

- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName
                               predicateFormat:(NSString *)predicateFormat {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat];
    fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
}

- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName
                                 attributeName:(NSString *)attribute
                             hasAttributeValue:(NSString *)value {
    
    return [self fetchManagedObjectsWithEntityName:entityName attributeName:attribute hasAttributeValue:value sortByKey:nil ascending:NO];
    
}

- (NSArray *)fetchManagedObjectsWithEntityName:(NSString *)entityName
                                attributeName:(NSString *)attribute
                            hasAttributeValue:(NSString *)value
                                    sortByKey:(NSString *)sortKey
                                    ascending:(BOOL)ascending {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", attribute, value];
    fetchRequest.predicate = predicate;
    
    if (sortKey) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:sortKey ascending:ascending];
        fetchRequest.sortDescriptors = @[sortDescriptor];
    }
    
    NSError *error = nil;
    return [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
}

- (void)insertManagedObjectFromJSONDictionary:(NSDictionary *)JSONDictionary
                                   intoEntity:(NSString *)entityName {

    // These parameters shoule never be nil
    //
    NSParameterAssert(JSONDictionary);
    NSParameterAssert(entityName);
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:[entityName capitalizedString] inManagedObjectContext:self.managedObjectContext];

    if (entity) {
        
        NSManagedObject *managedObject = [self createManagedObjectWithEntityName:[entityName capitalizedString]];
        
        for (NSString *attribute in JSONDictionary.allKeys) {
            
            if ([entity hasAttribute:attribute]) {
                [managedObject setValue:JSONDictionary[attribute] forKey:attribute];
            }
            else {
                if (! self.ignoreUnknowAttribute) {
                    
                    NSLog(@"DCCoreData Error: Unknow attribute.\n You can set the 'ignoreUnknownAttribute' property to 'YES' or Check your JSON dictionay");
                    
                    // roll back the previous change
                    // To do: This part may need a undo managed
                    //
                    [self.managedObjectContext deleteObject:managedObject];
                    
                    return ;
                }
            }

        }
        
        [self commitAllChanges];
    }
    
}

#pragma mark - Commit Change

- (void)commitAllChanges {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Fetch Directory URL

- (NSURL *)applicationDocumentsDirectory {
    
    // The directory the application uses to store the Core Data store file.
    // This code uses a directory named "projectModelName" in the application's documents directory.
    //
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject;
    
}

#pragma mark - Core Data Stack

- (NSManagedObjectModel *)managedObjectModel {
    
    // The managed object model for the application.
    // It is a fatal error for the application not to be able to find and load its model.
    //
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:projectModelName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
    
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    // The persistent store coordinator for the application.
    // This implementation creates and return a coordinator, having added the store for the application to it.
    //
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    //
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSString *storeName = [NSString stringWithFormat:@"%@.sqlite", projectModelName];
    NSURL *storeURL = [self.applicationDocumentsDirectory URLByAppendingPathComponent:storeName];
    
    // Exception Handle
    //
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    
    // Returns the managed object context for the application
    // (which is already bound to the persistent store coordinator for the application.)
    //
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
    
}



@end
