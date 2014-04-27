//
//  SecondViewController.m
//  Pedometer
//
//  Created by レー フックダイ on 4/27/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "SecondViewController.h"

#define START_LATITUDE 35.658609
#define START_LONGITUDE 139.745447

#define DELTA 0.005

@interface SecondViewController ()

@end

@implementation SecondViewController {
    CLLocationManager *locationManager;
    
    IBOutlet UILabel *longitudeLabel;
    IBOutlet UILabel *latitudeLabel;
    IBOutlet UILabel *accuracyLabel;
    IBOutlet MKMapView *map;
    
    MKCoordinateRegion region;  // Map Viewに表示するエリアを定義するMKCoordinateRegion
}

- (void)initMapView {
    map.showsUserLocation = YES;
    
    region.center.latitude = START_LATITUDE;
    region.center.longitude = START_LONGITUDE;
    
    region.span.latitudeDelta = region.span.longitudeDelta = DELTA;
    
    [map setRegion:region animated:YES];
}

- (void)initLocation {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initLocation];
    [self initMapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *newLocation = [locations lastObject];
    // Labelを更新
    longitudeLabel.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    latitudeLabel.text = [NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    int accuracy = newLocation.horizontalAccuracy;
    accuracyLabel.text = [NSString stringWithFormat:(accuracy < 15) ? @"高 (%d m)" : @"低 (%d m)", accuracy];
    region.center = newLocation.coordinate;
    [map setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error) {
        NSString *message = nil;
        if ([error code] == kCLErrorDenied) {
            [locationManager stopUpdatingLocation];
            message = [NSString stringWithFormat:@"このアプリは位置情報サービスが許可されていません。"];
        } else {
            message = [NSString stringWithFormat:@"位置情報の取得に失敗しました。"];
        }
        if (message != nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}


@end
