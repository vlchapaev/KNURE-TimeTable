//
//  PopoverModalViewController.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 01.03.17.
//  Copyright © 2017 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventParser.h"
#import "Lesson+CoreDataClass.h"

@protocol PopoverModalViewControllerDelegate <NSObject>

- (void)didSelectItemWithParameters:(NSDictionary *)parameters;

@end

@interface PopoverModalViewController : UITableViewController

@property (weak, nonatomic) id <PopoverModalViewControllerDelegate> delegate;

- (instancetype)initWithDelegate:(id)delegate andLesson:(Lesson *)lesson;

@end
