//
//  ListTableViewController.m
//  Para2Camera
//
//  Created by レー フックダイ on 5/2/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "ListTableViewController.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [self.tableView setRowHeight:57.0f];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


+ (NSString*)makePhotoPathWithIndex:(NSInteger)idx {
    NSString *docFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *photoFilePath = [NSString stringWithFormat:@"%@/photo-%04d.jpg", docFolder, idx];
    return photoFilePath;
}

- (NSString*)makeIconPathWithIndex:(NSInteger)idx {
    NSString *docFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *iconFilePath = [NSString stringWithFormat:@"%@/icon-%04d.jpg", docFolder, idx];
    return iconFilePath;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kParaParaCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%d 番目", (int)indexPath.row];
    
    // set icon as "no_image.png"
    UIImage *iconImage = [UIImage imageNamed:@"no_image.png"];
    NSString *iconFilePath = [self makeIconPathWithIndex:indexPath.row];
    if ([[NSFileManager defaultManager] fileExistsAtPath:iconFilePath] == YES) {
        iconImage = [UIImage imageWithContentsOfFile:iconFilePath];
    }
    cell.imageView.image = iconImage;
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *photoFilePath = [ListTableViewController makePhotoPathWithIndex:indexPath.row];
    return ([[NSFileManager defaultManager] fileExistsAtPath:photoFilePath] == YES) ? YES : NO;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString *photoFilePath = [ListTableViewController makePhotoPathWithIndex:indexPath.row];
        NSError *error = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:photoFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:photoFilePath error:&error];
            if (error != nil) {
                NSLog(@"Photo deleting error %@", [error localizedDescription]);
                return;
            }
        }
        
        NSString *iconFilePath = [self makeIconPathWithIndex:indexPath.row];
        if ([[NSFileManager defaultManager] fileExistsAtPath:iconFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:iconFilePath error:&error];
            if (error != nil) {
                NSLog(@"Icon deleting error %@", [error localizedDescription]);
                return;
            }
        }
        
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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
*/

#pragma mark - Table View delegate

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    idxRow = indexPath.row;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIImagePicker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Save image to file
    UIImage *aImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *photoFilePath = [ListTableViewController makePhotoPathWithIndex:idxRow];
    [UIImageJPEGRepresentation(aImage, 0.7f) writeToFile:photoFilePath atomically:YES];
    
    // Create icon
    NSString *iconFilePath = [self makeIconPathWithIndex:idxRow];       // get icon file path
    CGSize size = CGSizeMake(57.0f, 57.0f);                             // define icon size
    UIGraphicsBeginImageContext(size);
    [aImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage *imgIcon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [UIImagePNGRepresentation(imgIcon) writeToFile:iconFilePath atomically:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
















@end
