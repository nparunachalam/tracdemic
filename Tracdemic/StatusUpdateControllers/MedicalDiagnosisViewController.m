//
//  MedicalDiagnosisViewController.m
//  Tracdemic
//
//  Created by Oruvan on 3/30/20.
//  Copyright © 2020 Oruvan. All rights reserved.
//

#import "MedicalDiagnosisViewController.h"

@interface MedicalDiagnosisViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MedicalDiagnosisViewController

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"Medical Diagnosis"];

    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.alwaysBounceVertical = NO;

    tableView.delegate = self;
    tableView.dataSource = self;

    tableView.backgroundColor = [UIColor whiteColor];

    // add to canvas
    [self.view addSubview:tableView];
    
    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(saveSymptomsButtonClicked:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return 5;
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
        [cell.textLabel setText:@"CDC Test"];

        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:NO animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    else if(indexPath.row == 1) {
        [cell.textLabel setText:@"Non CDC Test"];

        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:NO animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    else if(indexPath.row == 2) {
        [cell.textLabel setText:@"Other Test"];

        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:NO animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    else if(indexPath.row == 3) {
        [cell.textLabel setText:@"Doctor Diagnosis"];

        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:NO animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    else {
        [cell.textLabel setText:@"Self Diagnosis"];

        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchView;
        [switchView setOn:NO animated:NO];
        [switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }

    return cell;
}

- (void)switchChanged:(id)sender {
    UISwitch *switchControl = sender;
    NSLog( @"SymptomStatusUpdateViewController: switch is %@", switchControl.on ? @"ON" : @"OFF" );
}

- (void)saveSymptomsButtonClicked:(id)sender {
    NSLog( @"SymptomStatusUpdateViewController: saveSymptomsButtonClicked");
}

@end
