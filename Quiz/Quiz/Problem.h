//
//  Problem.h
//  Quiz
//
//  Created by レー フックダイ on 4/6/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Problem : NSObject

+ (id)initProblem;
- (void)setQ:(NSString*)q withA:(int)A;
- (NSString*)getQ;
- (int)getA;

@end
