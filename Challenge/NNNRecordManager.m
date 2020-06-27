//
//  NNNRecordManager.m
//  Challenge
//
//  Created by Tymofii Dolenko on 27.06.2020.
//  Copyright © 2020 Tymofii Dolenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "NNNRecordManager.h"
#import "NNNDataManager.h"
#import "NNNRecord.h"

@interface NNNRecordManager()

@property (nonatomic) NNNDataManager *dataManager;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSArray *lastModes;

@end

@implementation NNNRecordManager {
@private
    CMMotionActivityManager *_motionActivityManager;
}

-(instancetype)init {
    self = [super init];
    
    if (self) {
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.allowsBackgroundLocationUpdates = true;
        
        if ([CMMotionActivityManager isActivityAvailable]) {
            _motionActivityManager = [[CMMotionActivityManager alloc] init];
        }
        
        _lastModes = [[NSArray alloc] initWithObjects:
                      [NSNumber numberWithInt:Unknown], nil];
        _records = [[NSMutableArray alloc] init];
        
        _dataManager = [[NNNDataManager alloc] init];
        [_dataManager loadToManager:self];
    }
    
    return self;
}

-(void)start {
    [self startMotionActivityMonitorning];
    [self startLocationMonitoring];
}

-(void)stop {
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
    }
}

-(void)startLocationMonitoring {
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    for (CLLocation* location in locations) {
        NNNRecord* record = [[NNNRecord alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude modes:_lastModes];
        [_records addObject:record];
        [_delegate recordManagerDidAddNewRecord];
        [_dataManager saveFromManager:self];
    }
}

-(void)startMotionActivityMonitorning {
    __weak NNNRecordManager *weakSelf = self;
    CMMotionActivityHandler motionActivityHandler = ^(CMMotionActivity *activity) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        if (activity.walking) {
            [array addObject: [NSNumber numberWithInt:Walking]];
        }
        
        if (activity.automotive) {
            [array addObject: [NSNumber numberWithInt:Automotive]];
        }
        
        if (activity.cycling) {
            [array addObject: [NSNumber numberWithInt:Cycling]];
        }
        
        if (activity.stationary) {
            [array addObject: [NSNumber numberWithInt:Stationary]];
        }
        
        if ([array count] == 0) {
            [array addObject: [NSNumber numberWithInt:Unknown]];
        }
        
        weakSelf.lastModes = array;
    };
    
    if (_motionActivityManager) {
        [_motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:motionActivityHandler];
    }
}

@end
