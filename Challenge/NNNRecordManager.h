//
//  NNNRecordManager.h
//  Challenge
//
//  Created by Tymofii Dolenko on 27.06.2020.
//  Copyright © 2020 Tymofii Dolenko. All rights reserved.
//

#ifndef NNNRecordManager_h
#define NNNRecordManager_h

#import <CoreLocation/CoreLocation.h>

@protocol NNNRecordManagerDelegate <NSObject>
-(void)recordManagerDidAddNewRecord;
@end

@interface NNNRecordManager : NSObject<CLLocationManagerDelegate>

@property (nonatomic, weak) id <NNNRecordManagerDelegate> delegate;
@property (nonatomic) NSMutableArray *records;

-(void)start;

@end

#endif /* NNNRecordManager_h */
