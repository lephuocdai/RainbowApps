//
//  ViewController.m
//  AnytimeYouTube
//
//  Created by レー フックダイ on 5/2/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "ViewController.h"
#import "JSON.h"

@interface ViewController ()

@end

@implementation ViewController {
    NSMutableArray *dataArray;
    IBOutlet UITableView *youTubeTableView;
    IBOutlet UITableViewCell *cellYouTube;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [[NSBundle mainBundle] loadNibNamed:@"cellYouTube" owner:self options:nil];
    [youTubeTableView setRowHeight:cellYouTube.frame.size.height];
    cellYouTube = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cellYouTube";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"cellYouTube" owner:self options:nil];
        cell = cellYouTube;
        cellYouTube = nil;
    }
    
    if (dataArray.count > indexPath.row) {
        UIWebView *aWebView = (UIWebView*)[cell viewWithTag:11];
        UILabel *aLabel = (UILabel*)[cell viewWithTag:12];
        UITextView *aTextView = (UITextView*)[cell viewWithTag:13];
        
        UIActivityIndicatorView *anIndicator = (UIActivityIndicatorView*)[cell viewWithTag:15];
        [anIndicator startAnimating];
        
        NSMutableDictionary *dict = [dataArray objectAtIndex:indexPath.row];
        [aLabel setText:[dict valueForKey:@"title"]];
        [aTextView setText:[dict valueForKey:@"description"]];
        NSString *videoId = [dict valueForKey:@"id"];
        if (videoId) {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"EmbedPlayer" ofType:@"html"];
            NSError *error = nil;
            NSString *html = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
            if (error != nil) {
                NSLog(@"HTML reading error %@", [error localizedDescription]);
            } else {
                NSString *translateHTML = [html stringByReplacingOccurrencesOfString:@"_YOUTUBE_VIDEO_ID_" withString:videoId];
                [aWebView loadHTMLString:translateHTML baseURL:nil];
            }
        }
        
    }
    return cell;
}



#pragma UISearchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *keyword = [searchBar text];
    
    [searchBar resignFirstResponder];
    
    NSString *requestFeed = @"http://gdata.youtube.com/feeds/api/videos?q=%@&v=2&format=1,6&alt=jsonc";
    NSString *urlString = [NSString stringWithFormat:requestFeed, [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"url = %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    // 指定したURLのresponseを取得(JSON dataを取得)
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *resultDict = [jsonString JSONValue];
    // 検索結果をセット
    [dataArray removeAllObjects];
    
    NSDictionary *rawData = [resultDict valueForKey:@"data"];
    NSArray *itemArray = [rawData valueForKey:@"items"];
    
    for (NSDictionary *item in itemArray) {
        NSString *videoTitle = [item objectForKey:@"title"];
        NSString *videoId = [item objectForKey:@"id"];
        NSString *videoDescription = [item objectForKey:@"description"];
        NSString *videoContent = [item objectForKey:@"content"];
        NSLog(@"title = %@",videoTitle);
        NSLog(@"id = %@",videoId);
        NSLog(@"description = %@", videoDescription);
        NSLog(@"content: %@",[videoContent description]);
        
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
        [dataDict setValue:videoTitle forKey:@"title"];
        [dataDict setValue:videoId forKey:@"id"];
        [dataDict setValue:videoDescription forKey:@"description"];
        [dataDict setValue:videoContent forKey:@"content"];
        [dataArray addObject:dataDict];
    }
    [youTubeTableView reloadData];
}

#pragma mark UIWebView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    UITableViewCell *cell = (UITableViewCell*)[[webView superview] superview];
    UIActivityIndicatorView *anIndicator = (UIActivityIndicatorView*)[cell viewWithTag:15];
    [anIndicator stopAnimating];
}


















@end
