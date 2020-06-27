//
//  NNNRecord.h
//  Challenge
//
//  Created by Tymofii Dolenko on 27.06.2020.
//  Copyright © 2020 Tymofii Dolenko. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef NNNRecord_h
#define NNNRecord_h

typedef NS_ENUM(NSUInteger, MotionMode) {
    Stationary,
    Walking,
    Running,
    Automotive,
    Cycling,
    Unknown
};

@interface NNNRecord : NSObject

@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (nonatomic) NSArray *modes;

-(NSString*)description;

-(instancetype) initWithLatitude:(double)latitude
                       longitude:(double)longitude
                           modes:(NSArray*)modes;

@end

#endif /* NNNRecord_h */
