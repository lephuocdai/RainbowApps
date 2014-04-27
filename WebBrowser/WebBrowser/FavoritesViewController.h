//
//  FavoritesViewController.h
//  WebBrowser
//
//  Created by レー フックダイ on 4/27/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Favorites.h"

// Delegateを宣言
@protocol FavoritesViewControllerDelegate;

@interface FavoritesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property id <FavoritesViewControllerDelegate> delegate;
@end


@protocol FavoritesViewControllerDelegate <NSObject>
- (void)favoritesViewControllerDidCancel: (FavoritesViewController*)controller;
- (void)favoritesViewControllerDidSelect: (FavoritesViewController*)controller withUrl:(NSString*)favoriteUrl;
@end

