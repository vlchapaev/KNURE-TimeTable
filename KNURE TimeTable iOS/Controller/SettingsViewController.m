//
//  SettingsViewController.m
//  KNURE TimeTable
//
//  Created by Vlad Chapaev on 08.11.16.
//  Copyright © 2016 Vlad Chapaev. All rights reserved.
//

#import "SettingsViewController.h"
#import "TimeTableViewController.h"
#import "YSLDraggableCardContainer.h"

@interface SettingsViewController () <YSLDraggableCardContainerDelegate, YSLDraggableCardContainerDataSource>

@property (strong, nonatomic) YSLDraggableCardContainer *container;

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
    self.container = [[YSLDraggableCardContainer alloc]init];
    self.container.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.container.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.container.dataSource = self;
    self.container.delegate = self;
    self.container.canDraggableDirection = YSLDraggableDirectionLeft | YSLDraggableDirectionRight | YSLDraggableDirectionUp;
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

#pragma mark - YSLDraggableCardContainerDelegate

- (void)cardContainerView:(YSLDraggableCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(YSLDraggableDirection)draggableDirection {
    if (draggableDirection == YSLDraggableDirectionLeft) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionRight) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == YSLDraggableDirectionUp) {
        [cardContainerView movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
}

- (void)cardContainerViewDidCompleteAll:(YSLDraggableCardContainer *)container; {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [container removeFromSuperview];
    });
}

#pragma mark - Events

- (void)showQRCode {
    [self.view addSubview:self.container];
    [self.container reloadCardContainer];
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
