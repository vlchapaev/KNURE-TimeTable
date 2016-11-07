//
//  Subject+CoreDataProperties.m
//  KNURE TimeTable iOS
//
//  Created by Vlad Chapaev on 03.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "Subject+CoreDataProperties.h"

@implementation Subject (CoreDataProperties)

+ (NSFetchRequest<Subject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Subject"];
}

@dynamic full_name;
@dynamic id;
@dynamic title;
@dynamic newRelationship;

@end
