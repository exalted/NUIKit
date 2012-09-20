//
//  NUIDemoFourthViewController.m
//  NUIKitDemo
//
//  Created by Ali Servet Donmez on 24.9.12.
//  Copyright (c) 2012 Ali Servet Donmez. All rights reserved.
//

#import "NUIDemoFourthViewController.h"

@interface NUIDemoFourthViewController ()

@end

@implementation NUIDemoFourthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Subview", @"Subview");
        self.tabBarItem.image = [UIImage imageNamed:@"fourth"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    // Configure the cell...

    cell.textLabel.text = [NSString stringWithFormat:@"Section %d", indexPath.section+1];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row+1];

    return cell;
}

- (void)pullFreshDataForTableView:(NUITableView *)tableView
{
    NSLog(@"%@: pull fresh data...", [self class]);
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
    });
}

- (void)pullMoreDataForTableView:(NUITableView *)tableView
{
    NSLog(@"%@: pull more data...", [self class]);
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
    });
}

#pragma mark - Table view delegate

- (BOOL)shouldReloadDataForTableView:(NUITableView *)tableView
{
    return NO;
}

@end
