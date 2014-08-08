//
//  NDTrendingPlacesViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 08/08/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDTrendingPlacesViewController.h"

NSString *const TrendingPlaceTableViewCellIdentifier = @"TrendingPlaceCellIdentifier";
CGFloat const TrendingPlaceSearchBarOpenStateWidth = 320.0f;
CGFloat const TrendingPlaceSearchBarClosedStateWidth = 258.0f;

@interface NDTrendingPlacesViewController () {
    
    IBOutlet UIButton *_nearbyButton;
    IBOutlet UISearchBar *_searchBar;
    __weak IBOutlet NSLayoutConstraint *_searchBarWidthConstraint;
}

@end

@implementation NDTrendingPlacesViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
