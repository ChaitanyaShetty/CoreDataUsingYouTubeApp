//
//  Entity+CoreDataProperties.h
//  Youtube
//
//  Created by test on 4/22/17.
//  Copyright © 2017 com.neorays. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Entity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Entity (CoreDataProperties)

+ (NSFetchRequest<Entity *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *allData;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t path;
@property (nullable, nonatomic, retain) NSData *image;

@end

NS_ASSUME_NONNULL_END
