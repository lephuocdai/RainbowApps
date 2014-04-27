//
//  MasterViewController.m
//  MyTweet
//
//  Created by レー フックダイ on 4/27/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController {
    NSArray *tweets;
    IBOutlet UITableView *table;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    [self getTimeline];
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
    return tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    
    UILabel *tweetLabel = (UILabel*)[cell viewWithTag:1];
    UILabel *userLabel = (UILabel*)[cell viewWithTag:2];
    
    NSDictionary *tweetMessage = [tweets objectAtIndex:indexPath.row];
    NSDictionary *userInfo = [tweetMessage objectForKey:@"user"];
    
    tweetLabel.text = [tweetMessage objectForKey:@"text"];
    userLabel.text = [userInfo objectForKey:@"screen_name"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *tweetMessage = [tweets objectAtIndex:indexPath.row];
    NSDictionary *userInfo = [tweetMessage objectForKey:@"user"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[userInfo objectForKey:@"screen_name"]
                                                    message:[tweetMessage objectForKey:@"text"]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
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
- (void)getTimeline {
    NSString *apiURL = @"https://api.twitter.com/1.1/statuses/home_timeline.json";
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [store requestAccessToAccountsWithType:twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
        if (!granted) {
            NSLog(@"Twitterへの認証が拒否されました。");
            [self alertAccountProblem:error];
        } else {
            NSArray *twitterAccounts = [store accountsWithAccountType:twitterAccountType];
            if ([twitterAccounts count] > 0) {
                ACAccount *account = [twitterAccounts firstObject]; // 最初のAccountを使う
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                [params setObject:@"1" forKey:@"include_entities"];
                NSURL *url = [NSURL URLWithString:apiURL];
                SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                        requestMethod:SLRequestMethodGET
                                                                  URL:url
                                                           parameters:params];
                [request setAccount:account];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if (!responseData) {
                        NSLog(@"response error: %@", error);
                    } else {
                        NSError *jsonError;
                        tweets = [NSJSONSerialization JSONObjectWithData:responseData
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:&jsonError];
                        [self refreshTableOnFront];
                    }
                }];
            } else
                [self alertAccountProblem:error];
        }
    }];
}

- (void)alertAccountProblem:(NSError*)error {
    NSLog(@"Error = %@, %@", error, [error userInfo]);
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Account"
                                                        message:@"アカウントに問題があります。今すぐ「設定」でアカウント情報を確認してください"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"はい", nil];
        [alert show];
    });
}

- (void)refreshTableOnFront {
    [self performSelectorOnMainThread:@selector(refreshTable)
                           withObject:self
                        waitUntilDone:TRUE];
}

- (void)refreshTable {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [table reloadData];
}

- (IBAction)sendEasyTweet:(id)sender {
    SLComposeViewController *tweetViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetViewController setCompletionHandler:^(SLComposeViewControllerResult result) {
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                NSLog(@"Cancel");
                break;
            case SLComposeViewControllerResultDone:
                NSLog(@"Done");
            default:
                break;
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:tweetViewController animated:YES completion:nil];
}

- (IBAction)refreshTimeline:(id)sender {
    [self getTimeline];
}

@end
