//
//  SettingsViewController.h
//  MovieStar
//
//  Created by Dylan Elliott on 6/04/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieStarViewController.h"

@interface SettingsViewController : MovieStarViewController <UINavigationControllerDelegate> {
    
    IBOutlet UITableView *settingsTableView;
}

@end
