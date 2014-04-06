//
//  Clap.m
//  ClapBeat
//
//  Created by レー フックダイ on 4/6/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "Clap.h"

@implementation Clap {
    // 音のファイルの所在を示すURL
    CFURLRef soundURL;
    
    // サウンドIDを生成
    SystemSoundID soundID;
}

// 初期化処理
+ (id)initClap {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    [self setSound];
    return self;
}


// 音フィアルを読み込んで設定
-(void)setSound {
    // ファイルを読み込んで、soundURLを生成
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    soundURL = CFBundleCopyResourceURL(mainBundle, CFSTR("clap"), CFSTR("wav"), nil);
    // soundURLをもとに、soundIDを生成
    AudioServicesCreateSystemSoundID(soundURL, &(soundID));
}

// soundIDを再生
-(void)play {
    AudioServicesPlaySystemSound(soundID);
}

// while文による繰り返し
-(void)repeatClap:(int)count {
    int i = 0;
    while (i < count) {
        [self play];
        i++;
        usleep(500000);
    }
}

@end
