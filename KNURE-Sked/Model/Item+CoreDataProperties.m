//
//  Item+CoreDataProperties.m
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 03.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "Item+CoreDataProperties.h"

@implementation Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Item"];
}

@dynamic full_name;
@dynamic id;
@dynamic last_update;
@dynamic title;
@dynamic type;
@dynamic relationship;

@end
