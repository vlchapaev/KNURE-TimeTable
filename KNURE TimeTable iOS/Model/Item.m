//
//  Item.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 03.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "Item.h"
#import "Configuration.h"

@implementation Item

@dynamic full_name;
@dynamic id;
@dynamic last_update;
@dynamic title;
@dynamic type;

+ (NSFetchRequest<Item *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"Item"];
}

+ (Item *)getSelectedItem {
    NSDictionary *selectedItem = [[NSUserDefaults standardUserDefaults]objectForKey:TimetableSelectedItem];
    if (selectedItem) {
        return [selectedItem transformToNSManagedObject];
    } else {
        Item *item = [Item MR_findFirst];
        if (item) {
            [item saveAsSelectedItem];
            return item;
        } else {
            return nil;
        }
    }
}

- (void)removeItemIfSelected {
    NSDictionary *selectedItem = [[NSUserDefaults standardUserDefaults]objectForKey:TimetableSelectedItem];
    if (selectedItem[@"id"] == self.id) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:TimetableSelectedItem];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", self[@"id"]];
    Item *item = [Item MR_findFirstWithPredicate:predicate];
    return (item) ? item : [Item MR_importFromObject:self];
}

@end
