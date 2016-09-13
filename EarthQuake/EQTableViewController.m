//
//  ViewController.m
//  EarthQuake
//
//  Created by Jonathan Fuentes Flores on 4/28/15.
//  Copyright (c) 2015 Jonathan. All rights reserved.
//

#import "EQTableViewController.h"

//UI
#import "EQDetailViewController.h"

//Libraries
#import "EQSessionManager.h"
#import "MBProgressHUD.h"

@interface EQTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *earthQuakes;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *reloadBarButtonItem;

@end

@implementation EQTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reloadBarButtonItem.target = self;
    self.reloadBarButtonItem.action = @selector(updateFeed:);
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    
    [self.refreshControl addTarget:self
                            action:@selector(updateFeed:)
                  forControlEvents:UIControlEventValueChanged];
    
    [self updateFeed:nil];
}

- (void)updateFeed:(id)sender {
    if ([sender isKindOfClass:[UIBarButtonItem class]]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [[EQSessionManager sharedManager] getFeedWithCompletionBlock:^(NSArray *earthQuakes, NSError *error) {
        if ([sender isKindOfClass:[UIBarButtonItem class]]) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        [self.refreshControl endRefreshing];
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Please try again"
                                                               delegate:self cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        self.earthQuakes = earthQuakes;
        self.navigationItem.title = [NSString stringWithFormat:@"(%lu) EarthQuakes", (unsigned long)earthQuakes.count];
        [self.tableView reloadData];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EQDetailViewController *detailViewController = (EQDetailViewController *)segue.destinationViewController;
    NSIndexPath *selectedCellIndexPath = [self.tableView indexPathForCell:sender];
    NSDictionary *selectedEarthQuake = self.earthQuakes[selectedCellIndexPath.row];
    detailViewController.earthQuake = selectedEarthQuake;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.earthQuakes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *earthQuake = self.earthQuakes[indexPath.row];
    
    cell.textLabel.text = earthQuake[kEQPlaceKey];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", earthQuake[kEQMagnitudeKey]];
    
    double magnitude = [earthQuake[kEQMagnitudeKey] doubleValue];
    
    if (magnitude >= 0.0 && magnitude <= 0.9) {
        cell.backgroundColor = [UIColor greenColor];
    } else if (magnitude >= 9.0 && magnitude <= 9.9) {
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor purpleColor];
    }
    
    return cell;
}

@end