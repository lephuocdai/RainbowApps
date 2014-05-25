//
//  ViewController.m
//  GestureForm
//
//  Created by レー フックダイ on 5/25/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    IBOutlet UITextField *inputField;
    IBOutlet UIButton *nextButton;
    NSString *inputString;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
    inputField.delegate = self;
    nextButton.hidden = YES;
    
    [self setGestureRecognizers];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    inputString = sender.text;
    
    [sender resignFirstResponder];
    
    return TRUE;
}

#pragma mark - UIGestureRecognizerDelegate

- (void)setGestureRecognizers {
    
    UISwipeGestureRecognizer* swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(swipeDownDetected:)];
    swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownRecognizer];
    
    
    UISwipeGestureRecognizer *swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(swipeUpDetected:)];
    swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpRecognizer];
    
    
    UIPinchGestureRecognizer *pinchRegonizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(pinchDetected:)];
    [self.view addGestureRecognizer:pinchRegonizer];
}

#pragma mark - GestureDetected

//下向きスワイプ検知時に呼ばれるメソッド
- (IBAction)swipeDownDetected:(UIGestureRecognizer *)sender {
    NSLog(@"下向きSwipe");
    [self clearTextField];
}

//上向きスワイプ検知時に呼ばれるメソッド
- (IBAction)swipeUpDetected:(UIGestureRecognizer *)sender {
    NSLog(@"上向きSwipe");
    [self recoverTextField];
}

//ピンチ動作検知時に呼ばれるメソッド
- (IBAction)pinchDetected:(UIGestureRecognizer *)sender {
    //ピンチ開始の2本の指の距離を1とした時
    //現在の2本の指の相対距離
    CGFloat scale = [(UIPinchGestureRecognizer *)sender scale];
    
    if (scale < 0.7) {
        [inputField resignFirstResponder];
        nextButton.hidden = NO;
    }
}

#pragma mark - Navigation


- (IBAction)nextButtonPushed:(id)sender {
    [self performSegueWithIdentifier:@"toSecondView" sender:self];
}

- (void)clearTextField {
    inputString = inputField.text;
    inputField.text = nil;
}

- (void)recoverTextField {
    if (inputString != nil && ![inputString  isEqual: @""]) {
        [inputField setText:inputString];
    }
}


@end
