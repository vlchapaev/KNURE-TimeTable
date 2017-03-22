//
//  SettingsViewController.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 08.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

@import UIKit;

@interface SettingsViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISwitch *verticalScrollSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *darkModeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *showEmptyDaysSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *bouncingCellsSwitch;

@end
