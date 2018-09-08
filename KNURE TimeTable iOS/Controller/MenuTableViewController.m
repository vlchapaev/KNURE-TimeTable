//
//  MenuTableViewController.m
//  KNURE TimeTable
//
//  Created by Vladislav Chapaev on 21.11.16.
//  Copyright © 2016 Vladislav Chapaev. All rights reserved.
//

#import "MenuTableViewController.h"
#import "ItemsTableViewController.h"
#import "EventParser.h"
#import "Configuration.h"

@interface MenuTableViewController()

@property (strong, nonatomic) NSIndexPath *selectedPath;

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if (self.selectedPath.row == 1) {
        ItemsTableViewController *controller = [[[segue destinationViewController] childViewControllers] objectAtIndex:0];
        controller.itemType = ItemTypeGroup;
        controller.headerTitle = NSLocalizedString(@"ItemList_Groups", nil);
        
    } else if (self.selectedPath.row == 2) {
        ItemsTableViewController *controller = [[[segue destinationViewController] childViewControllers] objectAtIndex:0];
        controller.itemType = ItemTypeTeacher;
        controller.headerTitle = NSLocalizedString(@"ItemList_Teachers", nil);
        
    } else if (self.selectedPath.row == 3) {
        ItemsTableViewController *controller = [[[segue destinationViewController] childViewControllers] objectAtIndex:0];
        controller.itemType = ItemtypeAuditory;
        controller.headerTitle = NSLocalizedString(@"ItemList_Auditories", nil);
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedPath = indexPath;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIView *selectedBackgroundView = [[UIView alloc] init];
    
    if ([Configuration isDarkTheme]) {
        selectedBackgroundView.backgroundColor = [UIColor darkGrayColor];
    } else {
        selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    }
    
    cell.selectedBackgroundView = selectedBackgroundView;
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

@end
