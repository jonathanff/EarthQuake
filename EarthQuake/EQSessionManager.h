//
//  EQSessionManager.h
//  EarthQuake
//
//  Created by Jonathan Fuentes Flores on 4/28/15.
//  Copyright (c) 2015 Jonathan. All rights reserved.
//

#import "AFHTTPSessionManager.h"

extern NSString *const kEPropertiesKey;
extern NSString *const kEQMagnitudeKey;
extern NSString *const kEQPlaceKey;
extern NSString *const kEQDateKey;
extern NSString *const kEQMagnitudemagTypeKey;
extern NSString *const kEQGeometryKey;
extern NSString *const kEQCoordinatesKey;
extern NSString *const kEQDetailURLKey;
extern NSString *const kEQIdKey;
extern NSString *const kEQLatitudeKey;
extern NSString *const kEQLongitudeKey;
extern NSString *const kEQDepthKey;

@interface EQSessionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (void)getFeedWithCompletionBlock:(void(^)(NSArray *earthQuakes, NSError *error))completionBlock;

@end
