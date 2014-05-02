//
//  ListTableViewController.h
//  Para2Camera
//
//  Created by レー フックダイ on 5/2/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kParaParaCount 10

@interface ListTableViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    // カメラ起動の元になったセルの番号
    NSInteger idxRow;
    
}

+ (NSString*)makePhotoPathWithIndex:(NSInteger)idx;

@end
