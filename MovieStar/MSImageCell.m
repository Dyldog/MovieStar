//
//  MSImageCell.m
//  MovieStar
//
//  Created by Dylan Elliott on 12/02/12.
//  Copyright (c) 2012 Tigerspike. All rights reserved.
//

#import "MSImageCell.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MSImageCell
@synthesize cellLabel;
@synthesize egoImageView;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		egoImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder.png"]];
		egoImageView.frame = CGRectMake((CELL_HEIGHT - COVER_HEIGHT) / 2, (CELL_HEIGHT - COVER_HEIGHT) / 2, COVER_WIDTH, COVER_HEIGHT);
		[self.contentView addSubview:egoImageView];
        
        cellLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        cellLabel.numberOfLines = 0;
        cellLabel.font = [UIFont systemFontOfSize:18];
        cellLabel.textColor = [UIColor blackColor];
        cellLabel.backgroundColor = [UIColor clearColor];
        CGRect labelFrame = cellLabel.bounds;
        labelFrame.origin.x = egoImageView.frame.origin.x + egoImageView.frame.size.width + 4;
        labelFrame.origin.y = 4;
        labelFrame.size.width = 316 - labelFrame.origin.x;
        labelFrame.size.height = 40;
        cellLabel.frame = labelFrame;
        [self.contentView addSubview:cellLabel];
	}
	
    return self;
}

- (void)setCoverPhoto:(NSString *)url {
	egoImageView.imageURL = [NSURL URLWithString:url];
}

- (void)setLabelText:(NSString *)text {
    cellLabel.text = text;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	
	if(!newSuperview) {
		[egoImageView cancelImageLoad];
	}
}

@end
