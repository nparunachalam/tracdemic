//
//  LikelyExposureViewController.m
//  Tracdemic
//
//  Created by Oruvan on 3/30/20.
//  Copyright © 2020 Oruvan. All rights reserved.
//

#import "LikelyExposureViewController.h"

@interface LikelyExposureViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UITableView* tableView;

@property (strong, nonatomic) UILabel* exposureTypeLabel;
@property (strong, nonatomic) NSArray* exposureTypeOptionsArray;

@property (strong, nonatomic) UIPickerView* exposureTypePicker;
@property (strong, nonatomic) UIPickerView* exposureDatePicker;
@property (strong, nonatomic) UIPickerView* exposureTimePicker;

@property (strong, nonatomic) UITextField* exposureLocationTF;
@property (strong, nonatomic) UITextField* exposureTypeTF;
@property (strong, nonatomic) UITextField* exposureDateTF;
@property (strong, nonatomic) UITextField* exposureTimeTF;

@end

@implementation LikelyExposureViewController

@synthesize tableView;
@synthesize exposureTypeLabel;
@synthesize exposureTypeOptionsArray;

@synthesize exposureTypePicker;
@synthesize exposureDatePicker;
@synthesize exposureTimePicker;
@synthesize exposureLocationTF;
@synthesize exposureTypeTF;
@synthesize exposureDateTF;
@synthesize exposureTimeTF;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"Likely Exposure"];
    
    exposureTypeOptionsArray=[[NSArray alloc]initWithObjects:@"Direct Contact", @"Airborne", @"Inset Bite", @"Water Borne", @"Articles", @"Fluid Exchange", nil];
    
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.alwaysBounceVertical = NO;

    tableView.delegate = self;
    tableView.dataSource = self;

    tableView.backgroundColor = [UIColor whiteColor];

    // add to canvas
    [self.view addSubview:tableView];

    exposureLocationTF =[[UITextField alloc] initWithFrame:CGRectMake(5, 5, 300,30)];
    exposureLocationTF.textColor=[UIColor blackColor];
    exposureLocationTF.placeholder = @"Location";

    exposureTypeTF =[[UITextField alloc] initWithFrame:CGRectMake(5, 5, 300,30)];
    exposureTypeTF.textColor=[UIColor blackColor];
    exposureTypeTF.placeholder = @"Exposure Type";

    exposureDateTF =[[UITextField alloc] initWithFrame:CGRectMake(5, 5, 300,30)];
    exposureDateTF.textColor=[UIColor blackColor];
    exposureDateTF.placeholder = @"Date";

    exposureTimeTF =[[UITextField alloc] initWithFrame:CGRectMake(5, 5, 300,30)];
    exposureTimeTF.textColor=[UIColor blackColor];
    exposureTimeTF.placeholder = @"Time";

    exposureTypePicker =[[UIPickerView alloc]init];
    exposureTypePicker.dataSource=self;
    exposureTypePicker.delegate=self;
    [exposureTypePicker setShowsSelectionIndicator:YES];
    [exposureTypeTF setInputView:exposureTypePicker];

    exposureTimePicker =[[UIPickerView alloc]init];
    exposureTimePicker.dataSource=self;
    exposureTimePicker.delegate=self;
    [exposureTimePicker setShowsSelectionIndicator:YES];
    [exposureTimeTF setInputView:exposureTimePicker];

    exposureDatePicker =[[UIPickerView alloc]init];
    exposureDatePicker.dataSource=self;
    exposureDatePicker.delegate=self;
    [exposureDatePicker setShowsSelectionIndicator:YES];
    [exposureTimeTF setInputView:exposureDatePicker];

    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(removePicker:)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [exposureTypeTF setInputAccessoryView:toolBar];
    [exposureTimeTF setInputAccessoryView:toolBar];
    [exposureDateTF setInputAccessoryView:toolBar];

    UIBarButtonItem* saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Save"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(saveSymptomsButtonClicked:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
}

-(void)removePicker:(id)sender {
    [self.exposureTypeTF resignFirstResponder];
    [self.exposureTimeTF resignFirstResponder];
    [self.exposureDateTF resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
        [cell.contentView addSubview:exposureLocationTF];
    }
    else if(indexPath.row == 1) {
        [cell.contentView addSubview:exposureTypeTF];
    }
    else if(indexPath.row == 2) {
        [cell.contentView addSubview:exposureDateTF];
        
        NSDate *today = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSString *dateString = [dateFormat stringFromDate:today];
        
        exposureDateTF.attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Date: %@", dateString] attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
        
    }
    else {
        [cell.contentView addSubview:exposureTimeTF];

        NSDate *today = [NSDate date];
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        [timeFormat setDateFormat:@"HH:mm a Z"];
        NSString *timeString = [timeFormat stringFromDate:today];
        
        exposureTimeTF.attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Time: %@", timeString] attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] }];
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

#pragma mark - UIPickerView DataSource Method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [exposureTypeOptionsArray count];
}

#pragma mark - UIPickerView Delegate Method

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [exposureTypeOptionsArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.exposureTypeTF.text=[exposureTypeOptionsArray objectAtIndex:row];
}

@end
