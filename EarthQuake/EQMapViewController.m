//
//  EQMapViewController.m
//  EarthQuake
//
//  Created by Jonathan Fuentes Flores on 4/29/15.
//  Copyright (c) 2015 Jonathan. All rights reserved.
//

#import "EQMapViewController.h"

//Frameworks
#import <MapKit/MapKit.h>

//Libraries
#import "EQSessionManager.h"

@interface EQMapViewController ()

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation EQMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[EQSessionManager sharedManager] getFeedWithCompletionBlock:^(NSArray *earthQuakes, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Please try again"
                                                               delegate:self cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        NSMutableArray *annotations = [[NSMutableArray alloc] init];
        for (NSDictionary *earthQuakeDictionary in earthQuakes) {
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([earthQuakeDictionary[kEQLatitudeKey] doubleValue], [earthQuakeDictionary[kEQLongitudeKey] doubleValue]);
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.coordinate = location;
            annotation.title = earthQuakeDictionary[kEQPlaceKey];
            annotation.subtitle = [earthQuakeDictionary[kEQMagnitudeKey] stringValue];
            
            [annotations addObject:annotation];
        }
        
        [self.mapView showAnnotations:annotations animated:YES];
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MKPointAnnotation *)annotation {
    static NSString *reuseId = @"annotation";
    MKPinAnnotationView *pinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!pinAnnotationView) {
        pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        pinAnnotationView.animatesDrop = YES;
        pinAnnotationView.canShowCallout = YES;
        pinAnnotationView.calloutOffset = CGPointMake(-5, 5);
    } else {
        pinAnnotationView.annotation = annotation;
    }
    
    double magnitude = [annotation.subtitle doubleValue];
    if (magnitude >= 0 && magnitude <= 0.9) {
        pinAnnotationView.pinColor = MKPinAnnotationColorGreen;
    } else if (magnitude >= 9.0 && magnitude <= 9.9) {
        pinAnnotationView.pinColor = MKPinAnnotationColorRed;
    } else {
        pinAnnotationView.pinColor = MKPinAnnotationColorPurple;
    }
    
    return pinAnnotationView;
}

@end