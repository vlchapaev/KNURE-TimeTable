//
//  Item.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 03.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

@import Foundation;
@import CoreData;

#import <MagicalRecord/MagicalRecord.h>

NS_ASSUME_NONNULL_BEGIN

@interface Item : NSManagedObject

@property (nullable, nonatomic, copy) NSString *full_name;
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSDate *last_update;
@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) int16_t type;

+ (NSFetchRequest<Item *> *)fetchRequest;

- (NSDictionary *)transformToDictionary;

+ (Item *)getSelectedItem;

- (void)removeItemIfSelected;

/**
 Saving NSManagedObject in NSUserDefaults and shared defaults by transforming into NSDictionary
 */
- (void)saveAsSelectedItem;

@end

@interface NSDictionary(Transformation)

/**
 Make a search request for for object with id, if not found returnt new object

 @return NSManagedObject
 */
- (Item *)transformToNSManagedObject;

@end

NS_ASSUME_NONNULL_END
