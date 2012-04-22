//
//  SingleMovieViewController.h
//  MovieStar
//
//  Created by Dylan Elliott on 4/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSFavStarControl.h"
#import "EGOImageView.h"
#import "MovieStarViewController.h"

@interface SingleMovieViewController : MovieStarViewController <MSDataManagerDelegate> {
    
    MSMovie *movie;
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet EGOImageView *coverImageView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *yearLabel;
    JSFavStarControl *ratingControl;

    IBOutlet UIView *bottomView;
    IBOutlet UIView *taggerControlHolder;
    JSFavStarControl *taggerControl;
    IBOutlet UIButton *tagButton;
    UIImageView *taggerBackgroundImageView;
    IBOutlet UIImageView *commentsHeaderBGImageView;
    IBOutlet UILabel *commentsHeaderLabel;
    
    UITextView *commentTextView;
}

- (void) updateMovieInfo;
- (void) setMovie:(MSMovie *)m;
- (IBAction)tagButtonPressed:(id)sender;
- (IBAction)commentButtonTapped:(id)sender;
- (void) reload;
- (IBAction)imdbButtonTapped:(id)sender;

@end
