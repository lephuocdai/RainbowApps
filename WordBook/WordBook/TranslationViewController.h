//
//  TranslationViewController.h
//  WordBook
//
//  Created by レー フックダイ on 4/29/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSTransBridge.h"
#import "WordsViewController.h"

@interface TranslationViewController : UIViewController <UITextFieldDelegate, WordsViewControllerDelegate>

@property NSInteger fileIdx;

@end
