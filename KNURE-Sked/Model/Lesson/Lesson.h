//
//  Lesson.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 10.10.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Item.h"

@interface Lesson : NSManagedObject

@property (nonatomic, assign) NSInteger subject_id;
@property (nonnull, nonatomic, retain) NSString *title;
@property (nonatomic, assign) NSInteger start_date;
@property (nonatomic, assign) NSInteger end_date;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger type;
@property (nonnull, nonatomic, retain) NSString *auditory;
@property (nonnull, nonatomic, retain) NSArray <Item *>* groups;
@property (nonnull, nonatomic, retain) NSArray <Item *>* teachers;

@end
