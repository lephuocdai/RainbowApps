//
//  Accelerometer.h
//  Pedometer
//
//  Created by 浅見 憲司 on 2013/10/26.
//  Copyright (c) 2013年 RainbowApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccelerometerFilter.h"
#import <CoreMotion/CoreMotion.h>

//Delegateを宣言する
@protocol AccelerometerDelegate;

@interface Accelerometer : NSObject

-(id)initWithDelegate:(id)sender;
-(void)addAcceleration;
-(void)stopAcceleration;

@property(nonatomic, assign) id<AccelerometerDelegate> delegate;

@end

//独自のプロトコルを作成
@protocol AccelerometerDelegate <NSObject>

-(void)analyzeWalk:(UIAccelerationValue)x :(UIAccelerationValue)y :(UIAccelerationValue)z;

@end