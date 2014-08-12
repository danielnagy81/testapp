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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authenticationServiceDidFinishedAuthenticationWitNotification:) name:AuthenticationDidFinishedNotificationName object:nil];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    _leaderboard = [[NSMutableArray alloc] init];
    _apiService = [[NDAPIService alloc] initWithServiceType:NDServiceTypeUsersLeaderboard withOptionalParameter:nil];
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)startAPIService {
    [_loadingIndicator startAnimating];
    [_apiService processURLWithCompletion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else {
            if ([result isKindOfClass:[NSArray class]]) {
                _leaderboard = [NSMutableArray arrayWithArray:result];
                if (_leaderboard.count > 0) {
                    [[NSNotificationCenter defaultCenter] removeObserver:self];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [_loadingIndicator stopAnimating];
                });
            }
            else {
                NSLog(@"Error: the returned object wasn't an array in %s.", __PRETTY_FUNCTION__);
            }
        }
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
