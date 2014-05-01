//
//  SettingViewController.h
//  MyAlarm
//
//  Created by レー フックダイ on 5/2/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingViewControllerDelegate;


@interface SettingViewController : UIViewController

@property id<SettingViewControllerDelegate> delegate;
@property NSString *pickerName;
@property NSDate *dispDate;

@end



@protocol SettingViewControllerDelegate

- (void)saveButtonClicked:(SettingViewController*)controller selectedDate:(NSDate*)selectedDate pickerName:(NSString*)pickerName;
- (void)cancelButtonClicked:(SettingViewController*)controller pickerName:(NSString*)pickerName;
- (void)refreshButtonClicked:(SettingViewController*)controller pickerName:(NSString*)pickerName;

@end



