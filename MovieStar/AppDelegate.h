//
//  AppDelegate.h
//  MovieStar
//
//  Created by Dylan Elliott on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DataManager.h"

@class LoginViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, MSDataManagerDelegate> {
    
    LoginViewController *loginViewController;
    
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end
