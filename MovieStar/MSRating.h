//
//  MSRating.h
//  MovieStar
//
//  Created by Dylan Elliott on 4/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSMovie.h"
@interface MSRating : NSObject {
    
    NSString *ratingID;
    MSMovie *movie;
    NSString *userID;
    float ratingLevel;
    
}

@property (nonatomic, strong) NSString *ratingID;
@property (nonatomic, strong) MSMovie *movie;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic) float ratingLevel;

@end
