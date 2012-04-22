//
//  ProfileViewController.h
//  MovieStar
//
//  Created by Dylan Elliott on 18/03/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieStarViewController.h"

@interface ProfileViewController : MovieStarViewController <MSDataManagerDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    MSUser *_user;
    
    IBOutlet EGOImageView *_profilePictureImageView;
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_numMoviesRatedLabel;
    IBOutlet UITableView *_tagTableView;
    
    IBOutlet UIView *tagSectionHeader;
    IBOutlet UIButton *topButton;
    IBOutlet UIButton *latestButton;
}

- (id) initWithUser:(MSUser *)user;
- (void) reload;

@property (nonatomic, strong) MSUser *user;

@property (nonatomic, strong) UIImageView *profilePictureImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numMoviesRatedLabel;
@property (nonatomic, strong) UITableView *tagTableView;
- (IBAction)topButtonSelected:(id)sender;
- (IBAction)latestButtonSelected:(id)sender;

@end
