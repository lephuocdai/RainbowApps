//
//  ViewController.h
//  ToyCamera
//
//  Created by レー フックダイ on 5/2/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

- (IBAction)doCamera:(id)sender;
- (IBAction)doFilter:(id)sender;
- (IBAction)doSave:(id)sender;

@end
