//
//  ResultViewController.m
//  GestureFlash
//
//  Created by レー フックダイ on 4/13/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@end

@implementation ResultViewController {
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *newHighScoreLabel;
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
    timeLabel.text = [NSString stringWithFormat:@"%.3f 秒", _time];
    [self checkHighScore];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkHighScore {
    bool hasNewHighScore = false;
    newHighScoreLabel.hidden = true;
    
    // Get highscores from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    double highscore1 = [defaults doubleForKey:@"highscore1"];
    double highscore2 = [defaults doubleForKey:@"highscore2"];
    double highscore3 = [defaults doubleForKey:@"highscore3"];
    
    //（全てのハイスコアが既にある場合）比較の結果、今回のtimeが当てはまる順位に記録を挿入
    //1位より早い場合
    if (highscore1 != 0 && _time <= highscore1) {
        highscore3 = highscore2;
        highscore2 = highscore1;
        highscore1 = _time;
        hasNewHighScore = true;
        //2位より早い場合
    } else if (highscore2 != 0 && _time <= highscore2) {
        highscore3 = highscore2;
        highscore2 = _time;
        hasNewHighScore = true;
        //3位より早い場合
    } else if (highscore3 != 0 && _time <= highscore3) {
        highscore3 = _time;
        hasNewHighScore = true;
    }
    // ハイスコアがまだ格納されていない場合の_timeとの比較
    // 1位がまだない場合
    else if (highscore1 == 0) {
        highscore1 = _time;
        hasNewHighScore = true;
    // 2位がまだなく、1位より遅い場合
    } else if (highscore2 == 0 && _time >= highscore1) {
        highscore2 = _time;
        hasNewHighScore = true;
    // 3位がまだなく、2位より遅い場合
    } else if (highscore3 == 0 && _time >= highscore2) {
        highscore3 = _time;
        hasNewHighScore = true;
    }
    
    // 新しいハイスコアをUserDefaultsに保存
    [defaults setDouble:highscore1 forKey:@"highscore1"];
    [defaults setDouble:highscore2 forKey:@"highscore2"];
    [defaults setDouble:highscore3 forKey:@"highscore3"];
    // もし、ハイスコアが更新された場合は「ハイスコア更新」ラベルを表示
    if (hasNewHighScore == true)
        newHighScoreLabel.hidden = false;
}

@end






































