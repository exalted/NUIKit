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

#import "ODRefreshControl.h"
#import "SVPullToRefresh.h"

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private APIs
////////////////////////////////////////////////////////////////////////////////
@interface NUITableView () {
    NUIRefreshControlStyle _refreshControlStyle;
}

@property (assign, nonatomic) NSString *refreshControlStyle; // "User Defined Runtime Attribute" for use in Interface Builder

@property (strong, nonatomic) ODRefreshControl *defaultRefreshControl;

@end

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Class implementation
////////////////////////////////////////////////////////////////////////////////
@implementation NUITableView

#pragma mark Initializing

- (id)init
{
    return [self initWithFrame:CGRectZero style:UITableViewStylePlain refreshControlStyle:NUIRefreshControlStyleDefault];
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:UITableViewStylePlain refreshControlStyle:NUIRefreshControlStyleDefault];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    return [self initWithFrame:frame style:style refreshControlStyle:NUIRefreshControlStyleDefault];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style refreshControlStyle:(NUIRefreshControlStyle)refreshControlStyle
{
    NSAssert(refreshControlStyle != NUIRefreshControlStyleLegacy, @"Legacy refresh control style is not supported yet!");

    self = [super initWithFrame:frame style:style];
    if (self) {
        _refreshControlStyle = refreshControlStyle;
    }
    return self;
}

#pragma mark Observing View-Related Changes

- (void)didMoveToWindow
{
    [super didMoveToWindow];

    // Add pull-to-refresh
    if (_refreshControlStyle == NUIRefreshControlStyleDefault) {
        _defaultRefreshControl = [[ODRefreshControl alloc] initInScrollView:self];
        [_defaultRefreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    }
}

#pragma mark Reloading the Table View

- (void)reloadData
{
    [super reloadData];

    [self.defaultRefreshControl endRefreshing];
    [self.infiniteScrollingView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.0];
}

#pragma mark Pull data

- (void)pullFreshData
{
    if ([self.delegate respondsToSelector:@selector(willPullFreshDataForTableView:)]) {
        [self.delegate willPullFreshDataForTableView:self];
    }

    if ([self.dataSource respondsToSelector:@selector(pullFreshDataForTableView:)]) {
        [self.dataSource pullFreshDataForTableView:self];
    }
}

- (void)pullMoreData
{
    if ([self.dataSource respondsToSelector:@selector(pullMoreDataForTableView:)]) {
        [self.dataSource pullMoreDataForTableView:self];
    }
}

#pragma mark ()

- (void)setRefreshControlStyle:(NSString *)refreshControlStyle
{
    if ([refreshControlStyle isEqualToString:@"default"]) {
        _refreshControlStyle = NUIRefreshControlStyleDefault;
    }
    else if ([refreshControlStyle isEqualToString:@"legacy"]) {
        _refreshControlStyle = NUIRefreshControlStyleLegacy;
    }
    else {
        NSAssert(NO, @"Invalid refresh control style \"%@\" specified in User Defined Runtime Attributes from nib.", refreshControlStyle);
    }
}

- (NSString *)refreshControlStyle
{
    NSAssert(NO, @"You shouldn't rely on this, use _refreshControlStyle ivar instead.");
    abort();
}

- (void)setPaginationEnabled:(BOOL)paginationEnabled
{
    _paginationEnabled = paginationEnabled;
    self.showsInfiniteScrolling = paginationEnabled;

    if (paginationEnabled) {
        // (Ref.: http://stackoverflow.com/questions/7853915/how-do-i-avoid-capturing-self-in-blocks-when-implementing-an-api/7854315#7854315)
        // Also read "Use Lifetime Qualifiers to Avoid Strong Reference Cycles" in "Transitioning to ARC Release Notes" of iOS documentation
        NUITableView * __block weakSelf = self;
        [self addInfiniteScrollingWithActionHandler:^{
            [weakSelf dropViewDidBeginRefreshing:nil];
        }];
    }
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    if (refreshControl && _refreshControlStyle > 0) {
        [self pullFreshData];
    }
    else if (self.paginationEnabled) {
        [self pullMoreData];
    }
    else {
        return;
    }

    BOOL reloadData = YES;
    if ([self.delegate respondsToSelector:@selector(shouldReloadDataForTableView:)]) {
        reloadData = [self.delegate shouldReloadDataForTableView:self];
    }
    if (reloadData) {
        [self reloadData];
    }
}

@end
