//
//  NNNRecordMO.h
//  Challenge
//
//  Created by Tymofii Dolenko on 27.06.2020.
//  Copyright © 2020 Tymofii Dolenko. All rights reserved.
//

#ifndef NNNRecordMO_h
#define NNNRecordMO_h

@interface NNNRecordMO : NSManagedObject

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) NSArray *modes;

@end

#endif /* NNNRecordMO_h */
