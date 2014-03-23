//
//  CounterViewController.m
//  Counter
//
//  Created by レー フックダイ on 3/23/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "CounterViewController.h"

@interface CounterViewController ()

@end

@implementation CounterViewController {
    
    // 合計値を管理する変数
    int count;
    
    // ラベル用の文字列を管理するインスタンス
    NSString *countLabelText;
    
    // ラベル用のインスタンス
    IBOutlet UILabel *countLabel;
    
    // ボタン用のインスタンス
    IBOutlet UIButton *plus;
    IBOutlet UIButton *minus;
    IBOutlet UIButton *reset;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    count = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)plusPushed:(id)sender {
    // countに1を追加
    count++;
    
    [self setLabel:countLabel by:count];
}

- (IBAction)minusPushed:(id)sender {
    // もしcountが整数であれば減らす
    if (count > 0)
        count--;
    
    [self setLabel:countLabel by:count];
}

- (IBAction)resetPushed:(id)sender {
    // countを0にする
    count = 0;
    
    [self setLabel:countLabel by:count];
}


- (void)setLabel:(UILabel*)aLabel by:(int)flag {
    if (flag >= 0 && flag < 10)
        aLabel.textColor = [UIColor whiteColor];
    
    switch (flag/10) {
        case 0:
            aLabel.textColor = [UIColor whiteColor];
            break;
        case 1:
            aLabel.textColor = [UIColor greenColor];
            break;
        case 2:
            aLabel.textColor = [UIColor yellowColor];
            break;
        default:
            aLabel.textColor = [UIColor redColor];
            break;
    }
    
    // ラベル用に文字列を用意
    countLabelText = [NSString stringWithFormat:@"%d", count];
    
    // countLabelの値を変更
    [countLabel setText:countLabelText];
}



@end
