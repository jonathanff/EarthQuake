//
//  EQSessionManager.m
//  EarthQuake
//
//  Created by Jonathan Fuentes Flores on 4/28/15.
//  Copyright (c) 2015 Jonathan. All rights reserved.
//

#import "EQSessionManager.h"

NSString *const kEPropertiesKey = @"properties";
NSString *const kEQMagnitudeKey = @"mag";
NSString *const kEQPlaceKey = @"place";
NSString *const kEQDateKey = @"time";
NSString *const kEQMagnitudemagTypeKey = @"magType";
NSString *const kEQGeometryKey = @"geometry";
NSString *const kEQCoordinatesKey = @"coordinates";
NSString *const kEQDetailURLKey = @"detail";
NSString *const kEQIdKey = @"id";
NSString *const kEQLatitudeKey = @"latitude";
NSString *const kEQLongitudeKey = @"longitude";
NSString *const kEQDepthKey = @"depth";

@implementation EQSessionManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static EQSessionManager *sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[EQSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://earthquake.usgs.gov/"]];
    });
    
    return sharedManager;
}

- (void)getFeedWithCompletionBlock:(void(^)(NSArray *earthQuakes, NSError *error))completionBlock {
    [self GET:@"earthquakes/feed/v1.0/summary/all_hour.geojson"
   parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       
       NSArray *features = responseObject[@"features"];
       
       NSMutableArray *earthQuakesMutableArray = [[NSMutableArray alloc] init];
       for (NSDictionary *earthQuakeDictionary in features) {
           NSMutableDictionary *earthQuake = [[NSMutableDictionary alloc] init];
           [earthQuake setObject:earthQuakeDictionary[kEQIdKey] forKey:kEQIdKey];
           
           NSDictionary *earthQuakeProperties = earthQuakeDictionary[kEPropertiesKey];
           [earthQuake setObject:earthQuakeProperties[kEQMagnitudeKey] forKey:kEQMagnitudeKey];
           [earthQuake setObject:earthQuakeProperties[kEQMagnitudemagTypeKey] forKey:kEQMagnitudemagTypeKey];
           [earthQuake setObject:earthQuakeProperties[kEQPlaceKey] forKey:kEQPlaceKey];
           [earthQuake setObject:earthQuakeProperties[kEQDetailURLKey] forKey:kEQDetailURLKey];

           NSArray *earthQuakeCoordinates = earthQuakeDictionary[kEQGeometryKey][kEQCoordinatesKey];
           [earthQuake setObject:[earthQuakeCoordinates[1] stringValue] forKey:kEQLatitudeKey];
           [earthQuake setObject:[earthQuakeCoordinates[0] stringValue] forKey:kEQLongitudeKey];
           [earthQuake setObject:[earthQuakeCoordinates[2] stringValue] forKey:kEQDepthKey];
           
           NSString *timeInterval = earthQuakeProperties[kEQDateKey];
           NSDate *earthQuakeDate = [[NSDate alloc] initWithTimeIntervalSince1970:[timeInterval doubleValue]];
           [earthQuake setObject:earthQuakeDate forKey:kEQDateKey];
           
           [earthQuakesMutableArray addObject:earthQuake];
       }
       
       if (completionBlock) {
           completionBlock([earthQuakesMutableArray copy], nil);
       }
       
   } failure:^(NSURLSessionDataTask *task, NSError *error) {
       if (completionBlock) {
           completionBlock(nil, error);
       }
   }];
}

@end
