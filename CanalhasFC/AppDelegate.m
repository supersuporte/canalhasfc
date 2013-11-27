//
//  AppDelegate.m
//  CanalhasFC
//
//  Created by Carlos Gomes on 26/08/13.
//  Copyright (c) 2013 Carlos Gomes. All rights reserved.
//

#import "AppDelegate.h"
#import "NoticiasViewController.h"
#import "FinancasViewController.h"
#import "StoreViewController.h"

@implementation AppDelegate
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    NoticiasViewController *noticiasViewController = [[NoticiasViewController alloc] initWithNibName:@"NoticiasViewController" bundle:nil];
    UINavigationController *noticiasNavigationController = [[UINavigationController alloc] initWithRootViewController:noticiasViewController];
    UITabBarItem *noticiasTabBarItem = [noticiasNavigationController tabBarItem];
    [noticiasTabBarItem setTitle:@"Notícias"];

    FinancasViewController *financasViewController = [[FinancasViewController alloc] initWithNibName:@"FinancasViewController" bundle:nil];
    UINavigationController *financasNavigationController = [[UINavigationController alloc] initWithRootViewController:financasViewController];
    UITabBarItem *financasTabBarItem = [financasNavigationController tabBarItem];
    [financasTabBarItem setTitle:@"Finanças"];
    
    StoreViewController *storeViewController = [[StoreViewController alloc] initWithNibName:@"StoreViewController" bundle:nil];
    UINavigationController *storeNavigationController = [[UINavigationController alloc] initWithRootViewController:storeViewController];
    UITabBarItem *storeTabBarItem = [storeNavigationController tabBarItem];
    [storeTabBarItem setTitle:@"Store"];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:noticiasNavigationController, financasNavigationController, storeNavigationController, nil];
    [tabBarController setViewControllers:viewControllers];
    
    [self.window setRootViewController:tabBarController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
