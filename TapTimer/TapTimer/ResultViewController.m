//
//  ResultViewController.m
//  TapTimer
//
//  Created by レー フックダイ on 5/11/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@property (strong, nonatomic) IBOutlet UILabel *tapsLabel;

@end

@implementation ResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tapsLabel.text = [NSString stringWithFormat:@"%d", _taps];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
