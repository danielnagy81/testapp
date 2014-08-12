//
//  NDTipContentViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDTipContentViewController.h"
#import "NDMapViewProvider.h"
#import <MapKit/MapKit.h>

@interface NDTipContentViewController () {
    
    __weak IBOutlet NSLayoutConstraint *_contentViewHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_authorViewHeightConstraint;
    __weak IBOutlet UITextView *_authorTextView;
    __weak IBOutlet UITextView *_tipContentTextView;
    __weak IBOutlet UIView *_placeholderForMapView;
    __weak IBOutlet UIButton *_showMapButton;
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
    CGSize correctAuthorViewSize = [_authorTextView sizeThatFits:_authorTextView.frame.size];
    _authorViewHeightConstraint.constant = correctAuthorViewSize.height;

}

- (void)tipContentWithText:(NSString *)text tipAuthorWithText:(NSString *)author {
    
    _tipAuthor = author;
    _tipContent = text;
}

- (IBAction)showMapButtonPressed:(id)sender {
    
    CGFloat halfAnimationTime = .2f;
    
    MKMapView *tipLocationMapView = [NDMapViewProvider mapView];
    tipLocationMapView.frame = _placeholderForMapView.frame;
    tipLocationMapView.hidden = YES;
    tipLocationMapView.layer.borderWidth = 5.0f;
    tipLocationMapView.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:tipLocationMapView];
    
    CATransform3D viewToShowStartingTransformation = CATransform3DMakeRotation(3.0f * M_PI / 2.0f, .0f, 1.0f, .0f);
    CATransform3D viewToHideEndingTransformation = CATransform3DMakeRotation(M_PI / 2.0f, .0f, 1.0f, .0f);
    CATransform3D viewToShowEndingTransformation = CATransform3DIdentity;
    
    tipLocationMapView.layer.transform = viewToShowStartingTransformation;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:halfAnimationTime animations:^{
        _showMapButton.layer.transform = viewToHideEndingTransformation;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _showMapButton.hidden = YES;
        tipLocationMapView.hidden = NO;
        [UIView animateWithDuration:halfAnimationTime animations:^{
            tipLocationMapView.layer.transform = viewToShowEndingTransformation;
        }];
    }];
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
