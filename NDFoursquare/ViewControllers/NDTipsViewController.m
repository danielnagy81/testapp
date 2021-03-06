//
//  NDTipsViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 06/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDTipsViewController.h"
#import "NDTipContentViewController.h"
#import "NDGeocoder.h"
#import "NDAPIService.h"
#import "NDVenueTips.h"
#import "NDLocationService.h"
#import "NDTip.h"

NSString *const TipTableViewCellIdentifier = @"TipCellIdentifier";
NSString *const TipSearcResultTableViewCellIdentifier = @"SearchResultTableViewCellIdentifier";
NSString *const TipContentViewControllerStoryboardIdentifier = @"TipContentViewController";
CGFloat const TipsSearchBarOpenStateWidth = 320.0f;
CGFloat const TipsSearchBarClosedStateWidth = 258.0f;
CGFloat const TipsLoadingIndicatorWidthAndHeight = 20.0f;

@interface NDTipsViewController () {
    
    BOOL _locationServiceIsWorking;
    BOOL _tipProcessIsComplete;
    NSMutableArray *_geocodedLocations;
    NDLocationService *_locationService;
    __weak IBOutlet UIButton *_nearbyButton;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet UIActivityIndicatorView *_loadingIndicator;
    NSMutableArray *_tips;
    NDGeocoder *_geocoder;
    __weak IBOutlet NSLayoutConstraint *_searchBarWidthConstraint;
    __weak IBOutlet NSLayoutConstraint *_loadingIndicatorTopSpaceConstraint;
    __weak IBOutlet NSLayoutConstraint *_loadingIndicatorLeadingSpaceConstraint;
}

@end

@implementation NDTipsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _geocodedLocations = [[NSMutableArray alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TipTableViewCellIdentifier];
    _geocoder = [[NDGeocoder alloc] init];
    _geocoder.delegate = self;
    _tips = [[NSMutableArray alloc] init];
    _locationService = [NDLocationService sharedInstance];
    
    _loadingIndicatorLeadingSpaceConstraint.constant = self.view.frame.size.width / 2.0f - TipsLoadingIndicatorWidthAndHeight / 2.0f;
    _loadingIndicatorTopSpaceConstraint.constant = self.view.frame.size.height / 2.0f - TipsLoadingIndicatorWidthAndHeight / 2.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [_locationService setDelegate:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableView isEqual:_tableView]) {
        NDVenueTips *venueTips = [_tips objectAtIndex:section];
        return venueTips.tips.count;
    }
    else {
        return _geocodedLocations.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:_tableView]) {
        return _tips.count;
    }
    else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_tableView]) {
        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:TipTableViewCellIdentifier];
        NDVenueTips *placeTips = [_tips objectAtIndex:indexPath.section];
        cell.textLabel.text = [[placeTips.tips objectAtIndex:indexPath.row] tipContent];
        return cell;
    }
    else {
        UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:TipSearcResultTableViewCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TipSearcResultTableViewCellIdentifier];
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
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ([tableView isEqual:_tableView]) {
        NDVenueTips *venueTips = [_tips objectAtIndex:section];
        return venueTips.venueName;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_tableView]) {
        [self.view endEditing:YES];
        NDTip *tip = [[[_tips objectAtIndex:indexPath.section] tips] objectAtIndex:indexPath.row];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NDTipContentViewController *tipContentViewController = [storyboard instantiateViewControllerWithIdentifier:TipContentViewControllerStoryboardIdentifier];
        tipContentViewController.tip = tip;
        tipContentViewController.tipCoordinate = [[_tips objectAtIndex:indexPath.section] venueCoordinate];
        tipContentViewController.tipAddress = [[_tips objectAtIndex:indexPath.section] venueAddress];
        
        [self presentViewController:tipContentViewController animated:YES completion:nil];
    }
    else {
        CLPlacemark *selectedPlace = [_geocodedLocations objectAtIndex:indexPath.row];
        NSString *locationString = [NSString stringWithFormat:@"%f,%f", selectedPlace.location.coordinate.latitude, selectedPlace.location.coordinate.longitude];
        [self startAPIServiceWithLocationString:locationString];
        [self.searchDisplayController setActive:NO animated:YES];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        _searchBar.text = cell.textLabel.text;
        [self.view bringSubviewToFront:_loadingIndicator];
        [_loadingIndicator startAnimating];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.2f animations:^{
        _nearbyButton.alpha = .0f;
        _searchBarWidthConstraint.constant = TipsSearchBarOpenStateWidth + (self.view.frame.size.width - TipsSearchBarOpenStateWidth);
        [self.view layoutIfNeeded];
    }];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:.2f animations:^{
        _nearbyButton.alpha = 1.0f;
        _searchBarWidthConstraint.constant = TipsSearchBarClosedStateWidth;
        [self.view layoutIfNeeded];
    }];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (![searchText isEqualToString:@""]) {
        NSError *networkError = [_geocoder convertLocationStringWithAddress:searchText];
        if (networkError) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[networkError.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
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

- (IBAction)nearbyButtonPressed:(id)sender {
    
    [self.view bringSubviewToFront:_loadingIndicator];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" message:[locationServiceError.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
            [_loadingIndicator stopAnimating];
            _locationServiceIsWorking = NO;
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
    else {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        _locationServiceIsWorking = YES;
        [_loadingIndicator startAnimating];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if (locations.count > 0) {
        CLLocation *lastLocation = locations.lastObject;
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
    
    NDAPIService *apiService = [[NDAPIService alloc] initWithServiceType:NDServiceTypeTipsSearch withOptionalParameter:locationString];
    [apiService processRequestWithCompletion:^(id result) {
        
        if ([result isKindOfClass:[NSArray class]]) {
            [_tips removeAllObjects];
            [_tips addObjectsFromArray:result];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [_loadingIndicator stopAnimating];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
        }
        else {
            NSLog(@"Error: the result is not an array in %s.", __PRETTY_FUNCTION__);
        }
    } withFailureHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error.code == 999) {
                [_tips removeAllObjects];
                NDVenueTips *errorVenue = [[NDVenueTips alloc] init];
                errorVenue.venueName = @"I can't find any venue there :(";
                [_tips addObject:errorVenue ];
                [_tableView reloadData];
                [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alert show];
            }
            [_loadingIndicator stopAnimating];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    }];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        if (_searchBarWidthConstraint.constant > TipsSearchBarOpenStateWidth) {
            _searchBarWidthConstraint.constant = TipsSearchBarOpenStateWidth;
        }
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    _loadingIndicatorLeadingSpaceConstraint.constant = self.view.frame.size.width / 2.0f - TipsLoadingIndicatorWidthAndHeight / 2.0f;
    _loadingIndicatorTopSpaceConstraint.constant = self.view.frame.size.height / 2.0f - TipsLoadingIndicatorWidthAndHeight / 2.0f;
}

@end
