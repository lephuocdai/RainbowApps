//
//  CBViewController.m
//  ClapBeat
//
//  Created by レー フックダイ on 3/23/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "CBViewController.h"
#import "Clap.h"

@interface CBViewController ()

@end

@implementation CBViewController {
    Clap *clapInstance;
    IBOutlet UIPickerView *pickerView;
    NSString *repeatNumbersForPicker[10];
    int repeatCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    clapInstance = [Clap initClap];
    
    repeatCount = 1;
    
    //Picker Viewの選択肢一覧を準備
    for (int i = 0; i < 10; i++) {
        NSString *numberText = [NSString stringWithFormat:@"%d回", i+1];
        repeatNumbersForPicker[i] = numberText;
    }
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return repeatNumbersForPicker[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    repeatCount = (int)row + 1;
}

- (IBAction)play:(id)sender {
    [clapInstance repeatClap:repeatCount];
}

@end
