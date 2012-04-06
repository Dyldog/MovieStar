//
//  LoginViewController.h
//  MovieStar
//
//  Created by Dylan Elliott on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieStarViewController.h"

@interface LoginViewController : MovieStarViewController <MSDataManagerDelegate> {
    
    UIImageView *_bannerImageView;
    UIButton *_facebookButton;
    
}

@property (nonatomic) IBOutlet UIImageView *bannerImageView;
@property (nonatomic) IBOutlet UIButton *facebookButton;

- (IBAction)facebookButtonTapped:(id)sender;


@end
