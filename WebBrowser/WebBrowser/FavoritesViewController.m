//
//  FavoritesViewController.m
//  WebBrowser
//
//  Created by レー フックダイ on 4/27/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController {
    NSMutableArray *favoriteList;
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
    
    favoriteList = [[NSMutableArray alloc] init];
    [self queryDB];
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

- (void)queryDB {
    // CoreDataの呼び出し準備をする
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.managedObjectContext;
    
    // Databaseの参照結果を保持するためのobjectを生成
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Entity(database中のtable)の名前を指定する
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyFavorites"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // titleの内容（昇順）で参照結果を並び替える保持する様に指定する
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Data参照を実施するためのNSFetchedResultsControllerを生成し、fetchRequestを指定する
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:context
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];
    // Data参照を行う。Databaseへのaccessに失敗した際にerrorを返す
    NSError *error = nil;
    if (![fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    // 参照結果をfavoriteListに格納する
    NSArray *moArray = [fetchedResultsController fetchedObjects];
    for (NSManagedObject *object in moArray) {
        Favorites *favorites = [[Favorites alloc] init];
        favorites.title = [object valueForKey:@"title"];
        favorites.url = [object valueForKey:@"url"];
        [favoriteList addObject:favorites];
    }

}

- (IBAction)back:(id)sender {
    [self.delegate favoritesViewControllerDidCancel:self];
}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [favoriteList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cells";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Favorites *favorites = [favoriteList objectAtIndex:indexPath.row];
    cell.textLabel.text = favorites.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Favorites *favorites = [favoriteList objectAtIndex:indexPath.row];
    NSString *selectedURL = favorites.url;
    
    [self.delegate favoritesViewControllerDidSelect:self withUrl:selectedURL];
}













@end
