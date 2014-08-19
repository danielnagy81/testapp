//
//  NDTipContentViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 07/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDTipContentViewController.h"
#import <MapKit/MapKit.h>

@interface NDTipContentViewController () {
    
    __weak IBOutlet NSLayoutConstraint *_contentViewHeightConstraint;
    __weak IBOutlet NSLayoutConstraint *_authorViewHeightConstraint;
    __weak IBOutlet UITextView *_authorTextView;
    __weak IBOutlet UITextView *_tipContentTextView;
    __weak IBOutlet UIButton *_showMapButton;
    __weak IBOutlet MKMapView *_tipLocationMapView;
}

@end

@implementation NDTipContentViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _tip = [[NDTip alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self zoomToLocation];
    _tipLocationMapView.hidden = YES;
    _tipContentTextView.text = [NSString stringWithFormat:@"„%@”", self.tip.tipContent];
    CGSize correctContentViewSize = [_tipContentTextView sizeThatFits:_tipContentTextView.frame.size];
    _contentViewHeightConstraint.constant = correctContentViewSize.height;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy.MM.dd.";
    
    _authorTextView.text = [NSString stringWithFormat:@"%@ - %@", [dateFormatter stringFromDate:self.tip.timeStamp], self.tip.tipAuthor];
    CGSize correctAuthorViewSize = [_authorTextView sizeThatFits:_authorTextView.frame.size];
    _authorViewHeightConstraint.constant = correctAuthorViewSize.height;
}

- (IBAction)showMapButtonPressed:(id)sender {
    
    [self markLocation];
    CGFloat halfAnimationTime = .2f;
    
    _tipLocationMapView.layer.borderWidth = 5.0f;
    _tipLocationMapView.layer.borderColor = [UIColor blackColor].CGColor;
    
    CATransform3D viewToShowStartingTransformation = CATransform3DMakeRotation(3.0f * M_PI / 2.0f, .0f, 1.0f, .0f);
    CATransform3D viewToHideEndingTransformation = CATransform3DMakeRotation(M_PI / 2.0f, .0f, 1.0f, .0f);
    CATransform3D viewToShowEndingTransformation = CATransform3DIdentity;
    
    _tipLocationMapView.layer.transform = viewToShowStartingTransformation;
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:halfAnimationTime animations:^{
        _showMapButton.layer.transform = viewToHideEndingTransformation;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        _showMapButton.hidden = YES;
        _tipLocationMapView.hidden = NO;
        [UIView animateWithDuration:halfAnimationTime animations:^{
            _tipLocationMapView.layer.transform = viewToShowEndingTransformation;
        }];
    }];
}

- (void)markLocation {

    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = self.tipCoordinate;
    pointAnnotation.title = self.tipAddress;
    [_tipLocationMapView addAnnotation:pointAnnotation];
}

- (void)zoomToLocation {
    
    MKCoordinateRegion regionToZoom = MKCoordinateRegionMake(self.tipCoordinate, MKCoordinateSpanMake(0.001f, 0.001f));
    [_tipLocationMapView setRegion:regionToZoom animated:NO];
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
