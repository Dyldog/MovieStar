//
//  MovieStarViewController.h
//  MovieStar
//
//  Created by Dylan Elliott on 26/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@class MSImageCell;
@class MSRatingCell;
@interface MovieStarViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MSDataManagerDelegate> {
    
    UIImageView *_backgroundImageView;
    MBProgressHUD *_loadingView;
    UITableView *_tableView;
    
}

- (MSImageCell *) tableView:(UITableView *)tableView imageCellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (MSRatingCell *) tableView:(UITableView *)tableView ratingCellForRowAtIndexPath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) MBProgressHUD *loadingView;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end
