//
//  UIMovieButton.h
//  MovieStar
//
//  Created by Dylan Elliott on 4/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface UIMovieButton : UIButton <EGOImageViewDelegate> {
    
    MSMovie *movie;
    
}

@property (nonatomic, strong) MSMovie *movie;

@end
