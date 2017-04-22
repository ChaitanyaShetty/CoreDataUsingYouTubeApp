//
//  TableViewCell.h
//  Youtube
//
//  Created by test on 4/20/17.
//  Copyright © 2017 com.neorays. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet UILabel *textLb;
@property (strong, nonatomic) IBOutlet UILabel *titleLb;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLb;
@property (strong, nonatomic) IBOutlet UILabel *timeLb;

@end
