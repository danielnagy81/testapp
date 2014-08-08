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

NSString *const TipTableViewCellIdentifier = @"TipCellIdentifier";
NSString *const TipSearcResultTableViewCellIdentifier = @"SearchResultTableViewCellIdentifier";
NSString *const TipContentViewControllerIdentifier = @"TipContentViewController";
CGFloat const TipsSearchBarOpenStateWidth = 320.0f;
CGFloat const TipsSearchBarClosedStateWidth = 258.0f;

@interface NDTipsViewController () {
    
    NSMutableArray *_geocodedLocations;
    NDLocationService *_locationService;
    __weak IBOutlet UIButton *_nearbyButton;
    IBOutlet UITableView *_tableView;
    IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet UIActivityIndicatorView *_loadingIndicator;
    NSMutableArray *_tips;
    NDGeocoder *_geocoder;
    __weak IBOutlet NSLayoutConstraint *_searchBarWidthConstraint;
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
    _locationService = [NDLocationService locationService];
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
        cell.textLabel.text = [placeTips.tips objectAtIndex:indexPath.row];
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
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
        NSString *contentOfCell = cell.textLabel.text;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NDTipContentViewController *tipContentViewController = [storyboard instantiateViewControllerWithIdentifier:TipContentViewControllerIdentifier];
        [tipContentViewController tipContentWithText:contentOfCell];
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
        _searchBarWidthConstraint.constant = TipsSearchBarOpenStateWidth;
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
        [_geocoder convertLocationStringWithAddress:searchText];
    }
}

- (void)geocoder:(NDGeocoder *)geocoder didFinishGeocodingWithLocationArray:(NSArray *)locationArray withError:(NSError *)error {
    
    if (error) {
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
    
    [_locationService currentLocation];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if (locations.count > 0) {
        CLLocation *lastLocation = locations.lastObject;
        NSString *locationString = [NSString stringWithFormat:@"%f,%f", lastLocation.coordinate.latitude, lastLocation.coordinate.longitude];
        [self startAPIServiceWithLocationString:locationString];
        [_locationService stopMonitoring];
    }
    else {
        NSLog(@"Error: The location array was empty in %s", __PRETTY_FUNCTION__);
    }
}

- (void)startAPIServiceWithLocationString:(NSString *)locationString {
    
    NDAPIService *apiService = [[NDAPIService alloc] initWithServiceType:NDServiceTypeTipsSearch withOptionalParameter:locationString];
    [apiService processURLWithCompletion:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tips removeAllObjects];
            if (error) {
                NSLog(@"%@ in %s", error, __PRETTY_FUNCTION__);
                NDVenueTips *errorVenue = [[NDVenueTips alloc] init];
                errorVenue.venueName = @"I can't find any venue here :(";
                [_tips addObject:errorVenue ];
            }
            else {
                if ([result isKindOfClass:[NSArray class]]) {
                    [_tips removeAllObjects];
                    [_tips addObjectsFromArray:result];
                }
                else {
                    NSLog(@"Error: the returned object wasn't an array in %s.", __PRETTY_FUNCTION__);
                }
            }
            [_tableView reloadData];
            [_loadingIndicator stopAnimating];
        });
    }];
}

@end
