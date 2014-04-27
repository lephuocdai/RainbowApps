//
//  FirstViewController.h
//  Pedometer
//
//  Created by レー フックダイ on 4/27/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Accelerometer.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface FirstViewController : UIViewController <AccelerometerDelegate, MFMailComposeViewControllerDelegate>

@end
