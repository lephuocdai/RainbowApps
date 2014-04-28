//
//  Contact.h
//  QRContact
//
//  Created by レー フックダイ on 4/27/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property NSString *lastname;
@property NSString *firstname;
@property NSString *lastyomi;
@property NSString *firstyomi;
@property NSMutableArray *emails;
@property NSMutableArray *phones;

@end
