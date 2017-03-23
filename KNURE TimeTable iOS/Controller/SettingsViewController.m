//
//  SettingsViewController.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 08.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "SettingsViewController.h"
#import "Configuration.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValues];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.preferredContentSize = CGSizeMake(400, 600);
}

#pragma mark - Setups

- (void)setupValues {
    self.verticalScrollSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableVerticalMode];
    self.bouncingCellsSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableBouncingCells];
    self.showEmptyDaysSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableShowEmptyDays];
    self.darkModeSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableIsDarkMode];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.verticalScrollSwitch.enabled = NO;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        NSString *text = NSLocalizedString(@"Settings_Promote", nil);
        NSURL *url = [[NSURL alloc]initWithString:TimetableAppStoreLinkFull];
        UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:@[text, url] applicationActivities:nil];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - Events

- (IBAction)openGithub {
    NSURL *url = [[NSURL alloc]initWithString:TimetableGithubLink];
    [[UIApplication sharedApplication]openURL:url];
}

- (IBAction)verticalScrollSwitchValueChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:TimetableVerticalMode];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)darkModeSwitchValueChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:TimetableIsDarkMode];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)showEmptyDaysSwitchValueChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:TimetableShowEmptyDays];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)bouncingCellsSwitchValueChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:TimetableBouncingCells];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
