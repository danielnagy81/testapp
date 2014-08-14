//
//  NDTrendingPlacesViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 08/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDTrendingPlacesViewController.h"
#import "NDLocationService.h"
#import "NDAPIService.h"
#import "NDTrendingPlace.h"
#import <MapKit/MapKit.h>

NSString *const TrendingPlaceTableViewCellIdentifier = @"TrendingPlaceCellIdentifier";
CGFloat const TrendingPlaceSearchBarOpenStateWidth = 320.0f;
CGFloat const TrendingPlaceSearchBarClosedStateWidth = 258.0f;

@interface NDTrendingPlacesViewController () {
    
    __weak IBOutlet UIButton *_nearbyButton;
    __weak IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet NSLayoutConstraint *_searchBarWidthConstraint;
    __weak IBOutlet UIActivityIndicatorView *_loadingIndicator;
    __weak IBOutlet MKMapView *_trendingPlacesMapView;
    
    NDLocationService *_locationService;
    NSMutableArray *_trendingPlaces;
    CLLocationCoordinate2D _lastLocationCoorindate;
}

@end

@implementation NDTrendingPlacesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _trendingPlaces = [[NSMutableArray alloc] init];
    _locationService = [NDLocationService locationService];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [_locationService setDelegate:self];
}

- (IBAction)nearbyButtonPressed:(id)sender {
    
    [_loadingIndicator startAnimating];
    [self.view bringSubviewToFront:_loadingIndicator];
    NSError *locationServiceError = [_locationService currentLocation];
    
    if (locationServiceError) {
        if (locationServiceError.code == 998) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[locationServiceError.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
        [_loadingIndicator stopAnimating];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.2f animations:^{
        _nearbyButton.alpha = .0f;
        _searchBarWidthConstraint.constant = TrendingPlaceSearchBarOpenStateWidth;
        [self.view layoutIfNeeded];
    }];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.2f animations:^{
        _nearbyButton.alpha = 1.0f;
        _searchBarWidthConstraint.constant = TrendingPlaceSearchBarClosedStateWidth;
        [self.view layoutIfNeeded];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TrendingPlaceTableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TrendingPlaceTableViewCellIdentifier];
    }
    cell.textLabel.text = @"Test title";
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if (locations.count > 0) {
        CLLocation *lastLocation = [locations lastObject];
        _lastLocationCoorindate = lastLocation.coordinate;
        NSString *locationString = [NSString stringWithFormat:@"%f,%f", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude];
        [self startAPIServiceWithLocationString:locationString];
    }
    else {
        NSLog(@"Error: The location array was empty in %s", __PRETTY_FUNCTION__);
        [_loadingIndicator stopAnimating];
    }
    [_locationService stopMonitoring];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)startAPIServiceWithLocationString:(NSString *)locationString {
    
    NDAPIService *apiService = [[NDAPIService alloc] initWithServiceType:NDServiceTypeVenuesTrending withOptionalParameter:locationString];
    [apiService processURLWithCompletion:^(id result, NSError *error) {
        [_trendingPlaces removeAllObjects];
        if (!error) {
            if ([[result firstObject] isKindOfClass:[NDTrendingPlace class]]) {
                [_trendingPlaces addObjectsFromArray:result];
                NSArray *annotationsToRemove = [NSArray arrayWithArray:_trendingPlacesMapView.annotations];
                if (annotationsToRemove.count > 0) {
                    [_trendingPlacesMapView removeAnnotations:annotationsToRemove];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_loadingIndicator stopAnimating];
                    [self addTrendingPlacesToMap];
                    [self zoomToTrendingPlaces];
                });
            }
            else {
                NSLog(@"Error: the returned array not contains NDTrendingPlaces in %s.", __PRETTY_FUNCTION__);
            }
        }
        else {
            NSLog(@"%@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [_loadingIndicator stopAnimating];
            });
        }
    }];
}

- (void)addTrendingPlacesToMap {
    
    for (NDTrendingPlace *trendingPlace in _trendingPlaces) {
        MKPointAnnotation *trendingPlaceAnnotation = [[MKPointAnnotation alloc] init];
        trendingPlaceAnnotation.title = trendingPlace.name;
        trendingPlaceAnnotation.coordinate = trendingPlace.coordinate;
        [_trendingPlacesMapView addAnnotation:trendingPlaceAnnotation];
    }
}

- (void)zoomToTrendingPlaces {
    
    NSMutableArray *arrayToIterateOn = [[NSMutableArray alloc] initWithArray:_trendingPlaces];
    NDTrendingPlace *tempTrendingPlaceForCurrentLocation = [[NDTrendingPlace alloc] init];
    tempTrendingPlaceForCurrentLocation.coordinate = _lastLocationCoorindate;
    [arrayToIterateOn addObject:tempTrendingPlaceForCurrentLocation];
    NDTrendingPlace *firstTrendingPlace = [arrayToIterateOn firstObject];
    
    CLLocationCoordinate2D lowerLeftCorner = firstTrendingPlace.coordinate;
    CLLocationCoordinate2D upperRightCorner = firstTrendingPlace.coordinate;
    
    for (int i = 1; i < arrayToIterateOn.count; ++i) {
        NDTrendingPlace *currentTrendingPlace = [arrayToIterateOn objectAtIndex:i];
        
        if (currentTrendingPlace.coordinate.latitude < lowerLeftCorner.latitude) {
            lowerLeftCorner.latitude = currentTrendingPlace.coordinate.latitude;
        }
        if (currentTrendingPlace.coordinate.longitude < lowerLeftCorner.longitude) {
            lowerLeftCorner.longitude = currentTrendingPlace.coordinate.longitude;
        }
        if (currentTrendingPlace.coordinate.latitude > upperRightCorner.latitude) {
            upperRightCorner.latitude = currentTrendingPlace.coordinate.latitude;
        }
        if (currentTrendingPlace.coordinate.longitude > upperRightCorner.longitude) {
            upperRightCorner.longitude = currentTrendingPlace.coordinate.longitude;
        }
    }
    
    MKCoordinateSpan centerSpan = MKCoordinateSpanMake((upperRightCorner.latitude - lowerLeftCorner.latitude) * 1.1, (upperRightCorner.longitude - lowerLeftCorner.longitude) * 1.1);
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake((upperRightCorner.latitude + lowerLeftCorner.latitude) / 2.0, (upperRightCorner.longitude + lowerLeftCorner.longitude) / 2.0);
    [_trendingPlacesMapView setRegion:MKCoordinateRegionMake(centerCoordinate, centerSpan) animated:YES];
}

@end
