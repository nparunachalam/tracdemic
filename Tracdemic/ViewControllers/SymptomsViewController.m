//
//  SymptomsViewController.m
//  Tracdemic
//
//  Created by Oruvan on 3/30/20.
//  Copyright © 2020 Oruvan. All rights reserved.
//

#import "SymptomsViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"

@interface SymptomsViewController ()

@end

@implementation SymptomsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)leftDrawerButtonPress:(id)sender {
    
    UINavigationController *homeNavController = [self.storyboard instantiateInitialViewController];
    [self.mm_drawerController setCenterViewController:homeNavController withCloseAnimation:YES completion:nil];

}
@end
