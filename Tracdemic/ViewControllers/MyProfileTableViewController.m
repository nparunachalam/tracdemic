//
//  MyProfileTableViewController.m
//  Tracdemic
//
//  Created by Oruvan on 3/29/20.
//  Copyright © 2020 Oruvan. All rights reserved.
//

#import "MyProfileTableViewController.h"
#import "ProfileHeaderView.h"
#import "UIViewController+MMDrawerController.h"

@interface MyProfileTableViewController () {
    
    UINib *headerNib;
}

@property (nonatomic, strong) NSArray *section2ContentsArray;
@property (nonatomic, strong) NSArray *section1ContentsArray;

@end

@implementation MyProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.section1ContentsArray = @[@"Status: UnInfected"];
    self.section2ContentsArray = @[@"Symptoms", @"Incubation", @"Location", @"Population"];
    
    headerNib = [UINib nibWithNibName:@"ProfileHeaderView" bundle:[NSBundle mainBundle]];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return [self.section1ContentsArray count];
    }
    else {
        return [self.section2ContentsArray count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    if(indexPath.section == 0) {
        [cell.textLabel setText:[self.section1ContentsArray objectAtIndex:indexPath.row]];
    }
    else {
        
        [cell.textLabel setText:[self.section2ContentsArray objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ProfileHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
    
    if(section == 0) {
        [headerView.headerLabel setText:@""];
    }
    else {
        [headerView.headerLabel setText:@"Stats"];

    }
    return headerView;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 0: {
                UINavigationController *symptomsController = (UINavigationController*)[self.storyboard instantiateViewControllerWithIdentifier:@"SymptomsView"];
                [self.mm_drawerController setCenterViewController:symptomsController withCloseAnimation:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
        
    }
}

@end
