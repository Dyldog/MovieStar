//
//  MSRating.h
//  MovieStar
//
//  Created by Dylan Elliott on 4/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSRating : NSObject {
    
    NSString *ratingID;
    NSString *movieID;
    NSString *userID;
    float ratingLevel;
    
}

@property (nonatomic, strong) NSString *ratingID;
@property (nonatomic, strong) NSString *movieID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic) float ratingLevel;

@end
