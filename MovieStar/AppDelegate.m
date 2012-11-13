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
#import "TagViewController.h"
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
    [movieNavController setDelegate:movieViewController];
    [movieNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bar.png"] 
                                                  forBarMetrics:UIBarMetricsDefault];
    
    FriendsViewController *friendsViewController = [[FriendsViewController alloc] init];
    UINavigationController *friendsNavController = [[UINavigationController alloc] initWithRootViewController:friendsViewController];
    [friendsNavController setDelegate:friendsViewController];
    [friendsNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bar.png"] 
                                             forBarMetrics:UIBarMetricsDefault];

//    TagViewController *tagViewController =[[TagViewController alloc] initWithNibName:nil bundle:nil];
//    UINavigationController *tagNavController = [[UINavigationController alloc] initWithRootViewController:tagViewController];
//    [tagNavController setDelegate:tagViewController];
//    [tagNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bar.png"] 
//                                         forBarMetrics:UIBarMetricsDefault];
//    [tagNavController.tabBarItem setImage:[UIImage imageNamed:@"tab_tag.png"]];
//    [tagNavController.tabBarItem setTitle:@"Tag"];

    ProfileViewController *profileViewController =[[ProfileViewController alloc] initWithUser:nil];
    UINavigationController *profileNavController = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    [profileNavController setDelegate:profileViewController];
    [profileNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bar.png"] 
                                             forBarMetrics:UIBarMetricsDefault];
    [profileNavController.tabBarItem setImage:[UIImage imageNamed:@"tab_profile.png"]];
    [profileNavController.tabBarItem setTitle:@"Profile"];
    
//    SettingsViewController *settingsViewController = [[SettingsViewController alloc] init];
//    UINavigationController *settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
//    [settingsNavController setDelegate:settingsViewController];
//    [settingsNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"title_bar.png"] 
//                                             forBarMetrics:UIBarMetricsDefault];

    
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:
                                             movieNavController, 
                                             friendsNavController,
                                             profileNavController, nil];
    
    UIImageView *customTabBarImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_bar.png"]];
    [customTabBarImageView setUserInteractionEnabled:NO];
    CGRect customTabBarFrame = customTabBarImageView.frame;
    customTabBarFrame.origin.y -= 15;
    [customTabBarImageView setFrame:customTabBarFrame];
    
    UIImageView *tab1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_movies.png"] highlightedImage:[UIImage imageNamed:@"tab_movies.png"]];
    
    UIImageView *tab2ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_friends.png"] highlightedImage:[UIImage imageNamed:@"tab_friends.png"]];
    CGRect tab2Frame = tab1ImageView.frame;
    tab2Frame.origin.x += tab2Frame.size.width;
    [tab2ImageView setFrame:tab2Frame];
    
    UIImageView *tab3ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_tag.png"] highlightedImage:[UIImage imageNamed:@"tab_tag.png"]];
    CGRect tab3Frame = tab2ImageView.frame;
    tab3Frame.origin.x += tab3Frame.size.width;
    [tab3ImageView setFrame:tab3Frame];
    
    UIImageView *tab4ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_profile.png"] highlightedImage:[UIImage imageNamed:@"tab_profile.png"]];
    CGRect tab4Frame = tab3ImageView.frame;
    tab4Frame.origin.x += tab4Frame.size.width;
    [tab4ImageView setFrame:tab4Frame];
    
    UIImageView *tab5ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_settings.png"] highlightedImage:[UIImage imageNamed:@"tab_settings.png"]];
    CGRect tab5Frame = tab4ImageView.frame;
    tab5Frame.origin.x += tab5Frame.size.width;
    [tab5ImageView setFrame:tab5Frame];    
    
    [customTabBarImageView addSubview:tab1ImageView];
    [customTabBarImageView addSubview:tab2ImageView];
    [customTabBarImageView addSubview:tab3ImageView];
    [customTabBarImageView addSubview:tab4ImageView];
    [customTabBarImageView addSubview:tab5ImageView];
    
//    [self.tabBarController.tabBar addSubview:customTabBarImageView];
    
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

// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    previousSelectedTabIndex = [tabBarController selectedIndex];
}


// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}


- (void) userDidLogin {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
                           forView:self.window cache:YES];
    [self.window addSubview:self.tabBarController.view];
    [self.loginViewController.view removeFromSuperview];
    [UIView commitAnimations];
    
}

@end
