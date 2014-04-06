//
//  DYViewController.m
//  DollarYen
//
//  Created by レー フックダイ on 3/23/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "DYViewController.h"

@interface DYViewController ()

@end

@implementation DYViewController {
    
    // Data model
    double input;
    double result;
    double rate;
    
    // For display
    IBOutlet UILabel *inputCurrency;
    IBOutlet UILabel *resultCurrency;
    IBOutlet UILabel *rateLabel;
    IBOutlet UILabel *resultLabel;
    
    // Controller
    IBOutlet UISegmentedControl *selector;
    IBOutlet UITextField *inputField;
    bool isYenOrTollar;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Instantiate
    rate = [self getRate];
    input = 0;
    result = 0;
    isYenOrTollar = TRUE;
    
    // Set label
    [rateLabel setText:[NSString stringWithFormat:@"%.1f", rate]];
    
    inputField.delegate = self;
}

- (void)convert {
    if (isYenOrTollar) {
        result = input/rate;
        [resultLabel setText:[NSString stringWithFormat:@"%.2f", result]];
    } else {
        result = input*rate;
        [resultLabel setText:[NSString stringWithFormat:@"%.0f", result]];
    }
}
- (IBAction)changeCalcMethod:(id)sender {
    if (selector.selectedSegmentIndex == 0) {
        isYenOrTollar = TRUE;
        [inputCurrency setText:@"円"];
        [resultCurrency setText:@"ドル"];
    } else {
        isYenOrTollar = FALSE;
        [inputCurrency setText:@"ドル"];
        [resultCurrency setText:@"円"];
    }
    [self convert];
}

- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    input = [sender.text doubleValue];
    
    [sender resignFirstResponder];
    
    [self convert];
    
    return TRUE;
}


// Get the real time currency rate
- (double)getRate {
    //Prepare to establish the connection
    NSURL *url = [NSURL URLWithString:@"http://currency-api.appspot.com/api/USD/JPY.json?key=855c464d27f86fa3c3aa53985babb0dbe721f1d9"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    //Make the request
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //Parse the data as a series of Note objects
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    return [[json valueForKey:@"rate"] doubleValue];
}


@end
