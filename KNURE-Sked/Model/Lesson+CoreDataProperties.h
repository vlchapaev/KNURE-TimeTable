//
//  Lesson+CoreDataProperties.h
//  KNURE TimeTable iOS
//
//  Created by Vlad Chapaev on 03.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "Lesson+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Lesson (CoreDataProperties)

+ (NSFetchRequest<Lesson *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *auditory;
@property (nullable, nonatomic, copy) NSDate *end_date;
@property (nullable, nonatomic, retain) NSObject *groups;
@property (nullable, nonatomic, copy) NSNumber *item_id;
@property (nullable, nonatomic, copy) NSNumber *number;
@property (nullable, nonatomic, copy) NSDate *start_date;
@property (nonatomic) int64_t subject_id;
@property (nullable, nonatomic, retain) NSObject *teachers;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *full_title;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, retain) Subject *newRelationship;
@property (nullable, nonatomic, retain) Item *relationship;

- (NSDate *)day;

@end

NS_ASSUME_NONNULL_END
