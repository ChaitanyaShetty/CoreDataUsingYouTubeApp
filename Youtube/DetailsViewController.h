//
//  DetailsViewController.h
//  Youtube
//
//  Created by test on 4/20/17.
//  Copyright © 2017 com.neorays. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *tf;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLb;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)play:(id)sender;
- (IBAction)done:(id)sender;

@property (strong, nonatomic) NSString *imageStr;
@property (strong, nonatomic) NSString *descrptionStr, *videoIdString;
@property (assign, nonatomic) int decideFunctionality;
@property (strong, nonatomic) NSData *imageData;
@property (assign, nonatomic) NSInteger path;

@end
