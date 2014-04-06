//
//  Clap.h
//  ClapBeat
//
//  Created by レー フックダイ on 4/6/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface Clap : NSObject

+(id)initClap;
-(void)repeatClap:(int)count;

@end
