////
////  PopoverMenuViewController.m
////  KNURE TimeTable
////
////  Created by Vladislav Chapaev on 26.11.16.
////  Copyright © 2016 Vladislav Chapaev. All rights reserved.
////
//
//#import "PopoverMenuViewController.h"
//#import "ItemsTableViewController.h"
//#import "Configuration.h"
//
//@interface PopoverMenuViewController()
//
//@property (assign, nonatomic) BOOL isDarkTheme;
//
//@end
//
//@implementation PopoverMenuViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationColorThemeDidChage) name:ApplicationDidChangeThemeNotification object:nil];
//    self.isDarkTheme = [Configuration isDarkTheme];
//    
//    self.navigationController.popoverPresentationController.backgroundColor = (self.isDarkTheme) ? ApplicationThemeDarkBackgroundSecondnaryColor : ApplicationThemeLightBackgroundSecondnaryColor;
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    self.navigationController.navigationBarHidden = YES;
//    self.preferredContentSize = CGSizeMake(400, self.tableView.contentSize.height);
//}
//
//#pragma mark - NSNotificationCenter
//
//- (void)applicationColorThemeDidChage {
//    self.isDarkTheme = [Configuration isDarkTheme];
//    self.navigationController.popoverPresentationController.backgroundColor = (self.isDarkTheme) ? ApplicationThemeDarkBackgroundSecondnaryColor : ApplicationThemeLightBackgroundSecondnaryColor;
//}
//
//#pragma mark - UITableViewDelegate 
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row != 3) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        ItemsTableViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ItemsViewController"];
//        if (indexPath.row == 0) {
//            controller.itemType = ItemTypeGroup;
//            controller.headerTitle = NSLocalizedString(@"ItemList_Groups", nil);
//            
//        } else if (indexPath.row == 1) {
//            controller.itemType = ItemTypeTeacher;
//            controller.headerTitle = NSLocalizedString(@"ItemList_Teachers", nil);
//            
//        } else if (indexPath.row == 2) {
//            controller.itemType = ItemtypeAuditory;
//            controller.headerTitle = NSLocalizedString(@"ItemList_Auditories", nil);
//        }
//        [self.navigationController pushViewController:controller animated:YES];
//    }
//}
//
//@end
