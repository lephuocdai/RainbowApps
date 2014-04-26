//
//  MasterViewController.m
//  RSSReader
//
//  Created by レー フックダイ on 4/13/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController {
    TBXML *rssXML;
    NSMutableArray *elements;
    IBOutlet UITableView *table;
    NSURL *urlForSafari;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    [self getXML];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return elements.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // セルのスタイルを標準のものに指定
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];

    UILabel *titleLabel = (UILabel*)[cell viewWithTag:1];
    UILabel *dateLabel = (UILabel*)[cell viewWithTag:2];
    
    // セル上のラベルに記事のタイトルと配信日時を格納
    News *file = [elements objectAtIndex:indexPath.row];
    titleLabel.text = file.title;
    dateLabel.text = file.date;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// リスト中のお気に入りアイテムが選択された時の処理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 選択された項目のURLを参照
    News *news = [elements objectAtIndex:indexPath.row];
    NSString *selectedURL = news.url;
    urlForSafari = [NSURL URLWithString:selectedURL];
    [self goToSafari];
}

/*
 
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 [_objects removeObjectAtIndex:indexPath.row];
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }
 }
 
 
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}
*/

#pragma mark XML Handling

- (void)getXML {
    NSString *urlString = @"http://rss.dailynews.yahoo.co.jp/fc/rss.xml";
    NSURL *url = [NSURL URLWithString:urlString];
    TBXMLSuccessBlock successBlock = ^(TBXML *tbxmlDocument) {
        NSLog(@"「%@」の収得に成功しました。", url);
        [self parseXML];
    };
    
    //失敗時のコールバック処理
    TBXMLFailureBlock failureBlock = ^(TBXML *tbxmlDocument, NSError * error) {
        NSLog(@"「%@」の取得に失敗しました。", url);
    };
    [UIApplication sharedApplication].networkActivityIndicatorVisible =  YES;
    
    // URLで指定したRSSのXMLをbackgroundでdownload
    rssXML = [TBXML tbxmlWithURL:url success:successBlock failure:failureBlock];
}

- (void)parseXML {
    elements = [[NSMutableArray alloc] init];
    // XMLの最初の要素<rss>を収得
    TBXMLElement *rssElement = rssXML.rootXMLElement;
    // <rss>以下の<channel>を収得
    TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:rssElement];
    // 実際のニュース項目を記録した<item>を収得
    TBXMLElement *itemElement = [TBXML childElementNamed:@"item" parentElement:channelElement];
    // <item>の数だけ繰り返し
    while (itemElement) {
        // <item>以下の<title>を収得
        TBXMLElement *titleElement = [TBXML childElementNamed:@"title" parentElement:itemElement];
        // <item>以下の<link>を収得
        TBXMLElement *urlElement = [TBXML childElementNamed:@"link" parentElement:itemElement];
        // <item>以下の<pubDate>を収得
        TBXMLElement *dateElement = [TBXML childElementNamed:@"pubDate" parentElement:itemElement];
        // それぞれの要素のテキスト内容をNSStringとして収得
        NSString *title = [TBXML textForElement:titleElement];
        NSString *url = [TBXML textForElement:urlElement];
        NSString *date = [TBXML textForElement:dateElement];
        
        NSLog(@"%@ %@", title, url);
        
        // 新しいNewsクラスのインスタンス生成
        News *news = [[News alloc] init];
        // newsにタイトル・URL・日時を格納
        news.title = title;
        news.url = url;
        news.date = date;
        
        // newsをelementListに追加
        [elements addObject:news];
        
        // 次の<item>要素へ移動
        itemElement = itemElement->nextSibling;
    }
    // backgroundでの処理完了に伴い、フロント側でリストを更新
    [self refreshTableOnFront];
}

- (IBAction)refreshList:(id)sender {
    [self getXML];
}

- (void)refreshTableOnFront {
    [self performSelectorOnMainThread:@selector(refreshTable) withObject:self waitUntilDone:TRUE];
}

// テーブルの内容をセット
- (void)refreshTable {
    // ステータスバーのAcitivity Indicatorを停止
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // 最新の内容にテーブルをセット
    [table reloadData];
}

- (void)goToSafari {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Safariの起動"
                                                    message:@"このニュースをSafariで開きますか"
                                                   delegate:self
                                          cancelButtonTitle:@"いいえ"
                                          otherButtonTitles:@"はい", nil];
    [alert show];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"いいえ"]) {
        NSLog(@"Safari起動キャンセル");
    } else if ([title isEqualToString:@"はい"]) {
        NSLog(@"Safari起動");
        [[UIApplication sharedApplication] openURL:urlForSafari];
    }
}


@end
