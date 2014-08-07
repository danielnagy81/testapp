//
//  NDTipContentViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDTipContentViewController.h"

@interface NDTipContentViewController () {
    
    __weak IBOutlet UITextView *_tipContentTextView;
    NSString *_tipContent;
}

@end

@implementation NDTipContentViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _tipContent = [[NSString alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _tipContentTextView.text = _tipContent;
}

- (void)tipContentWithText:(NSString *)text {
    
    _tipContent = text;
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
