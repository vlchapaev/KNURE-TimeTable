//
//  ModalViewController.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 25.12.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

@import UIKit;

#import "EventParser.h"
#import "Lesson.h"
#import "Item.h"

@protocol ModalViewControllerDelegate <NSObject>

- (void)didSelectItem:(Item *)item;

@end

@interface ModalViewController : UIViewController


@property (weak, nonatomic) id <ModalViewControllerDelegate> delegate;

- (instancetype)initWithDelegate:(id)delegate andLesson:(Lesson *)lesson;

@end
