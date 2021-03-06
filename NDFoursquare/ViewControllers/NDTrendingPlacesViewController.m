//
//  NDTrendingPlacesViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 08/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDTrendingPlacesViewController.h"
#import "NDAugmentedRealityViewController.h"
#import "NDLocationService.h"
#import "NDTrendingPlace.h"
#import <MapKit/MapKit.h>

NSString *const TrendingPlaceTableViewCellIdentifier = @"TrendingPlaceCellIdentifier";
NSString *const AugmentedRealityViewControllerIdentifier = @"AugmentedRealityViewController";
CGFloat const TrendingPlaceSearchBarOpenStateWidth = 320.0f;
CGFloat const TrendingPlaceSearchBarClosedStateWidth = 258.0f;
double const CoordinateSpanMultiplier = 1.25;
CGFloat const TrendingPlacesLoadingIndicatorWidthAndHeight = 20.0f;

@interface NDTrendingPlacesViewController () {
    
    BOOL _locationServiceIsWorking;
    __weak IBOutlet UIButton *_nearbyButton;
    __weak IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet NSLayoutConstraint *_searchBarWidthConstraint;
    __weak IBOutlet UIActivityIndicatorView *_loadingIndicator;
    __weak IBOutlet MKMapView *_trendingPlacesMapView;
    
    NDGeocoder *_geocoder;
    NDLocationService *_locationService;
    NSMutableArray *_trendingPlaces;
    NSMutableArray *_geocodedLocations;
    CLLocationCoordinate2D _lastLocationCoorindate;
    
    __weak IBOutlet NSLayoutConstraint *_loadingIndicatorTopSpaceConstraint;
    __weak IBOutlet NSLayoutConstraint *_loadingIndicatorLeadingSpaceConstraint;
}

@end

@implementation NDTrendingPlacesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _geocoder = [[NDGeocoder alloc] init];
    _geocoder.delegate = self;
    _trendingPlaces = [[NSMutableArray alloc] init];
    _locationService = [NDLocationService sharedInstance];
    _geocodedLocations = [[NSMutableArray alloc] init];
    
    _loadingIndicatorLeadingSpaceConstraint.constant = self.view.frame.size.width / 2.0f - TrendingPlacesLoadingIndicatorWidthAndHeight / 2.0f;
    _loadingIndicatorTopSpaceConstraint.constant = self.view.frame.size.height / 2.0f - TrendingPlacesLoadingIndicatorWidthAndHeight / 2.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [_locationService setDelegate:self];
}

