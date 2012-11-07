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
#pragma mark - Class implementation
////////////////////////////////////////////////////////////////////////////////
@implementation NUITableViewController

#pragma mark Initializing

- (id)init
{
    return [self initWithStyle:UITableViewStylePlain refreshControlStyle:NUIRefreshControlStyleDefault];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _clearsSelectionOnViewWillAppear = YES;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self initWithStyle:style refreshControlStyle:NUIRefreshControlStyleDefault];
}

- (id)initWithStyle:(UITableViewStyle)style refreshControlStyle:(NUIRefreshControlStyle)refreshControlStyle
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _tableView = [[NUITableView alloc] initWithFrame:CGRectZero style:style refreshControlStyle:refreshControlStyle];
    }
    return self;
}

#pragma mark View lifecycle

- (void)loadView
{
    if (self.nibName) {
        // although documentation states that custom implementation of this method
        // should not call super, it is easier than loading nib on my own, because
        // I'm too lazy! ;-)
        [super loadView];

        self.tableView = (NUITableView *)self.view;
    }
    else {
        self.view = self.tableView;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.tableView.delegate == nil) {
        self.tableView.delegate = self;
    }

    if (self.tableView.dataSource == nil) {
        self.tableView.dataSource = self;
    }

    // trigger the refresh at the end of viewDidLoad
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

- (void)viewDidUnload
{
    [self setTableView:nil];

    [super viewDidUnload];
}

@end
