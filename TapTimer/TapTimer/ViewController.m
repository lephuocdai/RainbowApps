//
//  ViewController.m
//  TapTimer
//
//  Created by レー フックダイ on 5/11/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "ViewController.h"
#import "ResultViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *timeIndicatorLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *tapsLabel;
@property (strong, nonatomic) IBOutlet UIButton *tapButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;

@end

@implementation ViewController {
    NSTimer *timer;
    int taps;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
    
    _remainsCount = 5;
    _timeIndicatorLabel.hidden = YES;
    _timeLabel.hidden = YES;
    _tapsLabel.hidden = YES;
    _tapButton.hidden = YES;
    _startButton.hidden = NO;
    taps = 0;
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonPressed:(id)sender {
    _timeIndicatorLabel.hidden = NO;
    _timeLabel.hidden = NO;
    _tapsLabel.hidden = NO;
    _tapButton.hidden = NO;
    _startButton.hidden = YES;
     self.view.backgroundColor = [UIColor blackColor];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(countDown)
                                           userInfo:nil
                                            repeats:YES];
    _timeLabel.text = [NSString stringWithFormat:@"%d", _remainsCount];
}

- (void)countDown{
    _remainsCount--;
    
    if (_remainsCount == 0) {
        [timer invalidate];
        // Navigate to Result View Controller
        [self performSegueWithIdentifier:@"toResultView" sender:self];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ResultViewController *resultViewController = [storyboard instantiateViewControllerWithIdentifier:@"ResultViewController"];
        resultViewController.taps = taps;
        [self presentViewController:resultViewController animated:YES completion:nil];
    }
    
    _timeLabel.text = [NSString stringWithFormat:@"%d", _remainsCount];
}
- (IBAction)tapButtonPressed:(id)sender {
    taps++;
    _tapsLabel.text = [NSString stringWithFormat:@"%d",taps];
}

@end
