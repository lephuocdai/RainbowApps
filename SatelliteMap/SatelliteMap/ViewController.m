//
//  ViewController.m
//  SatelliteMap
//
//  Created by レー フックダイ on 5/11/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController {
    
    IBOutlet UILabel *aLabel;
    IBOutlet MKMapView *aMap;
    IBOutlet UIImageView *pin;
    IBOutlet UIImageView *gradation;
    
    
    
    UIAccelerationValue accelX, accelY, accelZ;     // 加速度センサから取得した値を格納する変数
    CMMotionManager *motionManager;                 // CoreMotionを利用するためのオブジェクト
    CLLocationCoordinate2D currentCenter;           // 現在地取得用
    NSTimer *aTimer;                                // 地図を移動させるためタイマー
    CLLocationDistance distance;                    // 縮尺を判断するための長さ
    NSInteger numEndingAnimation;                   // Ending Animation番号
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [self startAccelerometer];
    
    // 基準となる距離の初期値を設定
    distance = kDefaultDistance;
    [self startTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapView delegate
- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    CLLocationCoordinate2D newCenter = [[[aMap userLocation] location] coordinate];
    if (newCenter.latitude != currentCenter.latitude || newCenter.longitude != currentCenter.longitude )
        currentCenter = newCenter;
    return nil;
}

- (void)didAccelerate:(CMAcceleration)acceleratio {
    //制限を加えて加速度の値を取得する（x,y,z軸それぞれ）
    accelX = (accelX * kFilteringFactor) + (acceleratio.x * (1.0f - kFilteringFactor));
    accelY = (accelY * kFilteringFactor) + (acceleratio.y * (1.0f - kFilteringFactor));
    accelZ = (accelZ * kFilteringFactor) + (acceleratio.z * (1.0f - kFilteringFactor));
}

- (void)stopAccelerometer {
    [motionManager stopAccelerometerUpdates];
}

- (void)startAccelerometer {
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = (1.0f / kAccelerometerFrequency);
    CMAccelerometerHandler accelHandler = ^(CMAccelerometerData *data, NSError *error) {
        [self didAccelerate:data.acceleration];
    };
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:accelHandler];
}


# pragma mark - Timer control
- (void)stopTimer {
    if (aTimer) {
        [aTimer invalidate];
        aTimer = nil;
    }
}

- (void)startTimer {
    if (aTimer) [self stopTimer];
    aTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(tick:) userInfo:nil repeats:YES];
}

- (void)tick:(NSTimer*)theTimer {
    if (currentCenter.latitude) {   // もし、中心地の緯度が存在するとき
        MKCoordinateRegion regionOK = [aMap region];    // 地図から縮尺度を取得する
        CLLocationCoordinate2D center = regionOK.center;    // 現在地の中心を取得する
        // 加速度を加味して移動する距離を求める
        CGFloat dx = accelX * (distance/5.0f)/111.0f/1000.0f;
        CGFloat dy = accelY * (distance/5.0f)/111.0f/1000.0f;
        // 中心地に計算した移動距離分を加算する
        center.longitude += dx;
        center.latitude += dy;
        
        // もし距離が300m以下になったら、
        if (distance <= 300.0f) {
            [self stopTimer];
            [self stopAccelerometer];
            distance = 300.0f;
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, distance, distance);
            [aMap setRegion:region animated:NO];
            numEndingAnimation = 0;
            [self endingAnimation];
        } else {
            distance -= (distance/50.0f);
            MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, distance, distance);
            [aMap  setRegion:region animated:YES];
        }
        
        // 加速度を加味した中心地に縮尺も併せて設定する
//        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, distance, distance);
        // Animationをつけながら位置を変更して移動する
//        [aMap setRegion:region animated:YES];
        
        
        // 地図の左上の位置を設定する
        CLLocationCoordinate2D mapLeftTop = [aMap convertPoint:CGPointMake(0.0f, 0.0f) toCoordinateFromView:aMap];
        // 地図の右下の位置を設定する
        float screenSizeHeight = [[UIScreen mainScreen] bounds].size.height;
        CLLocationCoordinate2D mapRightButton = [aMap convertPoint:CGPointMake(3320.0f, screenSizeHeight) toCoordinateFromView:aMap];
        // もし、地図の右下の経度の値が180より大きくなった場合
        if (mapRightButton.longitude > 180.0f || mapLeftTop.longitude < -180.0f) {
            [aMap setRegion:regionOK animated:YES];
        }
    }
}

#pragma mark - Animation
- (void)endingAnimation {
    if (numEndingAnimation == 0) {
        numEndingAnimation++;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.2f];
        [gradation setAlpha:1.0f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(endingAnimation)];
        [UIView commitAnimations];
    } else if (numEndingAnimation == 1) {
        numEndingAnimation++;
        CGAffineTransform t2 = CGAffineTransformMakeScale(1.0f, 0.4f);
        CGRect r = [aMap frame];
        float screenSizeHeight = [[UIScreen mainScreen] bounds].size.height;
        r.origin.y = screenSizeHeight * 0.3f;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.0f];
        [aMap setFrame:r];
        [gradation setFrame:r];
        [pin setTransform:t2];
        [aMap setTransform:t2];
        [gradation setTransform:t2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(endingAnimation)];
        [UIView commitAnimations];
    } else if (numEndingAnimation == 2) {
        numEndingAnimation++;
        MKCoordinateRegion region = aMap.region;
        CLLocationCoordinate2D center = region.center;
        CGPoint pos = [aMap convertCoordinate:center toPointToView:self.view];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.0f];
        [pin setCenter:pos];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(endingAnimation)];
        [UIView commitAnimations];
    } else if (numEndingAnimation == 3) {
        numEndingAnimation++;
        MKCoordinateRegion region = aMap.region;
        CLLocationCoordinate2D center = region.center;
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentCenter.latitude longitude:currentCenter.longitude];
        CLLocation *workLocation = [[CLLocation alloc] initWithLatitude:center.latitude longitude:center.longitude];
        CLLocationDistance resultDistance = [currentLocation distanceFromLocation:workLocation];
        [aLabel setText:[NSString stringWithFormat:@"距離 %.2f メートル", resultDistance]];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.0f];
        [aLabel setAlpha:1.0f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(endingAnimation)];
        [UIView commitAnimations];
    }
}






@end
