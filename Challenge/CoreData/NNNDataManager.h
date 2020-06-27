//
//  NNNDataController.h
//  Challenge
//
//  Created by Tymofii Dolenko on 27.06.2020.
//  Copyright © 2020 Tymofii Dolenko. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "NNNRecordManager.h"

#ifndef NNNDataController_h
#define NNNDataController_h

@interface NNNDataManager : NSObject

- (id)initWithStoreURL:(NSURL*)storeURL modelURL:(NSURL*)modelURL;

@property (nonatomic,strong,readonly) NSManagedObjectContext* managedObjectContext;
 
-(void)removeRecords;
-(void)saveRecords:(NSArray*) records;
-(NSArray*)loadRecords;
-(void)loadToManager:(NNNRecordManager*) manager;
-(void)saveFromManager:(NNNRecordManager*) manager;

@end
#endif /* NNNDataController_h */
