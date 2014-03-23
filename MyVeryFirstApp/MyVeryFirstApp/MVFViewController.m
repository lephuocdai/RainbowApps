//
//  MVFViewController.m
//  MyVeryFirstApp
//
//  Created by レー フックダイ on 3/23/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "MVFViewController.h"

@interface MVFViewController ()

@end

@implementation MVFViewController {
    // ラベル用のインスタンス
    IBOutlet UILabel *myLabel;
    
    // ボタン用のインスタンス
    IBOutlet UIButton *myButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ボタンが押された時の処理
- (IBAction)buttonPushed {
    // myLabelが「表示」の場合は「非表示」に、「非表示」の場合は「表示」に
    if (myLabel.isHidden == NO)
        [myLabel setHidden:YES];
    else
        [myLabel setHidden:NO];
}


@end
