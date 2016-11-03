//
//  Lesson+CoreDataClass.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 03.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item, NSObject, Subject;

NS_ASSUME_NONNULL_BEGIN

@interface Lesson : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "Lesson+CoreDataProperties.h"
