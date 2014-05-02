//
//  AnimViewController.m
//  Para2Camera
//
//  Created by レー フックダイ on 5/2/14.
//  Copyright (c) 2014 lephuocdai. All rights reserved.
//

#import "AnimViewController.h"
#import "ListTableViewController.h"

@interface AnimViewController ()

@end

@implementation AnimViewController

//@synthesize aImageView = _aImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setImages];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_aImageView stopAnimating];
}

- (IBAction)sliderValueChanged:(id)sender {
    BOOL isAnimating = [_aImageView isAnimating];
    _aImageView.animationDuration = _aSlider.value;
    if (isAnimating == NO) {
        [_aImageView startAnimating];
    }
}

- (void)setImages {
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i < kParaParaCount; i++) {
        NSString *photoFilePath = [ListTableViewController makePhotoPathWithIndex:i];
        if ([[NSFileManager defaultManager] fileExistsAtPath:photoFilePath] == YES) {
            UIImage *image = [UIImage imageWithContentsOfFile:photoFilePath];
            [imageArray addObject:image];
            if (_aImageView.image == nil) {
                _aImageView.image = image;
            }
        }
    }
    _aImageView.animationImages = imageArray;
    _aImageView.animationDuration = _aSlider.value;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint position = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(_aImageView.frame, position)) {
        if (_aImageView.isAnimating)
            [_aImageView stopAnimating];
        else
            [_aImageView startAnimating];
    }
}





@end




















