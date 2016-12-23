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
    [self setupModalView];
}

#pragma mark - Setups

- (void)setupValues {
    self.verticalScrollSwitch.on = [[NSUserDefaults standardUserDefaults]boolForKey:TimetableVerticalMode];
}

- (void)setupModalView {
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Share" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *qrCode = [UIAlertAction actionWithTitle:@"QR Code" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self showQRCode];
        }];
        UIAlertAction *other = [UIAlertAction actionWithTitle:@"Other" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *text = @"KNURE Timetable for iOS";
            NSURL *url = [[NSURL alloc]initWithString:@"https://itunes.apple.com/us/app/knure-sked/id797074875"];
            UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:@[text, url] applicationActivities:nil];
            [self presentViewController:controller animated:YES completion:nil];
        }];
        [controller addAction:qrCode];
        [controller addAction:other];
        [controller addAction:cancel];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark - YSLDraggableCardContainerDataSource

- (UIView *)cardContainerViewNextViewWithIndex:(NSInteger)index {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 300)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qr-code"]];
    [imageView setFrame:view.frame];
    [view addSubview:imageView];
    view.center = self.view.center;
    return view;
}

- (NSInteger)cardContainerViewNumberOfViewInIndex:(NSInteger)index {
    return 1;
}

#pragma mark - Events

- (void)showQRCode {
}

- (IBAction)openGithub {
    NSURL *url = [[NSURL alloc]initWithString:@"https://github.com/ShogunPhyched/KNURE-TimeTable"];
    [[UIApplication sharedApplication]openURL:url];
}

- (IBAction)verticalScrollSwitchValueChanged:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults]setBool:sender.on forKey:TimetableVerticalMode];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)darkModeSwitchValueChanged:(UISwitch *)sender {
}

- (IBAction)removeEmptyDaysSwitchValueChanged:(UISwitch *)sender {
}

@end
