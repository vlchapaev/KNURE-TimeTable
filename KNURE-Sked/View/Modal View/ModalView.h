//
//  ModalViewController.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 25.03.16.
//  Copyright © 2016 Shogunate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalView : UIView

@property (strong, nonatomic) IBOutlet UILabel *lesson;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *auditory;
@property (strong, nonatomic) IBOutlet UILabel *groups;
@property (strong, nonatomic) IBOutlet UILabel *teacher;

@end
