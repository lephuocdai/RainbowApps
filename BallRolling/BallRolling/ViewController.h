//
//  ViewController.h
//  BallRolling
//
//  Created by レー フックダイ on 5/5/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

#define kAccelerometerFrequency 20.0f   // 加速センサから値を取得する間隔
#define kFilterFactor 0.2f              // 加速度センサの感度を制限する
#define kTimerInterval 0.01f
#define kRadius 26.0f                   // radius of the ball
#define kWallRefPower 0.8f              // 壁反射の度合い
#define kRefPower 2.2f                  // Pin反射の度合い
#define kDefaultScore 200
#define kGoalThreshold 12               // If ball and goal distance less than this threshold
#define kGoalScore 100                  // plus this score
#define kReboundScore -10                   // if ball hit pin, plus this (negative) score

@interface ViewController : UIViewController 
@end
