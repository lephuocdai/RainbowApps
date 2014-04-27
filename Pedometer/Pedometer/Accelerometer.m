//
//  Accelerometer.m
//  Pedometer
//
//  Created by 浅見 憲司 on 2013/10/26.
//  Copyright (c) 2013年 RainbowApps. All rights reserved.
//

#import "Accelerometer.h"

@implementation Accelerometer {
    AccelerometerFilter *filter;
    CMMotionManager *manager;
}

@synthesize delegate;

// Init.
-(id)initWithDelegate:(id)sender {
    if (self = [super init]) {
        self.delegate = sender;
    }
    return self;
}

// 開始
-(void)addAcceleration {
    //加速度計の分解能
    double updateFrequency = 60.0;
    
    //加速度計のフィルターを設定
    filter = [[LowpassFilter alloc] initWithSampleRate:updateFrequency cutoffFrequency:5.0];
    
    //加速度計のスタート
    manager = [[CMMotionManager alloc] init];
    [manager setAccelerometerUpdateInterval:1.0 / updateFrequency];
    
    // handler
    CMAccelerometerHandler handler = ^(CMAccelerometerData *data, NSError *error) {
        
        CMAcceleration accel = data.acceleration;
        //値にフィルターを適用
        [filter addAcceleration:&accel];
        
        //歩行を検知するメソッドへ値を渡す
        [delegate analyzeWalk:filter.x :filter.y :filter.z];
            
    };
    
    // start accelerometer
    [manager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
}

// 終了
-(void)stopAcceleration {
    [manager stopAccelerometerUpdates];
}

@end
