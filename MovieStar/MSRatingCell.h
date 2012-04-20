//
//  MSRatingCell.h
//  MovieStar
//
//  Created by Dylan Elliott on 19/04/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;
@class JSFavStarControl;
@interface MSRatingCell : UITableViewCell {
    MSRating *rating;
    
    EGOImageView* movieCoverView;
    UILabel *movieTitleLabel;
    UILabel *yearLabel;
    JSFavStarControl *userRatingControl;
    UILabel *averageRatingLabel;
    JSFavStarControl *averageRatingControl;
}

@property(nonatomic, strong) MSRating* rating;
@property(nonatomic, strong) EGOImageView* movieCoverView;
@property(nonatomic, strong) UILabel *movieTitleLabel;
@property(nonatomic, strong) UILabel *yearLabel;
@property(nonatomic, strong) JSFavStarControl *userRatingControl;
@property(nonatomic, strong) UILabel *averageRatingLabel;
@property(nonatomic, strong) JSFavStarControl *averageRatingControl;

@end
