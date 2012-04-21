//
//  MSRatingCell.m
//  MovieStar
//
//  Created by Dylan Elliott on 19/04/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import "MSRatingCell.h"
#import "EGOImageView.h"
#import "JSFavStarControl.h"
@implementation MSRatingCell

@synthesize rating, movieCoverView, movieTitleLabel, yearLabel, userRatingControl, averageRatingLabel, averageRatingControl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        movieCoverView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
        movieCoverView.frame = CGRectMake((CELL_HEIGHT - COVER_HEIGHT) / 2, (CELL_HEIGHT - COVER_HEIGHT) / 2, COVER_WIDTH, COVER_HEIGHT);
		[self.contentView addSubview:movieCoverView];
        
        movieTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        movieTitleLabel.numberOfLines = 0;
        movieTitleLabel.font = [UIFont systemFontOfSize:18];
        movieTitleLabel.textColor = [UIColor blackColor];
        movieTitleLabel.backgroundColor = [UIColor clearColor];
        CGRect labelFrame = movieTitleLabel.bounds;
        labelFrame.origin.x = movieCoverView.frame.origin.x + movieCoverView.frame.size.width + 4;
        labelFrame.origin.y = 4;
        labelFrame.size.width = 316 - labelFrame.origin.x;
        labelFrame.size.height = 26;
        movieTitleLabel.frame = labelFrame;
        [self.contentView addSubview:movieTitleLabel];
        
        yearLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        yearLabel.numberOfLines = 0;
        yearLabel.font = [UIFont systemFontOfSize:14];
        yearLabel.textColor = [UIColor blackColor];
        yearLabel.backgroundColor = [UIColor clearColor];
        CGRect yearLabelFrame = yearLabel.bounds;
        yearLabelFrame.origin.x = labelFrame.origin.x;
        yearLabelFrame.origin.y = labelFrame.origin.y + labelFrame.size.height;
        yearLabelFrame.size.width = 316 - labelFrame.origin.x;
        yearLabelFrame.size.height = 20;
        yearLabel.frame = yearLabelFrame;
        [self.contentView addSubview:yearLabel];
        
        userRatingControl = [[JSFavStarControl alloc] initWithLocation:CGPointMake(labelFrame.origin.x, yearLabelFrame.origin.y + yearLabelFrame.size.height) 
                                                          dotImage:[UIImage imageNamed:@"star_comments_hole.png"] 
                                                         starImage:[UIImage imageNamed:@"star_comments.png"] spacing:3];
        [self.contentView addSubview:userRatingControl];
        
        averageRatingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        averageRatingLabel.numberOfLines = 0;
        averageRatingLabel.font = [UIFont systemFontOfSize:14];
        averageRatingLabel.textColor = [UIColor blackColor];
        averageRatingLabel.backgroundColor = [UIColor clearColor];
        CGRect averageLabelFrame = averageRatingLabel.bounds;
        averageLabelFrame.origin.x = labelFrame.origin.x;
        averageLabelFrame.origin.y = userRatingControl.frame.origin.y + userRatingControl.frame.size.height;
        averageLabelFrame.size.width = 316 - labelFrame.origin.x;
        averageLabelFrame.size.height = 20;
        averageRatingLabel.frame = averageLabelFrame;
        averageRatingLabel.text = @"Average Rating";
        [self.contentView addSubview:averageRatingLabel];
        
        averageRatingControl = [[JSFavStarControl alloc] initWithLocation:CGPointMake(labelFrame.origin.x, averageLabelFrame.origin.y + averageLabelFrame.size.height) 
                                                              dotImage:[UIImage imageNamed:@"star_comments_hole.png"] 
                                                             starImage:[UIImage imageNamed:@"star_comments.png"] spacing:3];
        [self.contentView addSubview:averageRatingControl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setRating:(MSRating *)r {
    rating = r;
    
    self.movieTitleLabel.text = rating.movie.title;
    self.yearLabel.text = rating.movie.releaseYear;
    [self.movieCoverView setImageURL:[NSURL URLWithString:rating.movie.imageURL]];
    [self.userRatingControl setRating:rating.ratingLevel/2.0];
    [self.averageRatingControl setRating:rating.movie.averageRating/2.0];
}

@end
