//
//  ModalViewController.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 25.12.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>
#import "EventParser.h"
#import "Lesson+CoreDataClass.h"

@protocol ModalViewControllerDelegate <NSObject>

- (void)didSelectItem:(NSNumber *)itemID title:(NSString *)title ofType:(ItemType)itemType;

@end

@interface ModalViewController : UIViewController


@property (weak, nonatomic) id <ModalViewControllerDelegate> delegate;

- (instancetype)initWithDelegate:(id)delegate andLesson:(Lesson *)lesson;

@end
