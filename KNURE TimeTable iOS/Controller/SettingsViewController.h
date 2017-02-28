//
//  SettingsViewController.h
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 08.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ChameleonFramework/Chameleon.h>

@interface SettingsViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UISwitch *verticalScrollSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *darkModeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *removeEmptyDaysSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *bouncingCellsSwitch;

@end
