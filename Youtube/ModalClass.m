//
//  ModalClass.m
//  YoutubeTest
//
//  Created by test on 4/17/17.
//  Copyright © 2017 com.neorays. All rights reserved.
//

#import "ModalClass.h"

@implementation ModalClass


- (instancetype)initWithDict:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.titleString = [NSString stringWithFormat:@"%@", [[dictionary valueForKey:@"snippet"]valueForKey:@"title"]];
        self.descriptionString = [NSString stringWithFormat:@"%@", [[dictionary valueForKey:@"snippet"] valueForKey:@"description"]];
        self.timeString = [NSString stringWithFormat:@"%@", [[dictionary valueForKey:@"snippet"] valueForKey:@"publishedAt"]];
        self.imageString = [NSString stringWithFormat:@"%@", [[[[dictionary valueForKey:@"snippet"] valueForKey:@"thumbnails"] valueForKey:@"high"] valueForKey:@"url"]];
        self.videoId = [NSString stringWithFormat:@"%@", [[dictionary valueForKey:@"id"] valueForKey:@"videoId"]];
    }
    return self;
}
@end
