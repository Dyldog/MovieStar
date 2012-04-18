//
//  AppDelegate.m
//  MovieStar
//
//  Created by Dylan Elliott on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MovieViewController.h"
#import "LoginViewController.h"
#import "FriendsViewController.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize loginViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[DataManager sharedManager] setAppDelegate:self];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    self.tabBarController = [[UITabBarController alloc] init];
    MovieViewController *movieViewController = [[MovieViewController alloc] init];
    UINavigationController *movieNavController = [[UINavigationController alloc] initWithRootViewController:movieViewController];
    [movieNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bar.png"] 
                                                  forBarMetrics:UIBarMetricsDefault];
    FriendsViewController *friendsViewController = [[FriendsViewController alloc] init];
    UINavigationController *friendsNavController = [[UINavigationController alloc] initWithRootViewController:friendsViewController];
    [friendsNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bar.png"] 
                                             forBarMetrics:UIBarMetricsDefault];
    ProfileViewController *profileViewController =[[ProfileViewController alloc] initWithUser:nil];
    UINavigationController *profileNavController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    [profileNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bar.png"] 
                                             forBarMetrics:UIBarMetricsDefault];
    [profileNavController.tabBarItem setImage:[UIImage imageNamed:@"tab_profile.png"]];
    [profileNavController.tabBarItem setTitle:@"Profile"];
    
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    [settingsNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bar.png"] 
                                             forBarMetrics:UIBarMetricsDefault];

    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             movieNavController, 
                                             friendsNavController,
                                             profileNavController,
                                             settingsNavController, nil];
    
    self.window.rootViewController = self.loginViewController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[[DataManager sharedManager] facebook] handleOpenURL:url]; 
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[[DataManager sharedManager] facebook] handleOpenURL:url]; 
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

- (void) userDidLogin {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
                           forView:self.window cache:YES];
    [self.window addSubview:self.tabBarController.view];
    [self.loginViewController.view removeFromSuperview];
    [UIView commitAnimations];
    
}

@end
