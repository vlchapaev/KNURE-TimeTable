//
//  PopoverComboBoxViewController.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 26.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/MagicalRecord.h>
#import "EventParser.h"
#import "Item+CoreDataClass.h"

@protocol PopoverComboBoxViewControllerDelegate <NSObject>

- (void)didSelectComboboxItemWithParameters:(NSDictionary *)item;

@end

@interface PopoverComboBoxViewController : UITableViewController

- (instancetype)initWithDelegate:(id)delegate;

@property (assign, nonatomic) NSInteger selectedItemID;
@property (weak, nonatomic) id <PopoverComboBoxViewControllerDelegate> delegate;

@end
