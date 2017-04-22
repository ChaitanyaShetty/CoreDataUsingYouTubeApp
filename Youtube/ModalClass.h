//
//  ModalClass.h
//  YoutubeTest
//
//  Created by test on 4/17/17.
//  Copyright © 2017 com.neorays. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModalClass : NSObject

@property (strong, nonatomic) NSString *titleString, *descriptionString, *timeString, *imageString, *videoId;

- (instancetype)initWithDict: (NSDictionary *)dictionary;

@end
