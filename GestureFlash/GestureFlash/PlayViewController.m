//
//  PlayViewController.m
//  GestureFlash
//
//  Created by レー フックダイ on 4/13/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "PlayViewController.h"

#define GESTURES_MAX 30

@interface PlayViewController ()

@end

@implementation PlayViewController {
    NSDate *startTime;
    int completedGestures;
    int currentGesture;
    
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *completedGesturesLabel;
    
    IBOutlet UIImageView *gestureImage;
    
    NSTimer *timer;
    double timerCount;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    completedGestures = 0;
    [self setGestureRecognizers];
    [self nextProblem];
    startTime = [NSDate date];
    
    // 経過時間を表示するタイマーの始動
    // 0.1秒毎に「-(void)onTimer」が呼ばれる
    timerCount = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(onTimer:)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextProblem {
    // もし出題規定数（ジェスチャー30個）に達している場合
    if (completedGestures  == GESTURES_MAX) {
        // 結果表示画面へのsegueを起動
        [self performSegueWithIdentifier:@"toResultView" sender:self];
        return;
    }
    
    // 配列にジェスチャーを示す画像取り込み
    UIImage *gestureIcons[8];
    gestureIcons[0] = [UIImage imageNamed:@"swipe-right.png"];
    gestureIcons[1] = [UIImage imageNamed:@"swipe-left.png"];
    gestureIcons[2] = [UIImage imageNamed:@"swipe-up.png"];
    gestureIcons[3] = [UIImage imageNamed:@"swipe-down.png"];
    gestureIcons[4] = [UIImage imageNamed:@"pinch-in.png"];
    gestureIcons[5] = [UIImage imageNamed:@"pinch-out.png"];
    gestureIcons[6] = [UIImage imageNamed:@"rotate-right.png"];
    gestureIcons[7] = [UIImage imageNamed:@"rotate-left.png"];
    
    // 乱数をもとに、次のジェスチャーを選択
    srand((unsigned int) time(0));
    currentGesture = rand() % 8;
    
    NSLog(@"got new gesture current: %d", currentGesture);
    
    // 画面に出てるジェスチャーの画像を差し替え、問題番号を更新
    gestureImage.image = gestureIcons[currentGesture];
    completedGesturesLabel.text = [NSString stringWithFormat:@"%d", completedGestures];
}

- (void)onTimer:(NSTimer*)timer {
    timerCount += 0.1;
    timeLabel.text = [NSString stringWithFormat:@"%.1f",timerCount];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // 所要時間を計測
    NSTimeInterval elapsedTime = [startTime timeIntervalSinceNow];
    elapsedTime *= -1;
    
    if ([[segue identifier] isEqualToString:@"toResultView"]) {
        ResultViewController *rvc = (ResultViewController*)[segue destinationViewController];
        rvc.time = elapsedTime;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (void)setGestureRecognizers {
    UIPinchGestureRecognizer *pinchRegonizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(pinchDetected:)];
    [self.view addGestureRecognizer:pinchRegonizer];
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                                   action:@selector(rotationDetected:)];
    [self.view addGestureRecognizer:rotationRecognizer];
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(swipeRightDetected:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightRecognizer];
    UISwipeGestureRecognizer* swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(swipeLeftDetected:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    UISwipeGestureRecognizer *swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(swipeUpDetected:)];
    swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpRecognizer];
    UISwipeGestureRecognizer* swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(swipeDownDetected:)];
    swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownRecognizer];
    
}

#pragma mark - GestureDetected

//右向きスワイプ検知時に呼ばれるメソッド
- (IBAction)swipeRightDetected:(UIGestureRecognizer *)sender {
    NSLog(@"右向きSwipe");
    NSLog(@"current: %d", currentGesture);
    //正解が右向きSwipe（0番）なら
    if (currentGesture == 0) {
        NSLog(@"NEXT");
        completedGestures++;
        [self nextProblem];
    }
}

//左向きスワイプ検知時に呼ばれるメソッド
- (IBAction)swipeLeftDetected:(UIGestureRecognizer *)sender {
    NSLog(@"左向きSwipe");
    NSLog(@"current: %d", currentGesture);
    //正解が左向きSwipe（1番）なら
    if (currentGesture == 1) {
        NSLog(@"NEXT");
        completedGestures++;
        [self nextProblem];
    }
}

//上向きスワイプ検知時に呼ばれるメソッド
- (IBAction)swipeUpDetected:(UIGestureRecognizer *)sender {
    NSLog(@"上向きSwipe");
    NSLog(@"current: %d", currentGesture);
    //正解が上向きSwipe（2番）なら
    if (currentGesture == 2) {
        NSLog(@"NEXT");
        completedGestures++;
        [self nextProblem];
    }
}

//下向きスワイプ検知時に呼ばれるメソッド
- (IBAction)swipeDownDetected:(UIGestureRecognizer *)sender {
    NSLog(@"下向きSwipe");
    NSLog(@"current: %d", currentGesture);
    //正解が下向きSwipe（3番）なら
    if (currentGesture == 3) {
        NSLog(@"NEXT");
        completedGestures++;
        [self nextProblem];
    }
}

//回転動作検知時の呼ばれるメソッド
- (IBAction)rotationDetected:(UIGestureRecognizer *)sender {
    //Rotate開始時から見た回転の度合い（ラジアン）
    CGFloat radians = [(UIRotationGestureRecognizer *)sender rotation];
    //「ラジアン」を「度」に変換
    CGFloat degrees = radians * (180/M_PI);
    if (degrees > 90) {
        NSLog(@"時計回りにRotate degrees: %f", degrees);
        NSLog(@"current: %d", currentGesture);
        //正解が時計回りRotate（6番）なら
        if (currentGesture == 6) {
            NSLog(@"NEXT");
            completedGestures++;
            [self nextProblem];
        }
    } else if (degrees < -90) {
        NSLog(@"反時計回りにRotate degrees: %f", degrees);
        NSLog(@"current: %d", currentGesture);
        //正解が時計回りRotate（7番）なら
        if (currentGesture == 7) {
            NSLog(@"NEXT");
            completedGestures++;
            [self nextProblem];
        }
    }
}

//ピンチ動作検知時に呼ばれるメソッド
- (IBAction)pinchDetected:(UIGestureRecognizer *)sender {
    //ピンチ開始の2本の指の距離を1とした時
    //現在の2本の指の相対距離
    CGFloat scale = [(UIPinchGestureRecognizer *)sender scale];
    
    if (scale > 2.4) {
        NSLog(@"外向きにPinch scale: %f", scale);
        NSLog(@"current: %d", currentGesture);
        //正解が外向きPinch（5番）なら
        if (currentGesture == 5) {
            NSLog(@"NEXT");
            completedGestures++;
            [self nextProblem];
        }
    } else if (scale < 0.4) {
        NSLog(@"内向きにPinch scale: %f", scale);
        NSLog(@"current: %d", currentGesture);
        //正解が内向きPinch（4番）なら
        if (currentGesture == 4) {
            NSLog(@"NEXT");
            completedGestures++;
            [self nextProblem];
        }
    }
}



@end
