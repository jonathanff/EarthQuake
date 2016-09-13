//
//  EQDetailViewController.m
//  EarthQuake
//
//  Created by Jonathan Fuentes Flores on 4/28/15.
//  Copyright (c) 2015 Jonathan. All rights reserved.
//

#import "EQDetailViewController.h"

//Model
#import "EQSessionManager.h"

//Libraries
#import <MapKit/MapKit.h>

@interface EQDetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel *magnitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *latitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *longitudeLabel;
@property (strong, nonatomic) IBOutlet UILabel *depthLabel;

@end

@implementation EQDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Detail";
    
    if (self.earthQuake) {
        self.magnitudeLabel.text = [self.earthQuake[kEQMagnitudeKey] stringValue];
        self.latitudeLabel.text = [NSString stringWithFormat:@"%@°N ", self.earthQuake[kEQLatitudeKey]];
        self.longitudeLabel.text = [NSString stringWithFormat:@"%@°W", self.earthQuake[kEQLongitudeKey]];
        self.depthLabel.text = [NSString stringWithFormat:@"%@ km", self.earthQuake[kEQDepthKey]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        self.dateLabel.text = [dateFormatter stringFromDate:self.earthQuake[kEQDateKey]];
        
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([self.earthQuake[kEQLatitudeKey] doubleValue], [self.earthQuake[kEQLongitudeKey] doubleValue]);
        MKCoordinateRegion mapRegion = MKCoordinateRegionMake(location, MKCoordinateSpanMake(5, 5));
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = location;
        annotation.title = self.earthQuake[kEQPlaceKey];
        annotation.subtitle = [self.earthQuake[kEQMagnitudeKey] stringValue];
        
        [self.mapView addAnnotation:annotation];
        [self.mapView selectAnnotation:annotation animated:YES];
        [self.mapView setRegion:mapRegion
                       animated:YES];

    }
}

@end
