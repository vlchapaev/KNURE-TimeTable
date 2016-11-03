//
//  Lesson+CoreDataProperties.m
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 03.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "Lesson+CoreDataProperties.h"

@implementation Lesson (CoreDataProperties)

+ (NSFetchRequest<Lesson *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Lesson"];
}

@dynamic auditory;
@dynamic end_date;
@dynamic groups;
@dynamic item_id;
@dynamic number;
@dynamic start_date;
@dynamic subject_id;
@dynamic teachers;
@dynamic title;
@dynamic type;
@dynamic newRelationship;
@dynamic relationship;

- (NSDate *)day {
    return [[NSCalendar currentCalendar] startOfDayForDate:self.start_date];
}

@end
