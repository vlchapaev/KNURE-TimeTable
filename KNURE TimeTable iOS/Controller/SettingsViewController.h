//
//  SettingsViewController.h
//  KNURE-Sked
//
//  Created by Vlad Chapaev on 08.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISwitch *verticalScrollSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *darkModeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *removeEmptyDaysSwitch;

@end
