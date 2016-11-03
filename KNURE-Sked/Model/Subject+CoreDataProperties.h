//
//  Subject+CoreDataProperties.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 03.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "Subject+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface Subject (CoreDataProperties)

+ (NSFetchRequest<Subject *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *full_name;
@property (nonatomic) int64_t id;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, retain) Lesson *newRelationship;

@end

NS_ASSUME_NONNULL_END
