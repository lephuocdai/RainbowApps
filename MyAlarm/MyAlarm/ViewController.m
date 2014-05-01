//
//  ViewController.m
//  MyAlarm
//
//  Created by レー フックダイ on 5/1/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSTimer *timer;
    
    // 時計の各行の数字を格納する変数
    int hoursecond;
    int hourfirst;
    int minutesecond;
    int minutefirst;
    int secondsecond;
    int secondfirst;
    
    // 時計用イメージ
    UIImage *image0;
    UIImage *image1;
    UIImage *image2;
    UIImage *image3;
    UIImage *image4;
    UIImage *image5;
    UIImage *image6;
    UIImage *image7;
    UIImage *image8;
    UIImage *image9;
    //時計表示用の画像パス
    NSString *aImagePath0;
    NSString *aImagePath1;
    NSString *aImagePath2;
    NSString *aImagePath3;
    NSString *aImagePath4;
    NSString *aImagePath5;
    NSString *aImagePath6;
    NSString *aImagePath7;
    NSString *aImagePath8;
    NSString *aImagePath9;
    
    NSArray *imageArray;
    
    IBOutlet UIImageView *imageView_hour10;
    IBOutlet UIImageView *imageView_hour0;
    IBOutlet UIImageView *imageView_min10;
    IBOutlet UIImageView *imageView_min0;
    
    SettingViewController *datePickerController;
    IBOutlet UILabel *labelForDate;
    
    NSString *alarmSound;
    NSDate *now;
    NSString *now_Str;
    int alertFLG;
    NSString *setDateStr;
    AVAudioPlayer *player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Timer作成
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(time:)
                                           userInfo:nil
                                            repeats:YES];
    
    alarmSound = [[NSBundle mainBundle] pathForResource:@"koukaon1" ofType:@"wav"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)time:(NSTimer*)timer {
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [cal components:unitFlags fromDate:[NSDate date]];
    
    now = [NSDate date];
    now_Str = [[self dateFormatter] stringFromDate:now];
    
    int hour = [components hour];
    int minute = [components minute];
    int second = [components second];
    
    //「時」の一行目と二行目を分解
    if (hour > 9) {
        hoursecond = hour/10;
        hourfirst = hour - hoursecond*10;
    } else {
        hoursecond = 0;
        hourfirst = hour;
    }
    //「分」の一桁目と二桁目を分解
    if (minute>9) {
        minutesecond = minute/10;
        minutefirst = minute - (floor(minute/10)*10);
    } else {
        minutesecond = 0;
        minutefirst = minute;
    }
    
    //「秒」の一桁目と二桁目を分解
    if (second>9) {
        secondsecond = second/10;
        secondfirst = second - (floor(second/10)*10);
    } else {
        secondsecond = 0;
        secondfirst = second;
    }
    
    setDateStr = [[self dateFormatter] stringFromDate:self.dateForDate];
    
    if ([setDateStr isEqualToString:now_Str]) {
        if (alertFLG < 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ALARM"
                                                            message:@"It's time"
                                                           delegate:self
                                                  cancelButtonTitle:@"STOP"
                                                  otherButtonTitles:nil];
            [alert show];
            NSString *soundFilePath = [NSString stringWithFormat:@"%@", alarmSound];
            NSURL *soundURL = [NSURL fileURLWithPath:soundFilePath];
            NSError *error = nil;
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
            if (error != nil) {
                NSLog(@"AVAudioPlayerのイニシャライズでエラー(%@)", [error localizedDescription]);
                return;
            }
            [player setDelegate:self];
            [player play];
        }
        alertFLG++;
    }
    
    [self draw];
}

