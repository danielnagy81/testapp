//
//  NDViewController.m
//  NDFoursquare
//
//  Created by Daniel_Nagy on 31/07/14.
//  Copyright (c) 2014 NDani. All rights reserved.
//

#import "NDLeaderboardViewController.h"
#import "NDAPIService.h"
#import "NDLeaderboardEntry.h"
#import "NDAuthenticationService.h"
NSString *const TableViewCellIdentifier = @"LeaderboardCellIdentifier";

@interface NDLeaderboardViewController () {
    
    NSMutableArray *_leaderboard;
    NDAPIService *_apiService;
    __weak IBOutlet UIActivityIndicatorView *_loadingIndicator;
}

@end

@implementation NDLeaderboardViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupRefreshControl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticationServiceDidFinishedAuthenticationWitNotification:) name:AuthenticationDidFinishedNotificationName object:nil];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    _leaderboard = [[NSMutableArray alloc] init];
    _apiService = [[NDAPIService alloc] initWithServiceType:NDServiceTypeUsersLeaderboard withOptionalParameter:nil];
    [self startAPIService];
}

- (void)setupRefreshControl {
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshControlDragged) forControlEvents:UIControlEventValueChanged];
}

- (void)refreshControlDragged {
    
    [self startAPIService];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _leaderboard.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NDLeaderboardEntry *leaderboardEntry = [_leaderboard objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", leaderboardEntry.userName, leaderboardEntry.userScore];
    return cell;
}

- (void)startAPIService {
    
    if (![self.refreshControl isRefreshing]) {
        [_loadingIndicator startAnimating];
    }
    [_apiService processRequestWithCompletion:^(id result) {
        
        if ([result isKindOfClass:[NSArray class]]) {
            _leaderboard = [NSMutableArray arrayWithArray:result];
            if (_leaderboard.count > 0) {
                [[NSNotificationCenter defaultCenter] removeObserver:self];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                if ([self.refreshControl isRefreshing]) {
                    [self.refreshControl endRefreshing];
                }
                else {
                    [_loadingIndicator stopAnimating];
                }
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.refreshControl isRefreshing]) {
                    [self.refreshControl endRefreshing];
                }
                else {
                    [_loadingIndicator stopAnimating];
                }
            });
            NSLog(@"Error: the returned object wasn't an array in %s.", __PRETTY_FUNCTION__);
        }
    } withFailureHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
            else {
                [_loadingIndicator stopAnimating];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        });
    }];
}

- (void)authenticationServiceDidFinishedAuthenticationWitNotification:(NSNotification *)notification {
    
    if (notification.userInfo) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[notification.userInfo objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        if (_leaderboard.count == 0) {
            [self startAPIService];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"The authentication process was successful!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_loadingIndicator stopAnimating];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
