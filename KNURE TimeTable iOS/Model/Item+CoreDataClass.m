//
//  Item+CoreDataClass.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 03.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "Item+CoreDataClass.h"
#import "Configuration.h"

@implementation Item

- (NSDictionary *)transformToDictionary {
    return @{@"id": self.id, @"title": self.title, @"type": [NSNumber numberWithInt:self.type]};
}

- (void)saveAsSelectedItem {
    NSDictionary *selectedItem = [self transformToDictionary];
    [[NSUserDefaults standardUserDefaults]setObject:selectedItem forKey:TimetableSelectedItem];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:TimetableSelectedItemGroup];
    [sharedDefaults setObject:selectedItem forKey:TimetableSelectedItem];
    [sharedDefaults synchronize];
}

@end

@implementation NSDictionary (Transformation)

- (Item *)transformToNSManagedObject {
    return [Item MR_importFromObject:self];
}

@end
