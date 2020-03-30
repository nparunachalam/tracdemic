//
//  StatusUpdateViewController.m
//  Tracdemic
//
//  Created by Pavan Chayanam on 3/29/20.
//  Copyright © 2020 Oruvan. All rights reserved.
//

#import "StatusUpdateViewController.h"
#import "SymptomStatusUpdateViewController.h"

@interface StatusUpdateViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray* data1;
@property (nonatomic, strong) NSArray* data2;

@end

@implementation StatusUpdateViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Update Status";
    
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.alwaysBounceVertical = NO;

    tableView.delegate = self;
    tableView.dataSource = self;

    tableView.backgroundColor = [UIColor whiteColor];

    // add to canvas
    [self.view addSubview:tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:    (NSInteger)section
{
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
        [cell.textLabel setText:@"Symptoms Experienced"];
    }
    else if(indexPath.row == 1) {
        [cell.textLabel setText:@"Likely Exposure"];
    }
    else {
        [cell.textLabel setText:@"Medical Diagnosis"];
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.row == 0) {
        NSLog(@"StatusUpdateViewController selected Symptoms");
        SymptomStatusUpdateViewController* nextViewController = [[SymptomStatusUpdateViewController alloc] initWithNibName:NULL bundle:NULL];
        [self.navigationController pushViewController:nextViewController animated:YES];
    }
    
    if(indexPath.row == 1) {
        NSLog(@"StatusUpdateViewController selected Exposure");
    }
    
    if(indexPath.row == 2) {
        NSLog(@"StatusUpdateViewController selected Diagnosis");
    }
}

@end

