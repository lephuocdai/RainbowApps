//
//  ViewController.m
//  BallRolling
//
//  Created by レー フックダイ on 5/5/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    IBOutlet UIImageView *base;
    IBOutlet UIImageView *gem;
    IBOutlet UIImageView *start;
    IBOutlet UIImageView *goal;
    
    // Obstacles
    NSMutableArray *pins;
    
    IBOutlet UIImageView *game_over;
    IBOutlet UILabel *scoreLabel;
    
    IBOutlet UIButton *startButton;
    
    // For acceleration management
    UIAccelerationValue accelX, accelY, accelZ;     // あそびをつけた各軸座標の値
    CMMotionManager *motionManager;                 // CoreMotionを利用するためのオブジェクト
    CGSize vec;                                     // 玉の加速度
    
    NSTimer *aTimer;
    
    NSInteger score;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    // Init pins by searching for UIImageView in self.view which has image name is pin.png
    pins = [[NSMutableArray alloc] init];
    for (UIView *subview in self.view.subviews) {
        if ([[subview class] isSubclassOfClass:[UIImageView class]]) {
            if ([((UIImageView*)subview).image isEqual:[UIImage imageNamed:@"pin.png"]]) {
                [pins addObject:subview];
            }
        }
    }
}

#pragma mark - Game
- (IBAction)doStart:(id)sender {
    [startButton setHidden:YES];
    [game_over setHidden:YES];
    
    gem.center = start.center;
    vec = CGSizeMake(0.0f, 0.0f);
    score = kDefaultScore;
    [self calcScore:0];
    
    [self startAccelerometer];
    [self startTimer];
}

- (void)doStop {
    [startButton setHidden:NO];
    [game_over setHidden:NO];
    
    [self stopAccelerometer];
    [self stopTimer];
}

- (void)calcScore:(NSInteger)value {
    score += value;
    scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    if (score == 0)
        [self doStop];
}

- (void)checkGoal {
    CGFloat dx = goal.center.x - gem.center.x;
    CGFloat dy = goal.center.y - gem.center.y;
    
    if ( sqrt(dx*dx + dy*dy) < kGoalThreshold) {
        [self calcScore:kGoalScore];
        
        // Goalとstartを入れ替え
        CGPoint position = goal.center;
        goal.center = start.center;
        start.center = position;
    }
}


#pragma mark - Motion manager
- (void)didAccelerate:(CMAcceleration)acceleratio {
    
    // 取得した加速度の値に制限を加えて「あそび」をつくる
    accelX = (accelX * kFilterFactor) + (acceleratio.x * (1.0f - kFilterFactor));
    accelY = (accelY * kFilterFactor) + (acceleratio.y * (1.0f - kFilterFactor));
    accelZ = (accelZ * kFilterFactor) + (acceleratio.z * (1.0f - kFilterFactor));
    
    // 加速度により玉を動かすための座標を生成する
    vec = CGSizeMake(vec.width + accelX, vec.height - accelY);
}

- (void)startAccelerometer {
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = (1.0f/kAccelerometerFrequency); // 加速度センサを読み込む間隔を設定
    // accelHanler starts when there accelerometer updates
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self didAccelerate:accelerometerData.acceleration];
    }];
}

- (void)stopAccelerometer {
    [motionManager stopAccelerometerUpdates];
}

#pragma mark - Timer
- (void)stopTimer {
    if (aTimer) {
        [aTimer invalidate];
        aTimer = nil;
    }
}

- (void)startTimer {
    if (aTimer)
        [self stopTimer];
    aTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval
                                              target:self
                                            selector:@selector(tick:)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)checkPin:(UIImageView*)pin {
    CGFloat dx = (pin.center.x - gem.center.x);
    CGFloat dy = (pin.center.y - gem.center.y);
    
    if ( sqrt(dx*dx + dy*dy) < 9 + kRadius) {
        CGFloat inp = vec.width*dx + vec.height*dy;
        if (inp > 0) {
            [self calcScore:kReboundScore];
            CGFloat ddl = dx*dx + dy*dy;
            vec.width -= dx * inp/ddl*kRefPower;
            vec.height -= dy * inp/ddl*kRefPower;;
        }
    }
}

- (void)tick:(NSTimer*)theTimer {
    
    // Get postion at this moment
    CGFloat x = gem.center.x + vec.width;
    CGFloat y = gem.center.y + vec.height;
    
    // Check if ball bounded left or right borders
    if ( x + kRadius > 320) {
        [self calcScore:kReboundScore];
        vec.width = fabs(vec.width) * kWallRefPower * (-1);
        x = gem.center.x + vec.width;
    }
    if ( x - kRadius < 0) {
        [self calcScore:kReboundScore];
        vec.width = fabs(vec.width) * kWallRefPower;
        x = gem.center.x + vec.width;
    }
    
    // Check if ball bounded top or down borders
    int screenSizeHeight = [[UIScreen mainScreen] bounds].size.height;  // For multiple device
    if ( y + kRadius > screenSizeHeight) {
        [self calcScore:kReboundScore];
        vec.height = fabs(vec.height) * kWallRefPower * (-1);
        y = gem.center.y + vec.height;
    }
    if ( y - kRadius < 0) {
        [self calcScore:kReboundScore];
        vec.height = fabs(vec.height) * kWallRefPower;
        y = gem.center.y + vec.height;
    }
    
    // Check if ball bounded any pin
    for (UIImageView *pin in pins) {
        [self checkPin:pin];
    }
    
    [self checkGoal];
    
    gem.center = CGPointMake(x, y);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
