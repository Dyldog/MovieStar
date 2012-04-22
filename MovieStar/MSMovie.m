//
//  MSMovie.m
//  MovieStar
//
//  Created by Dylan Elliott on 4/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import "MSMovie.h"

@implementation MSMovie

@synthesize wsID;
@synthesize imdbID;
@synthesize imdbURL;
@synthesize title;
@synthesize releaseDate;
@synthesize releaseYear;
@synthesize averageRating;
@synthesize numRatings;
@synthesize ratings;
@synthesize imageURL;

- (NSString *) description {
    return [NSString stringWithFormat:@"MSMovie: \n\tTitle: %@ \n\tRelease Date:%@Average Rating: %.2f \n\tNum Ratings: %.2f \n", self.title, self.releaseDate, self.averageRating, self.numRatings];
}

@end
