//
//  RecordMeViewController.m
//  Tracdemic
//
//  Created by Oruvan on 3/29/20.
//  Copyright © 2020 Oruvan. All rights reserved.
//

#import "RecordMeViewController.h"
#import "StatusUpdateViewController.h"

@interface RecordMeViewController ()

@end

@implementation RecordMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(statusUpdateButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Status Update" forState:UIControlStateNormal];
    [button setBackgroundColor:UIColor.blueColor];
    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:button];
    

    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(statusUpdateButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Record Me" forState:UIControlStateNormal];
    [button setBackgroundColor:UIColor.blueColor];
    button.frame = CGRectMake(80.0, 410.0, 160.0, 40.0);
    [self.view addSubview:button];
    
}

-(void) recordMeButtonClicked:(UIButton*)sender {
    NSLog(@"recordMeButtonClicked enter");

    UIAlertController * disabledContactsAlert = [UIAlertController alertControllerWithTitle:@"Thank you"
                message:@"Your location/route will be anonymous recorded"
                preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction* ok = [UIAlertAction
                actionWithTitle:@"OK"
                style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * action) {
                }];

    [disabledContactsAlert addAction:ok];
    //    [disabledContactsAlert addAction:settingsButton];
    [self presentViewController:disabledContactsAlert animated:YES completion:nil];

    NSLog(@"recordMeButtonClicked exit");
}

-(void) statusUpdateButtonClicked:(UIButton*)sender {
    NSLog(@"statusUpdateButtonClicked enter");

    StatusUpdateViewController* statusUpdateViewController = [[StatusUpdateViewController alloc] initWithNibName:NULL bundle:NULL];
    [self.navigationController pushViewController:statusUpdateViewController animated:NO];

    NSLog(@"statusUpdateButtonClicked exit");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
