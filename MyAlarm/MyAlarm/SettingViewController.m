//
//  SettingViewController.m
//  MyAlarm
//
//  Created by レー フックダイ on 5/2/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController {
    IBOutlet UIDatePicker *picker;
    IBOutlet UIBarItem *saveButton;
    IBOutlet UIBarItem *refreshButton;
    IBOutlet UIBarItem *cancelButton;
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
    if (self.dispDate != nil) {
        [picker setDate:self.dispDate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonClicked:(id)sender {
    [self.delegate saveButtonClicked:self selectedDate:picker.date pickerName:self.pickerName];
}
- (IBAction)cancelButtonClicked:(id)sender {
    [self.delegate cancelButtonClicked:self pickerName:self.pickerName];
}
- (IBAction)refreshButtonClicked:(id)sender {
    [self.delegate refreshButtonClicked:self pickerName:self.pickerName];
}

@end
