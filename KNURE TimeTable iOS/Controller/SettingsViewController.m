//
//  SettingsViewController.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 08.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "SettingsViewController.h"
#import "TimeTableViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValues];
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
        NSString *text = @"KNURE Timetable for iOS: https://appsto.re/i67M8zB";
        NSURL *url = [[NSURL alloc]initWithString:@"https://itunes.apple.com/us/app/knure-sked/id797074875"];
        UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:@[text, url] applicationActivities:nil];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - Events

- (IBAction)openGithub {
    NSURL *url = [[NSURL alloc]initWithString:@"https://github.com/ShogunPhyched/KNURE-TimeTable"];
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
