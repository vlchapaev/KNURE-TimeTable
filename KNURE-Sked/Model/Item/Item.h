//
//  Item.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 21.09.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Item : NSManagedObject

@property (nonatomic, assign) NSInteger type;
@property (nullable, nonatomic, retain) NSString *full_name;
@property (nonatomic, assign) NSInteger id;
@property (nonnull, nonatomic, retain) NSString *title;
@property (nonatomic, assign) NSInteger last_update;

@end


