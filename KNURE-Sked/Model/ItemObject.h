//
//  ItemObject.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 07.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemObject : NSObject

@property (nullable, nonatomic, copy) NSString *full_name;
@property (nullable, nonatomic, copy) NSNumber *id;
@property (nullable, nonatomic, copy) NSDate *last_update;
@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) int16_t type;

@end
