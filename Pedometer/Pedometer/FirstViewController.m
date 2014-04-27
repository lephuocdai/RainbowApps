//
//  FirstViewController.m
//  Pedometer
//
//  Created by レー フックダイ on 4/27/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "FirstViewController.h"


@interface FirstViewController ()

@end

@implementation FirstViewController {
    Accelerometer *accel;
    BOOL stepFlag;
    int stepCount;
    IBOutlet UILabel *stepCountLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reset];
    [self initAccel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initAccel {
    accel = [[Accelerometer alloc] initWithDelegate:self];
    [accel addAcceleration];
}

- (IBAction)sendMail:(id)sender {
    NSString *subject = @"歩きました";
    NSString *message = [NSString stringWithFormat:@"たった今、私は %d 歩きました!", stepCount];
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    if ([MFMailComposeViewController canSendMail]) {
        mailPicker.mailComposeDelegate = self;
        [mailPicker setSubject:subject];
        [mailPicker setMessageBody:message isHTML:false];
        [self presentViewController:mailPicker animated:YES completion:nil];
    }
}

- (IBAction)resetButtonAction:(id)sender {
    [self reset];
}

- (void)reset {
    stepFlag = FALSE;
    stepCount = 0;
    stepCountLabel.text = [NSString stringWithFormat:@"%d", stepCount];
}

#pragma mark Accelerometer delegate
- (void)analyzeWalk:(UIAccelerationValue)x :(UIAccelerationValue)y :(UIAccelerationValue)z {
    UIAccelerationValue hiThreshold = 1.1;
    UIAccelerationValue lowThreshold = 0.9;
    UIAccelerationValue composite;
    composite = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));
    if (stepFlag == TRUE) {
        if (composite < lowThreshold) {
            stepCount++;
            stepFlag = FALSE;
        }
    } else {
        if (composite > hiThreshold) {
            stepFlag = TRUE;
        }
    }
    NSLog(@"%f %f %f %f", x, y, z, composite);
    stepCountLabel.text = [NSString stringWithFormat:@"%d", stepCount];
}

#pragma mark MFMailCompose delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
