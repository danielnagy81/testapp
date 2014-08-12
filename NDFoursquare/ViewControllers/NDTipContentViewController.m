//
//  NDTipContentViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDTipContentViewController.h"

@interface NDTipContentViewController () {
    
    __weak IBOutlet NSLayoutConstraint *_contentViewHeightConstraint;
    __weak IBOutlet UITextView *_authorTextView;
    __weak IBOutlet UITextView *_tipContentTextView;
    NSString *_tipContent;
    NSString *_tipAuthor;
}

@end

@implementation NDTipContentViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _tipAuthor = [[NSString alloc] init];
        _tipContent = [[NSString alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _tipContentTextView.text = [NSString stringWithFormat:@"„%@”", _tipContent];
    CGSize correctContentViewSize = [_tipContentTextView sizeThatFits:_tipContentTextView.frame.size];
    _contentViewHeightConstraint.constant = correctContentViewSize.height;
    _authorTextView.text = [NSString stringWithFormat:@"- %@", _tipAuthor];
}

- (void)tipContentWithText:(NSString *)text tipAuthorWithText:(NSString *)author {
    
    _tipAuthor = author;
    _tipContent = text;
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
