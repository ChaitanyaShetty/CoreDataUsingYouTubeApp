//
//  Entity+CoreDataProperties.m
//  Youtube
//
//  Created by test on 4/22/17.
//  Copyright © 2017 com.neorays. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Entity+CoreDataProperties.h"

@implementation Entity (CoreDataProperties)

+ (NSFetchRequest<Entity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Entity"];
}

@dynamic allData;
@dynamic name;
@dynamic path;
@dynamic image;

@end