- (IBAction)augmentedRealityButtonPressed:(id)sender {
    
    if (_trendingPlaces.count > 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NDAugmentedRealityViewController *arViewController = [storyboard instantiateViewControllerWithIdentifier:AugmentedRealityViewControllerIdentifier];
        arViewController.locations = [_trendingPlaces copy];
        [self presentViewController:arViewController animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There are no locations to show in the camera." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)nearbyButtonPressed:(id)sender {
    
    NSError *locationServiceError = [_locationService currentLocationWithErrorHandler:^(NSError *error) {
        if (error) {
            if (_locationServiceIsWorking) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alert show];
                [_loadingIndicator stopAnimating];
                _locationServiceIsWorking = NO;
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            }
        }
    }];
    if (locationServiceError) {
        if (locationServiceError.code == 998) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[locationServiceError.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
            [_loadingIndicator stopAnimating];
            _locationServiceIsWorking = NO;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
    else {
        [self.view bringSubviewToFront:_loadingIndicator];
        [_loadingIndicator startAnimating];
        _locationServiceIsWorking = YES;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)geocoder:(NDGeocoder *)geocoder didFinishGeocodingWithLocationArray:(NSArray *)locationArray withError:(NSError *)error {
    
    if (error.code == 1009) {
        NSLog(@"%@", error);
    }
    else {
        if (_geocodedLocations.count > 0) {
            [_geocodedLocations removeAllObjects];
        }
        [_geocodedLocations addObjectsFromArray:locationArray];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (![searchText isEqualToString:@""]) {
        NSError *geocoderError = [_geocoder convertLocationStringWithAddress:searchText];
        if (geocoderError) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[geocoderError.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.2f animations:^{
        _nearbyButton.alpha = .0f;
        _searchBarWidthConstraint.constant = TrendingPlaceSearchBarOpenStateWidth + (self.view.frame.size.width - TrendingPlaceSearchBarOpenStateWidth);
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
    NSMutableString *titleString = [[NSMutableString alloc] init];
    NSDictionary *addressDictionary = [[_geocodedLocations objectAtIndex:indexPath.row] addressDictionary];
    
    if ([addressDictionary objectForKey:@"ZIP"]) {
        [titleString appendString:[NSString stringWithFormat:@"%@, ", [addressDictionary objectForKey:@"ZIP"]]];
    }
    if ([addressDictionary objectForKey:@"State"]) {
        [titleString appendString:[addressDictionary objectForKey:@"State"]];
    }
    if ([addressDictionary objectForKey:@"Street"]) {
        [titleString appendString:[NSString stringWithFormat:@", %@", [addressDictionary objectForKey:@"Street"]]];
    }
    cell.textLabel.text = titleString;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CLPlacemark *selectedPlacemark = [_geocodedLocations objectAtIndex:indexPath.row];
    NSString *locationString = [NSString stringWithFormat:@"%f,%f", selectedPlacemark.location.coordinate.latitude, selectedPlacemark.location.coordinate.longitude];
    [self startAPIServiceWithLocationString:locationString];
    [_loadingIndicator startAnimating];
    [self.view bringSubviewToFront:_loadingIndicator];
    [self.searchDisplayController setActive:NO animated:YES];
    UITableViewCell *cell = [self.searchDisplayController.searchResultsTableView cellForRowAtIndexPath:indexPath];
    self.searchDisplayController.searchBar.text = cell.textLabel.text;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _geocodedLocations.count;
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
    _locationServiceIsWorking = NO;
}

- (void)startAPIServiceWithLocationString:(NSString *)locationString {
    
    NDAPIService *apiService = [[NDAPIService alloc] initWithServiceType:NDServiceTypeVenuesTrending withOptionalParameter:locationString];
    [apiService processRequestWithCompletion:^(id result) {
        if ([result isKindOfClass:[NSArray class]]) {
            [_trendingPlaces removeAllObjects];
            [_trendingPlaces addObjectsFromArray:result];
            NSArray *annotationsToRemove = [NSArray arrayWithArray:_trendingPlacesMapView.annotations];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (annotationsToRemove.count > 0) {
                    [_trendingPlacesMapView removeAnnotations:annotationsToRemove];
                }
                [_loadingIndicator stopAnimating];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                [self addTrendingPlacesToMap];
                [self zoomToTrendingPlaces];
            });
        }
        else {
            NSLog(@"Error: the result is not an array in %s.", __PRETTY_FUNCTION__);
        }
        
    } withFailureHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
            [_loadingIndicator stopAnimating];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
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
    if (!(_lastLocationCoorindate.latitude == 0.0 && _lastLocationCoorindate.longitude == 0.0)) {
        NDTrendingPlace *tempTrendingPlaceForCurrentLocation = [[NDTrendingPlace alloc] init];
        tempTrendingPlaceForCurrentLocation.coordinate = _lastLocationCoorindate;
        [arrayToIterateOn addObject:tempTrendingPlaceForCurrentLocation];
        
    }
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
    
    MKCoordinateSpan centerSpan = MKCoordinateSpanMake((upperRightCorner.latitude - lowerLeftCorner.latitude) * CoordinateSpanMultiplier, (upperRightCorner.longitude - lowerLeftCorner.longitude) * CoordinateSpanMultiplier);
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake((upperRightCorner.latitude + lowerLeftCorner.latitude) / 2.0, (upperRightCorner.longitude + lowerLeftCorner.longitude) / 2.0);
    [_trendingPlacesMapView setRegion:MKCoordinateRegionMake(centerCoordinate, centerSpan) animated:YES];
    _lastLocationCoorindate = CLLocationCoordinate2DMake(0.0, 0.0);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        if (_searchBarWidthConstraint.constant > TrendingPlaceSearchBarOpenStateWidth) {
            _searchBarWidthConstraint.constant = TrendingPlaceSearchBarOpenStateWidth;
        }
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    _loadingIndicatorLeadingSpaceConstraint.constant = self.view.frame.size.width / 2.0f - TrendingPlacesLoadingIndicatorWidthAndHeight / 2.0f;
    _loadingIndicatorTopSpaceConstraint.constant = self.view.frame.size.height / 2.0f - TrendingPlacesLoadingIndicatorWidthAndHeight / 2.0f;
}

@end
