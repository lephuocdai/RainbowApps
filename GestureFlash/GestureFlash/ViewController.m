//
//  ViewController.m
//  GestureFlash
//
//  Created by レー フックダイ on 4/13/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    IBOutlet UILabel *highscore1_label;
    IBOutlet UILabel *highscore2_label;
    IBOutlet UILabel *highscore3_label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // UserDefaultsへアクセスする
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // ハイスコアを収得し、double型の変数に格納
    double highscore1 = [defaults doubleForKey:@"highscore1"];
    double highscore2 = [defaults doubleForKey:@"highscore2"];
    double highscore3 = [defaults doubleForKey:@"highscore3"];
    
    // NSLogによるdebug message
    NSLog(@"ハイスコア: 1位-%f 2位-%f 3位-%f", highscore1,highscore2, highscore3);
    
    // ハイスコアの存在を確認
    // もし、ハイスコアが存在する場合（0でない場合）は画面の一覧に表示
    
    if (highscore1 != 0)
        highscore1_label.text = [NSString stringWithFormat:@"%.3f 秒",highscore1];
    if (highscore2 != 0)
        highscore2_label.text = [NSString stringWithFormat:@"%.3f 秒",highscore2];
    if (highscore3 != 0)
        highscore3_label.text = [NSString stringWithFormat:@"%.3f 秒",highscore3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
