//
//  AnimViewController.h
//  Para2Camera
//
//  Created by レー フックダイ on 5/2/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *aImageView;
@property (nonatomic, retain) IBOutlet UISlider *aSlider;

- (IBAction)sliderValueChanged:(id)sender;


@end
