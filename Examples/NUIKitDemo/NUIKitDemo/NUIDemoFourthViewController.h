//
//  NUIDemoFourthViewController.h
//  NUIKitDemo
//
//  Created by Ali Servet Donmez on 24.9.12.
//  Copyright (c) 2012 Ali Servet Donmez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUIKit.h"

@interface NUIDemoFourthViewController : UIViewController <NUITableViewDelegate, NUITableViewDataSource>

@property (weak, nonatomic) IBOutlet NUITableView *tableView;

@end
