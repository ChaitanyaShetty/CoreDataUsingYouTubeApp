//
//  ViewController.h
//  Youtube
//
//  Created by test on 4/20/17.
//  Copyright © 2017 com.neorays. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *resultsArray, *imageArray, *bookMarkArray;


@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

