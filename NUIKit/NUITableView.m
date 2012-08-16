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

#import "NUITableView.h"

////////////////////////////////////////////////////////////////////////////////
// Class implementation
////////////////////////////////////////////////////////////////////////////////
@implementation NUITableView

@synthesize searchEnabled = _searchEnabled;
@synthesize pullToRefreshEnabled = _pullToRefreshEnabled;
@synthesize paginationEnabled = _paginationEnabled;

- (void)setPaginationEnabled:(BOOL)paginationEnabled
{
    _paginationEnabled = paginationEnabled;
    self.showsInfiniteScrolling = paginationEnabled;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        _searchEnabled = NO;
        _pullToRefreshEnabled = YES;
        _paginationEnabled = YES;
    }
    return self;
}

- (void)reloadData
{
    [super reloadData];

    [self.delegate didReloadDataForTableView:self];
}

- (void)pullFreshData
{
    if ([self.delegate respondsToSelector:@selector(willPullFreshDataForTableView:)]) {
        [self.delegate willPullFreshDataForTableView:self];
    }
    if ([self.dataSource respondsToSelector:@selector(pullFreshDataForTableView:)]) {
        [self.dataSource pullFreshDataForTableView:self];
    }
}

@end
