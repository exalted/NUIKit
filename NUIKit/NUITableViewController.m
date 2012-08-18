//
// Copyright (C) 2012 Ali Servet Donmez. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "NUITableViewController.h"

////////////////////////////////////////////////////////////////////////////////
// Internal methods
////////////////////////////////////////////////////////////////////////////////
@interface NUITableViewController (Internal) <UISearchDisplayDelegate, UISearchBarDelegate>

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl;

@end

////////////////////////////////////////////////////////////////////////////////
// Private APIs
////////////////////////////////////////////////////////////////////////////////
@interface NUITableViewController () {
    ODRefreshControl *_refreshControl;
}

@property (strong, nonatomic) UISearchDisplayController *searchDisplayController;

@end

////////////////////////////////////////////////////////////////////////////////
// Class implementation
////////////////////////////////////////////////////////////////////////////////
@implementation NUITableViewController

@synthesize tableView = _tableView;
@synthesize clearsSelectionOnViewWillAppear = _clearsSelectionOnViewWillAppear;
// internal
@synthesize searchDisplayController = _anotherSearchDisplayController;

- (id)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super init];
    if (self) {
        _tableView = [[NUITableView alloc] initWithFrame:CGRectZero style:style];
        _clearsSelectionOnViewWillAppear = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;

        // (Ref.: http://stackoverflow.com/questions/7853915/how-do-i-avoid-capturing-self-in-blocks-when-implementing-an-api/7854315#7854315)
        // Also read "Use Lifetime Qualifiers to Avoid Strong Reference Cycles" in "Transitioning to ARC Release Notes" of iOS documentation
        NUITableViewController * __block weakSelf = self;
        [_tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf dropViewDidBeginRefreshing:nil];
        }];
    }
    return self;
}

- (void)loadView
{
    self.view = self.tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.tableView.searchEnabled) {
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        searchBar.delegate = self;

        self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        self.searchDisplayController.delegate = self;
        self.searchDisplayController.searchResultsDataSource = self;
        self.searchDisplayController.searchResultsDelegate = self;

        [searchBar sizeToFit];
        self.tableView.tableHeaderView = searchBar;
    }

    if (self.tableView.pullToRefreshEnabled) {
        // Add pull-to-refresh function
        _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
        [_refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    }

    // trigger the refresh manually at the end of viewDidLoad
    [self.tableView pullFreshData];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.clearsSelectionOnViewWillAppear) {
        for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.tableView flashScrollIndicators];
}

#pragma mark - Table view delegate

- (void)willPullFreshDataForTableView:(NUITableView *)tableView
{
    /* NOOP */
}

- (BOOL)shouldReloadDataForTableView:(NUITableView *)tableView
{
    return YES;
}

- (void)didReloadDataForTableView:(NUITableView *)tableView
{
    [_refreshControl endRefreshing];
    [self.tableView.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.0];
}

@end

////////////////////////////////////////////////////////////////////////////////
// Internal methods
////////////////////////////////////////////////////////////////////////////////
@implementation NUITableViewController (Internal)

#pragma mark - Pull to refresh action

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    if (refreshControl && self.tableView.pullToRefreshEnabled) {
        [self.tableView pullFreshData];
    }
    else if (self.tableView.paginationEnabled) {
        [self.tableView pullMoreData];
    }
    else {
        return;
    }

    if ([self.tableView.delegate shouldReloadDataForTableView:self.tableView]) {
        [self.tableView reloadData];
    }
}

@end
