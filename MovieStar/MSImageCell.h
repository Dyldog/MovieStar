//
//  MSImageCell.h
//  MovieStar
//
//  Created by Dylan Elliott on 12/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EGOImageView;
@interface MSImageCell : UITableViewCell {
    EGOImageView* egoImageView;
    UILabel *cellLabel;
}

@property (nonatomic, strong) EGOImageView *egoImageView;
@property (nonatomic, strong) UILabel *cellLabel;

- (void)setCoverPhoto:(NSString*)url;
- (void)setLabelText:(NSString *)text;

@end
