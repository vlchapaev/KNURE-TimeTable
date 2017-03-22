//
//  Item+CoreDataClass.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 03.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

@import Foundation;
@import CoreData;

#import <MagicalRecord/MagicalRecord.h>

@class Lesson;

NS_ASSUME_NONNULL_BEGIN

@interface Item : NSManagedObject

- (NSDictionary *)transformToDictionary;

/**
 Saving NSManagedObject in NSUserDefaults and shared defaults by transforming into NSDictionary
 */
- (void)saveAsSelectedItem;

@end

@interface NSDictionary(Transformation)

- (Item *)transformToNSManagedObject;

@end

NS_ASSUME_NONNULL_END

#import "Item+CoreDataProperties.h"
