//
//  MSRating.m
//  MovieStar
//
//  Created by Dylan Elliott on 4/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import "MSRating.h"

@implementation MSRating
@synthesize ratingID, movie, userID, ratingLevel, comment, timestamp;

- (NSComparisonResult) compareByRating:(MSRating *)otherRating {
    if (self.ratingLevel == otherRating.ratingLevel) {
        return NSOrderedSame;
    } else if (self.ratingLevel < otherRating.ratingLevel) {
        return NSOrderedAscending;
    } else {
        return NSOrderedDescending;
    }
}

- (NSComparisonResult) compareByDate:(MSRating *)otherRating {
    return [self.timestamp compare:otherRating.timestamp];
}

@end
