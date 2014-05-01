//
//  ViewController.h
//  MyAlarm
//
//  Created by レー フックダイ on 5/1/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"
#import <AVFoundation/AVAudioPlayer.h>

@interface ViewController : UIViewController <SettingViewControllerDelegate, AVAudioPlayerDelegate>

@property NSDate *dateForDate;

@end
