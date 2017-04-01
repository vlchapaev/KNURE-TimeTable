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
    self.preferredContentSize = ApplicationPopoverSize;
}

#pragma mark - Setups

- (void)setupValues {
    self.verticalScrollSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableVerticalMode];
    self.bouncingCellsSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableBouncingCells];
    self.removeEmptyDaysSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableRemoveEmptyDays];
    self.darkModeSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:ApplicationIsDarkTheme];
    self.hintsSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:ApplicationHideHint];
    self.hourlyGridSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableHourlyGridLayout];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.verticalScrollSwitch.enabled = NO;
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Events

- (IBAction)rateButtonTap {
    NSURL *url = [[NSURL alloc]initWithString:ApplicationAppStoreLinkFull];
    [[UIApplication sharedApplication]openURL:url];
}

- (IBAction)shareButtonTap {
    NSString *text = NSLocalizedString(@"Settings_Promote", nil);
    NSURL *url = [[NSURL alloc]initWithString:ApplicationAppStoreLinkShort];
    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:@[text, url] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)openGithub {
    NSURL *url = [[NSURL alloc]initWithString:ApplicationSupportGithubLink];
    [[UIApplication sharedApplication]openURL:url];
}

- (IBAction)openMessanger {
    NSURL *url = [[NSURL alloc]initWithString:ApplicationSupportMessengerLink];
    [[UIApplication sharedApplication]openURL:url];
}

- (IBAction)openTelegram {
    NSURL *url = [[NSURL alloc]initWithString:ApplicationSupportTelegramLink];
    [[UIApplication sharedApplication]openURL:url];
}

- (IBAction)openVkontakte {
    NSURL *url = [[NSURL alloc]initWithString:ApplicationSupportVkontakteLink];
    [[UIApplication sharedApplication]openURL:url];
}

- (IBAction)verticalScrollSwitchValueChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:TimetableVerticalMode];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)darkModeSwitchValueChanged:(UISwitch *)sender {
    if (sender.on) {
        [[Configuration sharedInstance]setDarkTheme];
    } else {
        [[Configuration sharedInstance]setLightTheme];
    }
    
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:ApplicationIsDarkTheme];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[Configuration sharedInstance]applyTheme];
}

- (IBAction)removeEmptyDaysSwitchValueChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:TimetableRemoveEmptyDays];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)bouncingCellsSwitchValueChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:TimetableBouncingCells];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)hintsSwitchValueChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:ApplicationHideHint];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)hourlyGridSwitchValueChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:TimetableHourlyGridLayout];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
