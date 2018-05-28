//
//  PopoverComboBoxViewController.h
//  KNURE TimeTable
//
//  Created by Vladislav Chapaev on 26.11.16.
//  Copyright © 2016 Vladislav Chapaev. All rights reserved.
//

@import UIKit;

#import <MagicalRecord/MagicalRecord.h>
#import "EventParser.h"
#import "Item.h"

@protocol PopoverComboBoxViewControllerDelegate <NSObject>

- (void)didSelectComboboxItem:(Item *)item;

@end

@interface PopoverComboBoxViewController : UITableViewController

- (instancetype)initWithDelegate:(id)delegate;

@property (assign, nonatomic) NSInteger selectedItemID;
@property (weak, nonatomic) id <PopoverComboBoxViewControllerDelegate> delegate;

@end
