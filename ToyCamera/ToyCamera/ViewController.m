//
//  ViewController.m
//  ToyCamera
//
//  Created by レー フックダイ on 5/2/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController {
    IBOutlet UIImageView *aImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction
- (IBAction)doFilter:(id)sender {
    DBGMSG(@"%s", __func__);
    UIActionSheet *aSheet = [[UIActionSheet alloc] initWithTitle:@"フィルタ選択"
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"セビア", @"ボタン2", @"ボタン3", nil];
    [aSheet setActionSheetStyle:UIActionSheetStyleDefault];
    [aSheet showInView:self.view];
}

- (IBAction)doCamera:(id)sender {
    DBGMSG(@"%s", __func__);
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        return;
    }
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    [ipc setSourceType:sourceType];
    [ipc setDelegate:self];
    [ipc setAllowsEditing:YES];
    [self presentViewController:ipc animated:YES completion:^{
        [UIApplication sharedApplication].statusBarHidden = YES;
    }];
}

- (IBAction)doSave:(id)sender {
    DBGMSG(@"%s", __func__);
    UIImage *aImage = [aImageView image];
    if (aImage == nil) {
        return;
    }
    UIImageWriteToSavedPhotosAlbum(aImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    DBGMSG(@"%s", __func__);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存完了"
                                                    message:@"写真アルバムに画像を保存しました。"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark UINavigationController delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    DBGMSG(@"%s", __func__);
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    DBGMSG(@"%s", __func__);
}

#pragma mark UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    DBGMSG(@"%s", __func__);
    UIImage *aImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [aImageView setImage:aImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIApplication sharedApplication].statusBarHidden = NO;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [UIApplication sharedApplication].statusBarHidden = NO;
    }];
}

#pragma UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( buttonIndex == 0 ) {
        NSLog(@"セピア");
        [self toSepia];
    }else if ( buttonIndex == 1 ) {
        NSLog(@"ボタン２");
        //ボタン３用
    }else if ( buttonIndex == 2 ) {
        NSLog(@"ボタン３");
        //キャンセル含めてそれ以外
    } else {
        NSLog(@"キャンセル含めてそれ以外");
    }
}

#pragma Filter
- (void)toSepia {
    UIImage *originalImage = [aImageView image];
    if (originalImage == nil) {
        return;
    }
    
    // Create CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:originalImage];
    // Create CIFilter
    CIFilter *ciFilter = [CIFilter filterWithName:@"CISepiaTone"
                                    keysAndValues:kCIInputImageKey, ciImage,
                          @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];  // 明るさの指定
    // Make new imageView by Sepia filter
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImageRef = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgImageRef scale:1.0 orientation:UIImageOrientationUp];
    CGImageRelease(cgImageRef);
    
    [aImageView setImage:newImage];
}


















@end
