//
//  Subject.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 10.10.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Subject : NSManagedObject

@property (nullable, nonatomic, retain) NSString *full_name;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *id;

@end
