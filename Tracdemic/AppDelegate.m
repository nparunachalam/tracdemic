//
//  AppDelegate.m
//  Tracdemic
//
//  Created by Oruvan on 3/29/20.
//  Copyright © 2020 Oruvan. All rights reserved.
//  Thanks Oruvan

#import "AppDelegate.h"
#import "MMDrawerController.h"

@interface AppDelegate ()

@property (nonatomic, strong) MMDrawerController *drawerController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *homeViewcontroller = [storyBoard instantiateInitialViewController];
    UINavigationController *leftViewController = [storyBoard instantiateViewControllerWithIdentifier:@"MyProfile"];
    
    
    self.drawerController = [[MMDrawerController alloc]
                        initWithCenterViewController:homeViewcontroller
                        leftDrawerViewController:leftViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.drawerController];
    
    [self.window makeKeyAndVisible];

    return YES;
}

@end
