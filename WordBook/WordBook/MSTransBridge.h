//
//  MSTransBridge.h
//  WordBook
//
//  Copyright (c) 2013年 RainbowApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"

@interface MSTransBridge : NSObject

-(NSString *)getAccessToken;
-(NSString *)translate:(NSString *)word to:(NSString *)lang at:(NSString*)access_token;

@end
