//
//  Problem.m
//  Quiz
//
//  Created by レー フックダイ on 4/6/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "Problem.h"

@implementation Problem {
    NSString *question;
    int answer;
}

+ (id)initProblem {
    return [[self alloc] init];
}

- (void)setQ:(NSString*)q withA:(int)a {
    question = q;
    answer = a;
}

- (NSString*)getQ {
    return question;
}

- (int)getA {
    return answer;
}

@end
