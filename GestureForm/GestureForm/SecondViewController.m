//
//  SecondViewController.m
//  GestureForm
//
//  Created by レー フックダイ on 5/25/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setGestureRecognizers];
}

- (void)setGestureRecognizers {
    
    UIPinchGestureRecognizer *pinchRegonizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(pinchDetected:)];
    [self.view addGestureRecognizer:pinchRegonizer];
}

#pragma mark - GestureDetected
//ピンチ動作検知時に呼ばれるメソッド
- (IBAction)pinchDetected:(UIGestureRecognizer *)sender {
    //ピンチ開始の2本の指の距離を1とした時
    //現在の2本の指の相対距離
    CGFloat scale = [(UIPinchGestureRecognizer *)sender scale];
    
    if (scale < 0.7) {
        [self performSegueWithIdentifier:@"toThirdView" sender:self];
    }
}


@end