- (void)draw {
    aImagePath0 = [[NSBundle mainBundle] pathForResource:@"0" ofType:@"png"];
    aImagePath1 = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    aImagePath2 = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"png"];
    aImagePath3 = [[NSBundle mainBundle] pathForResource:@"3" ofType:@"png"];
    aImagePath4 = [[NSBundle mainBundle] pathForResource:@"4" ofType:@"png"];
    aImagePath5 = [[NSBundle mainBundle] pathForResource:@"5" ofType:@"png"];
    aImagePath6 = [[NSBundle mainBundle] pathForResource:@"6" ofType:@"png"];
    aImagePath7 = [[NSBundle mainBundle] pathForResource:@"7" ofType:@"png"];
    aImagePath8 = [[NSBundle mainBundle] pathForResource:@"8" ofType:@"png"];
    aImagePath9 = [[NSBundle mainBundle] pathForResource:@"9" ofType:@"png"];
    
    image0 = [UIImage imageWithContentsOfFile:aImagePath0];
    image1 = [UIImage imageWithContentsOfFile:aImagePath1];
    image2 = [UIImage imageWithContentsOfFile:aImagePath2];
    image3 = [UIImage imageWithContentsOfFile:aImagePath3];
    image4 = [UIImage imageWithContentsOfFile:aImagePath4];
    image5 = [UIImage imageWithContentsOfFile:aImagePath5];
    image6 = [UIImage imageWithContentsOfFile:aImagePath6];
    image7 = [UIImage imageWithContentsOfFile:aImagePath7];
    image8 = [UIImage imageWithContentsOfFile:aImagePath8];
    image9 = [UIImage imageWithContentsOfFile:aImagePath9];
    
    
    imageArray = [NSArray arrayWithObjects:image0,image1,image2,image3,image4,image5,image6,image7,image8,image9, nil];
    
    [imageView_hour10 setImage:[imageArray objectAtIndex:hoursecond]];
    [imageView_hour0 setImage:[imageArray objectAtIndex:hourfirst]];
    [imageView_min10 setImage:[imageArray objectAtIndex:minutesecond]];
    [imageView_min0 setImage:[imageArray objectAtIndex:minutefirst]];
}

- (IBAction)plusButtonClicked:(id)sender {
    datePickerController = [[SettingViewController alloc] init];
    datePickerController.pickerName = @"pickerOfDate";
    datePickerController.dispDate = (self.dateForDate != nil) ? self.dateForDate : [NSDate date];
    datePickerController.delegate = self;
    [self showModal:datePickerController.view];
}

- (void)showModal:(UIView*)modalView {
    UIWindow *mainWindow = (((AppDelegate*)[UIApplication sharedApplication].delegate).window);
    CGPoint middleCenter = modalView.center;
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width/2.0, offSize.height*1.5);
    modalView.center = offScreenCenter;
    [mainWindow addSubview:modalView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    modalView.center = middleCenter;
    [UIView commitAnimations];
}

- (void)hideModal:(UIView*)modalView {
    CGSize offSize = [UIScreen mainScreen].bounds.size;
    CGPoint offScreenCenter = CGPointMake(offSize.width/2.0, offSize.height*1.5);
    [UIView beginAnimations:nil context:(__bridge void*)modalView];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideModalEnded:finished:context:)];
    modalView.center = offScreenCenter;
    [UIView commitAnimations];
}

- (void)hideModalEnded:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
    UIView *modalView = (__bridge UIView*)context;
    [modalView removeFromSuperview];
}

- (NSDateFormatter*)dateFormatter {
    static NSDateFormatter *_dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"HH:mm"];
    });
    return _dateFormatter;
}

- (void)saveButtonClicked:(SettingViewController *)controller selectedDate:(NSDate *)selectedDate pickerName:(NSString *)pickerName {
    [self hideModal:datePickerController.view];
    datePickerController = nil;
    if ([pickerName isEqualToString:@"pickerOfDate"]) {
        self.dateForDate = selectedDate;
        labelForDate.text = [[self dateFormatter] stringFromDate:self.dateForDate];
    }
}

- (void)cancelButtonClicked:(SettingViewController *)controller pickerName:(NSString *)pickerName {
    [self hideModal:datePickerController.view];
    datePickerController = nil;
}

- (void)refreshButtonClicked:(SettingViewController *)controller pickerName:(NSString *)pickerName {
    [self hideModal:datePickerController.view];
    datePickerController = nil;
    if ([pickerName isEqualToString:@"pickerOfDate"]) {
        self.dateForDate = nil;
        labelForDate.text = @"タイマー";
    }
}

@end
