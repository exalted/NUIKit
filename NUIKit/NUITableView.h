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

#import "NUIKit.h"

@class NUITableView;

typedef enum {
    NUIRefreshControlStyleDefault = 1,
    NUIRefreshControlStyleLegacy
} NUIRefreshControlStyle;

////////////////////////////////////////////////////////////////////////////////
// Delegate protocol definition
////////////////////////////////////////////////////////////////////////////////
@protocol NUITableViewDelegate <NSObject, UITableViewDelegate>

@optional

- (void)willPullFreshDataForTableView:(NUITableView *)tableView;

- (BOOL)shouldReloadDataForTableView:(NUITableView *)tableView;

@end

////////////////////////////////////////////////////////////////////////////////
// Data source protocol definition
////////////////////////////////////////////////////////////////////////////////
@protocol NUITableViewDataSource <NSObject, UITableViewDataSource>

@optional

- (void)pullFreshDataForTableView:(NUITableView *)tableView;
- (void)pullMoreDataForTableView:(NUITableView *)tableView;

@end

////////////////////////////////////////////////////////////////////////////////
// Class interface
////////////////////////////////////////////////////////////////////////////////
@interface NUITableView : UITableView

@property (assign, nonatomic) id<NUITableViewDelegate> delegate;
@property (assign, nonatomic) id<NUITableViewDataSource> dataSource;

@property (assign, nonatomic) BOOL paginationEnabled;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style refreshControlStyle:(NUIRefreshControlStyle)refreshControlStyle;

- (void)pullFreshData;
- (void)pullMoreData;

@end
