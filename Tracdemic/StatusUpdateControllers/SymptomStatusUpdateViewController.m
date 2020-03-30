//
//  SymptomStatusUpdateViewController.m
//  Tracdemic
//
//  Created by Pavan Chayanam on 3/29/20.
//  Copyright © 2020 Oruvan. All rights reserved.
//

#import "SymptomStatusUpdateViewController.h"

@interface SymptomStatusUpdateViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSArray* symptomNames;

@end

@implementation SymptomStatusUpdateViewController

@synthesize tableView;
@synthesize symptomNames = _symptomNames;


- (NSArray *)symptomNames {
    if (_symptomNames == nil) {
        _symptomNames = [NSArray arrayWithObjects:@"Fever",
                         @"Dry Cough",
                         @"Fatigue",
                         @"Septum",
                         @"Shortness of breath",
                         @"Sore Throat",
                         @"Headache",
                         @"Muscle/Joint Pain",
                         @"Chills",
                         @"Nauseous",
                         @"Nasal Congestion",
                         @"Diarrhea",
                         @"Blood Cough",
                         @"Conjunctivitis/Pink eye",
                         @"Other",
                         nil];
    }
    return _symptomNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Symptoms Status";
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:    (NSInteger)section
{
    return self.symptomNames.count;
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HistoryCell";

    // Similar to UITableViewCell, but
    UITableViewCell *cell = (UITableViewCell *)[theTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.symptomNames objectAtIndex:indexPath.row];
    cell.editing = true;

    if(indexPath.row > 0 && indexPath.row == (self.symptomNames.count-1)) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

