//
//  NNNRecord.m
//  Challenge
//
//  Created by Tymofii Dolenko on 27.06.2020.
//  Copyright © 2020 Tymofii Dolenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNNRecord.h"

@implementation NNNRecord

-(instancetype) initWithLatitude:(double)latitude
                       longitude:(double)longitude
                           modes:(NSArray*)modes {
    self = [super init];
    
    if(self) {
        _latitude = latitude;
        _longitude = longitude;
        _modes = modes;
    }
    
    return self;
}

-(NSString*)descriptionForMode: (MotionMode) mode {
    switch (mode) {
        case Stationary:
            return @"Stationary";
        case Walking:
            return @"Walking";
        case Running:
            return @"Running";
        case Automotive:
            return @"Automotive";
        case Cycling:
            return @"Cycling";
        case Unknown:
            return @"Unknown";
    }
}

-(NSString*)modeDescription {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for(NSNumber* number in _modes) {
        [array addObject:[self descriptionForMode:(MotionMode)number.intValue]];
    }
    
    return [array componentsJoinedByString:@","];
}

-(NSString*)description {
    return [NSString stringWithFormat:@"%@ %.02f%@ %.02f %@ %@", @"Lat:", _latitude, @", Lon:", _longitude, @"Mode:", [self modeDescription]];
}

@end
