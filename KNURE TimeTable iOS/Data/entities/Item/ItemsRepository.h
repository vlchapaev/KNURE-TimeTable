//
//  ItemsRepository.h
//  KNURE TimeTable iOS
//
//  Created by Vladislav Chapaev on 07/02/2019.
//  Copyright © 2019 Vladislav Chapaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

NS_ASSUME_NONNULL_BEGIN

@interface ItemsRepository : NSObject

- (void)remote_items;

- (void)local_selectedItems;
- (void)local_saveItem:(Item *)item;
- (void)local_removeItem:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
