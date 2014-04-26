//
//  News.h
//  RSSReader
//
//  Created by レー フックダイ on 4/13/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *date;

@end
