//
//  LikelyExposureViewController.m
//  Tracdemic
//
//  Created by Oruvan on 3/30/20.
//  Copyright © 2020 Oruvan. All rights reserved.
//

#import "LikelyExposureViewController.h"

@interface LikelyExposureViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation LikelyExposureViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"Likely Exposure"];
    
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.alwaysBounceVertical = NO;

    tableView.delegate = self;
    tableView.dataSource = self;

    tableView.backgroundColor = [UIColor whiteColor];

    // add to canvas
    [self.view addSubview:tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"StatusCell";

    // Similar to UITableViewCell, but
    UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if(indexPath.row == 0) {
        [cell.textLabel setText:@"Location"];
    }
    else if(indexPath.row == 1) {
        [cell.textLabel setText:@"Exposure Type"];
    }
    else {
        [cell.textLabel setText:@"Approximate Time"];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0) {
    }
    else if(indexPath.row == 1) {
        
    }
    else if(indexPath.row == 2) {
    }
}

@end
