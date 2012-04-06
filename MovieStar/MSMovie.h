//
//  MSMovie.h
//  MovieStar
//
//  Created by Dylan Elliott on 4/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSMovie : NSObject {
    
    NSString *wsID;
    NSString *imdbID;
    NSString *title;
    NSDate *releaseDate;
    NSString *releaseYear;
    float averageRating;
    int numRatings;
    NSMutableArray *rating;
    NSString *imageURL;
        
}

@property (nonatomic, strong) NSString *wsID;
@property (nonatomic, strong) NSString *imdbID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *releaseDate;
@property (nonatomic, strong) NSString *releaseYear;
@property (nonatomic) float averageRating;
@property (nonatomic) int numRatings;
@property (nonatomic, strong) NSMutableArray *ratings;
@property (nonatomic, strong) NSString *imageURL;

@end
