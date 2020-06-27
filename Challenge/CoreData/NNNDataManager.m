//
//  NNNDataController.m
//  Challenge
//
//  Created by Tymofii Dolenko on 27.06.2020.
//  Copyright © 2020 Tymofii Dolenko. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NNNDataManager.h"
#import "NNNRecordManager.h"
#import "NNNRecord.h"
#import "NNNRecordMO.h"

@interface NNNDataManager ()

@property (nonatomic,strong,readwrite) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) NSURL* modelURL;
@property (nonatomic,strong) NSURL* storeURL;

@end

@implementation NNNDataManager
 
- (id)initWithStoreURL:(NSURL*)storeURL modelURL:(NSURL*)modelURL
{
    self = [super init];
    if (self) {
        self.storeURL = storeURL;
        self.modelURL = modelURL;
        [self setupManagedObjectContext];
    }
    return self;
}

-(id)init {
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"Challenge" withExtension:@"momd"];
    NSURL* storeURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"challange.sqlite"]];
    return [self initWithStoreURL:storeURL modelURL:modelURL];
}

- (void)setupManagedObjectContext
{
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    NSError* error;
    [self.managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.storeURL options:nil error:&error];
    if (error) {
        NSLog(@"error: %@", error);
    }
    self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
}

- (NSManagedObjectModel*)managedObjectModel
{
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
}

-(void)removeRecords {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"NNNRecordMO"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];

    NSError *deleteError = nil;
    [_managedObjectContext.persistentStoreCoordinator executeRequest:delete withContext:_managedObjectContext error:&deleteError];
}

-(void)saveRecords:(NSArray*) records {
    if (records.count == 0) { return; }
    
    [self removeRecords];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for (NNNRecord* record in records) {
        NSManagedObject *transaction = [NSEntityDescription insertNewObjectForEntityForName:@"NNNRecordMO" inManagedObjectContext:context];

        [transaction setValue:[NSNumber numberWithDouble:record.latitude] forKey:@"latitude"];
        [transaction setValue:[NSNumber numberWithDouble:record.longitude] forKey:@"longitude"];
        [transaction setValue:record.modes forKey:@"modes"];
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Save Failed! %@ %@", error, [error localizedDescription]);
    }
}

-(NSArray*)loadRecords {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NNNRecordMO"];
     
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error fetching NNNRecordMO objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
    
    NSMutableArray* records = [[NSMutableArray alloc] init];
    
    for(NNNRecordMO* record in results) {
        [records addObject:[[NNNRecord alloc] initWithLatitude:record.latitude longitude:record.longitude modes:record.modes]];
    }
    
    return records;
}

-(void)loadToManager:(NNNRecordManager*) manager {
    manager.records = [[self loadRecords] mutableCopy];
}

-(void)saveFromManager:(NNNRecordManager*) manager {
    [self saveRecords:manager.records];
}

@end
