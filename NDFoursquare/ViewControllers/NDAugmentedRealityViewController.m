//
//  NDAugmentedRealityViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 18/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDAugmentedRealityViewController.h"
#import "NDLocationService.h"
#import "NDTrendingPlace.h"

@interface NDAugmentedRealityViewController () {
    
    NDLocationService *_locationService;
    IBOutlet UIButton *_backButton;
}

@end

@implementation NDAugmentedRealityViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _locations = [[NSMutableArray alloc] init];
        _locationService = [NDLocationService sharedInstance];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [_locationService setDelegate:self];
    [_locationService currentLocationWithErrorHandler:^(NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }];
    [PRARManager sharedManagerWithRadarAndSize:self.view.frame.size andDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (!self.view.superview) {
        self.tabBarController.selectedViewController = nil;
        self.tabBarController.selectedViewController = self;
    }
}

- (void)prarDidSetupAR:(UIView *)arView withCameraLayer:(AVCaptureVideoPreviewLayer *)cameraLayer andRadarView:(UIView *)radar {
    
    [self.view.layer addSublayer:cameraLayer];
    [self.view addSubview:arView];
    
    [self.view bringSubviewToFront:[self.view viewWithTag:AR_VIEW_TAG]];
    [self.view bringSubviewToFront:_backButton];
    [self.view addSubview:radar];
}

- (void)prarGotProblem:(NSString *)problemTitle withDetails:(NSString *)problemDetails {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:problemTitle message:problemDetails delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)prarUpdateFrame:(CGRect)arViewFrame {
    
    [[self.view viewWithTag:AR_VIEW_TAG] setFrame:arViewFrame];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    [_locationService stopMonitoring];
    CLLocationCoordinate2D lastLocation = [[locations lastObject] coordinate];
    NSMutableArray *arObjects = [[NSMutableArray alloc] initWithCapacity:_locations.count];
    
    int i = 0;
    for (NDTrendingPlace *trendingPlace in _locations) {
        NSDictionary *arObject = @{@"id": [NSNumber numberWithInt:i], @"title": trendingPlace.name, @"lat": [NSNumber numberWithDouble:trendingPlace.coordinate.latitude], @"lon": [NSNumber numberWithDouble:trendingPlace.coordinate.longitude]};
        ++i;
        [arObjects addObject:arObject];
    }
    [[PRARManager sharedManager] startARWithData:arObjects forLocation:lastLocation];
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
