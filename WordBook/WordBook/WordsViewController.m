//
//  WordsViewController.m
//  WordBook
//
//  Created by レー フックダイ on 4/29/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "WordsViewController.h"

@interface WordsViewController ()

@end

@implementation WordsViewController {
    NSMutableArray *wordList;
    IBOutlet UITableView *wordTableView;
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
    
    [self getAllWords];
}

- (void)didReceiveMemoryWarning
{
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

#pragma mark - 「戻る」ボタン
- (IBAction)back:(id)sender {
    [self.delegate wordsViewControllerDidCancel:self];
}

#pragma mark - 一覧を全件取得
- (void)getAllWords {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *docFilePath = [documentsDirectory stringByAppendingString:@"wordList.plist"];
    wordList = [NSMutableArray arrayWithContentsOfFile:docFilePath];
    if (!wordList) {
        wordList = [[NSMutableArray alloc] init];
    }
}

#pragma mark - Table Viewの設定
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return wordList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"WordCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *dic = [wordList objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"searchWord"];
    return cell;
}

#pragma mark - セルがクリックされた時
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [wordList objectAtIndex:indexPath.row];
    [self.delegate wordsViewControllerDidSelect:self withDictionary:dic];
}

#pragma mark - 












@end
