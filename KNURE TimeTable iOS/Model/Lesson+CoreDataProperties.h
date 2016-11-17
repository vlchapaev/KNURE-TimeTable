//
//  Lesson+CoreDataProperties.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 15.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "Lesson+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Lesson (CoreDataProperties)

+ (NSFetchRequest<Lesson *> *)fetchRequest;
- (NSDate *)day;

@property (nullable, nonatomic, copy) NSString *auditory;
@property (nullable, nonatomic, copy) NSDate *end_time;
@property (nullable, nonatomic, copy) NSNumber *number_pair;
@property (nullable, nonatomic, copy) NSDate *start_time;
@property (nullable, nonatomic, copy) NSNumber *type;
@property (nullable, nonatomic, copy) NSString *brief;
@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) int64_t subject_id;
@property (nonatomic) int64_t item_id;
@property (nullable, nonatomic, retain) NSObject *teachers;
@property (nullable, nonatomic, retain) NSObject *groups;
@property (nullable, nonatomic, copy) NSString *type_brief;
@property (nullable, nonatomic, copy) NSString *type_title;

@end

NS_ASSUME_NONNULL_END
