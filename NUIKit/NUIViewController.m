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

#import "NUIViewController.h"

////////////////////////////////////////////////////////////////////////////////
#pragma mark - Class implementation
////////////////////////////////////////////////////////////////////////////////
@implementation NUIViewController

/*
 * Prior to iOS 6, when a low-memory warning occurred, the UIViewController
 * class purged its views if it knew it could reload or recreate them again
 * later. If this happens, it also calls the viewWillUnload and viewDidUnload
 * methods to give your code a chance to relinquish ownership of any objects
 * that are associated with your view hierarchy, including objects loaded from
 * the nib file, objects created in your viewDidLoad method, and objects created
 * lazily at runtime and added to the view hierarchy.

 * On iOS 6, views are never purged and these methods are never called. If a
 * view controller needs to perform specific tasks when memory is low, it should
 * override the didReceiveMemoryWarning method.
 *
 * This will simulate previous behavior also in iOS 6 without hurting much.
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && [self.view window] == nil) {
        [self viewWillUnload];
        [self setView:nil];
        [self viewDidUnload];
    }
}

@end
