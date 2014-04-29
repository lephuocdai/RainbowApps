//
//  TranslationViewController.m
//  WordBook
//
//  Created by レー フックダイ on 4/29/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "TranslationViewController.h"

#define kWordListPlist @"wordList.plist"

@interface TranslationViewController ()

@end

@implementation TranslationViewController {
    // 翻訳APIを利用するためのobject
    MSTransBridge *transBridge;
    IBOutlet UITextField *inputField;
    IBOutlet UILabel *englishLabel;
    IBOutlet UILabel *germanLabel;
    IBOutlet UILabel *frenchLabel;
    IBOutlet UILabel *koreanLabel;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 翻訳結果を取得して保存する
- (IBAction)translateAndSave:(id)sender {
    transBridge = [[MSTransBridge alloc] init];
    NSString *searchWord = inputField.text;
    NSString *accessToken = [transBridge getAccessToken];
    // 翻訳を開始
    NSString *englishWord = [transBridge translate:searchWord to:@"en" at:accessToken];
    NSString *germanWord = [transBridge translate:searchWord to:@"de" at:accessToken];
    NSString *frenchWord = [transBridge translate:searchWord to:@"fr" at:accessToken];
    NSString *koreanWord = [transBridge translate:searchWord to:@"ko" at:accessToken];
    // Labelに表示
    englishLabel.text = englishWord;
    germanLabel.text = germanWord;
    frenchLabel.text = frenchWord;
    koreanLabel.text = koreanWord;
    
    // 翻訳結果をwordList.plistに保存
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setValue:searchWord forKey:@"searchWord"];
    [result setValue:englishWord forKey:@"english"];
    [result setValue:germanWord forKey:@"german"];
    [result setValue:frenchWord forKey:@"french"];
    [result setValue:koreanWord forKey:@"korean"];
    
    // 端末内のwordList.plistを開く
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *docFilePath = [documentDirectory stringByAppendingString:kWordListPlist];
    
    // 保存するdataをセットする
    NSMutableArray *words = [NSMutableArray arrayWithContentsOfFile:docFilePath];
    if (!words) {
        words = [[NSMutableArray alloc] init];
    }
    [words addObject:result];
    
    // 保存処理を実行
    BOOL success = [words writeToFile:docFilePath atomically:YES];
    if (!success)
        NSLog(@"File saving failed");
    else
        NSLog(@"Save success");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"翻訳 & 登録"
                                                        message:@"翻訳と登録が完了しました"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    });
}

#pragma mark - ソフトウェアキーボードを閉じる
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField canResignFirstResponder])
        [textField resignFirstResponder];
    return YES;
}

#pragma mark - 「ブックマーク」ボタン
- (IBAction)goToWords:(id)sender {
    [self performSegueWithIdentifier:@"toWordsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toWordsSegue"]) {
        WordsViewController *wvc = (WordsViewController*)[segue destinationViewController];
        wvc.delegate = (id)self;
    }
}

#pragma mark - 単語一覧画面から戻る
- (void)wordsViewControllerDidSelect:(WordsViewController *)controller withDictionary:(NSDictionary *)dict {
    inputField.text = [dict objectForKey:@"searchWord"];
    englishLabel.text = [dict objectForKey:@"english"];
    germanLabel.text = [dict objectForKey:@"german"];
    frenchLabel.text = [dict objectForKey:@"french"];
    koreanLabel.text = [dict objectForKey:@"korean"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)wordsViewControllerDidCancel:(WordsViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}







@end
