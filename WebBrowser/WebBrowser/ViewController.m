//
//  ViewController.m
//  WebBrowser
//
//  Created by レー フックダイ on 4/27/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    IBOutlet UIWebView *webView;
    IBOutlet UITextField *urlField;
    
    NSString *pageTitle;
    NSString *url;
    
    bool loadSuccessful;
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
    // 初期URLを設定
    url = @"http://www.google.co.jp";
    [self makeRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)makeRequest {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSLog(@"%@", [NSURL URLWithString:url]);
    [webView loadRequest:urlRequest];
    loadSuccessful = false;
    // Status BarのActivity Indicatorを発動
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

#pragma mark UIWebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)view {
    url = [[view.request URL] absoluteString];
    pageTitle = [view stringByEvaluatingJavaScriptFromString:@"document.title"];
    urlField.text = url;
    // Status BarのActivity Indicatorを停止
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    loadSuccessful = true;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    // Status BarのActivity Indicatorを停止
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (([[error domain] isEqual:NSURLErrorDomain]) && ([error code] != NSURLErrorCancelled)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"「%@」をロードするのに失敗しました。"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)sender {
    NSString *keyboardInput = sender.text;  // keyboardのinputを収得
    if (![keyboardInput hasPrefix:@"http://"]) {
        NSString *prefix = @"http://";
        url = [prefix stringByAppendingString:keyboardInput];
        sender.text = url;
    } else
        url = keyboardInput;
    [sender resignFirstResponder];
    [self makeRequest];
    return TRUE;
}

- (IBAction)saveFavorites:(id)sender {
    // 新しいページをロード中はお気に入り登録を禁止
    if (loadSuccessful == false) {
        // エラーメッセージを表示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"エラー"
                                                        message:@"正常にロードされていません"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        return;
    }
    [self insertNewObject];
}

- (IBAction)goToFavorites:(id)sender {
    [self performSegueWithIdentifier:@"toFavoritesView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"toFavoritesView"]) {
        FavoritesViewController *destinationViewController = (FavoritesViewController*)[segue destinationViewController];
        destinationViewController.delegate = (id)self;
    }
}

#pragma FavoritesViewController delegate
- (void)favoritesViewControllerDidCancel:(FavoritesViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)favoritesViewControllerDidSelect:(FavoritesViewController *)controller withUrl:(NSString *)favoriteUrl {
    url = favoriteUrl;
    [self makeRequest];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Core Data

- (void)insertNewObject {
    // CoreDataの呼び出しを準備
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    // 保存する情報を用意
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"MyFavorites"
                                                                      inManagedObjectContext:context];
    [newManagedObject setValue:pageTitle forKey:@"title"];
    [newManagedObject setValue:url forKey:@"url"];
    
    // 保存する
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Error: %@, %@", error, [error userInfo]);
        abort();
    }
}




@end
