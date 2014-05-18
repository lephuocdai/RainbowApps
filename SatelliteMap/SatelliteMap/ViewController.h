//
//  ViewController.h
//  SatelliteMap
//
//  Created by レー フックダイ on 5/11/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MKMapView.h>
#import <MapKit/MKUserLocation.h>
#import <CoreMotion/CoreMotion.h>

// 加速度センサから値を取得するための間隔
#define kAccelerometerFrequency 20.0f
// 加速度センサから取得する値を制限する
#define kFilteringFactor 0.98f
//　　タイマーの間隔
#define kTimerInterval 0.1f
//　　地図の縮尺を判断するデフォルトの値
#define kDefaultDistance (111.0f * 1000.0f * 90.0f)

@interface ViewController : UIViewController <MKMapViewDelegate>

@end
