//
//  Item+CoreDataProperties.h
//  KNURE TimeTable iOS
//
//  Created by Vlad Chapaev on 03.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "Item+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

+ (NSFetchRequest<Item *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *full_name;
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSDate *last_update;
@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) int16_t type;

@end

NS_ASSUME_NONNULL_END
