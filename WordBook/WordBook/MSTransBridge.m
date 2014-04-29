//
//  MSTransBridge.m
//  WordBook
//
//  Copyright (c) 2013年 RainbowApps. All rights reserved.
//

#import "MSTransBridge.h"

@implementation MSTransBridge {
    
}

-(NSString *)getAccessToken {
    //XXXXは顧客の秘密
    NSString *clientSecret = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                          NULL,
                                                                                          (CFStringRef)@"dbD57cTzM+wHb18EXxVq/lLWvswUpduqiJZP0rUold8=",
                                                                                          NULL,
                                                                                          (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                          kCFStringEncodingUTF8
                                                                                          );
    //翻訳APIを利用するため、AccessTokenを取得する
    NSString *tokenurlString =
    [NSString stringWithFormat:@"https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"];
    NSMutableURLRequest *req =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:tokenurlString]
                            cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    //YYYYはクライアントID
    NSString *params =
    [NSString stringWithFormat:
     @"client_id=%@&client_secret=%@&grant_type=client_credentials&scope=http://api.microsofttranslator.com",
     @"RaWbTest",
     clientSecret
     ];
    [req setHTTPMethod:@"POST"];//メソッドをPOSTに指定します
    [req setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    NSData * res = [NSURLConnection sendSynchronousRequest:req
                                         returningResponse:nil
                                                     error:nil];
    NSString * responseString = [[NSString alloc]initWithData:res encoding:NSUTF8StringEncoding];
    return [[responseString JSONValue] objectForKey:@"access_token"];
}

-(NSString *)translate:(NSString *)word to:(NSString *)lang at:(NSString*)access_token{
    
    //翻訳元の単語（日本語）をURLに適する形に変換
    NSString *wordUTF8 = [word
                          stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //URLを作成
    NSString *urlString =
    [NSString stringWithFormat:
     @"http://api.microsofttranslator.com/v2/Http.svc/Translate?text=%@&from=ja&to=%@",
     wordUTF8,
     lang
     ];
    
    //リクエスト送信設定
    NSURL* url;
    url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    // AccessTokenをヘッダー情報を追加する。
    NSString *header = [NSString stringWithFormat:@"Bearer %@", access_token];
    [request addValue:header forHTTPHeaderField:@"Authorization"];
    //リクエストしてデータを取得
    NSData *dataReplay;
    NSString *stringReplay;
    NSURLResponse *response;
    NSError *error;
    dataReplay = [NSURLConnection sendSynchronousRequest:request
                                       returningResponse:&response error:&error];
    //utf8データとして取得
    stringReplay = [[NSString alloc] initWithData:dataReplay
                                         encoding:NSUTF8StringEncoding];
    //取得結果を正規表現でパースする準備
    NSError *errorText = nil;
    NSString *translationResult = [[NSString alloc] init];
    NSRegularExpression *regexp = [NSRegularExpression
                                   regularExpressionWithPattern:@"<(.+)>(.+)<(.+)>"
                                   options:0 error:&errorText];
    if (errorText != nil) {
        NSLog(@"%@", error);
    } else {
        //正規表現で翻訳結果を取得
        NSTextCheckingResult *match =
        [regexp firstMatchInString:stringReplay options:0
                             range:NSMakeRange(0, stringReplay.length)];
        //正規表現に該当した数を取得
        NSLog(@"range: %lu", (unsigned long)match.numberOfRanges);
        //正規表現に該当した結果（配列）の3番目に翻訳結果文字列が格納されているのでそれを取得
        translationResult = [stringReplay
                             substringWithRange:[match rangeAtIndex:2]]; //「Tomorrow」
        NSLog(@"result :%@", translationResult);
    }
    
    return translationResult;
}


@end
