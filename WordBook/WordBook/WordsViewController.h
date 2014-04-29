//
//  WordsViewController.h
//  WordBook
//
//  Created by レー フックダイ on 4/29/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WordsViewControllerDelegate;

@interface WordsViewController : UIViewController < UITableViewDelegate, UITableViewDataSource>
@property id <WordsViewControllerDelegate> delegate;
@end

@protocol WordsViewControllerDelegate <NSObject>

- (void)wordsViewControllerDidCancel:(WordsViewController*)controller;
- (void)wordsViewControllerDidSelect:(WordsViewController*)controller withDictionary:(NSDictionary*)dict;

@end
